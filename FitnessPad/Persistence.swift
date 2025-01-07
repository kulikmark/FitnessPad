//
//  Persistence.swift
//  FitnessPad
//
//  Created by Марк Кулик on 19.03.2022.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "FitnessPad")

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension PersistenceController {
    func initializeDefaultExercises() async {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<DefaultExercise> = DefaultExercise.fetchRequest()
        let categoryFetchRequest: NSFetchRequest<ExerciseCategory> = ExerciseCategory.fetchRequest()
        
        do {
            let existingExercises = try context.fetch(fetchRequest)
            let existingCategories = try context.fetch(categoryFetchRequest)
            
            if existingExercises.isEmpty {
                for group in defaultExerciseGroups {
                    var category: ExerciseCategory?
                    if let existingCategory = existingCategories.first(where: { $0.name == group.name }) {
                        category = existingCategory
                    } else {
                        category = ExerciseCategory(context: context)
                        category?.name = group.name
                    }
                    
                    for exercise in group.exercises {
                        let defaultExercise = DefaultExercise(context: context)
                        defaultExercise.name = exercise.exerciseName
                        defaultExercise.categories = category
                        
                        if let image = exercise.exerciseImage, let imageData = image.pngData() {
                            defaultExercise.image = imageData
                        }
                        
                        defaultExercise.isDefault = true
                    }
                }
                try context.save()
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


extension PersistenceController {
    func resetDefaultExercises(viewModel: WorkoutViewModel) async {
        let context = container.viewContext

        do {
            // Удаляем все DefaultExercise
            let exerciseFetchRequest: NSFetchRequest<NSFetchRequestResult> = DefaultExercise.fetchRequest()
            let exerciseDeleteRequest = NSBatchDeleteRequest(fetchRequest: exerciseFetchRequest)
            try context.execute(exerciseDeleteRequest)
            
            // Удаляем все ExerciseCategory
            let categoryFetchRequest: NSFetchRequest<NSFetchRequestResult> = ExerciseCategory.fetchRequest()
            let categoryDeleteRequest = NSBatchDeleteRequest(fetchRequest: categoryFetchRequest)
            try context.execute(categoryDeleteRequest)
            
            // Сбрасываем данные (инициализируем дефолтные упражнения и категории)
            await initializeDefaultExercises()
            
            // Перезагружаем упражнения и категории
            viewModel.loadDefaultExercises()
             viewModel.loadCategories()
            
            saveContext() // Сохраняем изменения в контексте
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


