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

//extension PersistenceController {
//    func initializeDefaultExercises() {
//        let context = container.viewContext
//        
//        // Проверяем, есть ли уже упражнения в Core Data
//        let fetchRequest: NSFetchRequest<DefaultExercise> = DefaultExercise.fetchRequest()
//        let categoryFetchRequest: NSFetchRequest<ExerciseCategory> = ExerciseCategory.fetchRequest()
//        
//        do {
//            let existingExercises = try context.fetch(fetchRequest)
//            
//            // Если упражнения уже есть, выходим
//            if !existingExercises.isEmpty {
//                print("Default exercises already exist. Skipping initialization.")
//                return
//            }
//            
//            // Инициализация дефолтных упражнений
//            for group in defaultExerciseGroups {
//                // Проверяем, существует ли категория, или создаем новую
//                let category = try context.fetch(categoryFetchRequest).first(where: { $0.name == group.name }) ?? {
//                    let newCategory = ExerciseCategory(context: context)
//                    newCategory.name = group.name
//                    newCategory.isDefault = true
//                    return newCategory
//                }()
//                
//                // Создаем упражнения для этой категории
//                for exercise in group.exercises {
//                    let defaultExercise = DefaultExercise(context: context)
//                    defaultExercise.id = exercise.id
//                    defaultExercise.name = exercise.exerciseName
//                    defaultExercise.categories = category
//                    
//                    for attributeItem in exercise.attributeItems {
//                        let attribute = ExerciseAttribute(context: context)
//                        attribute.name = attributeItem.name
//                        attribute.isAdded = attributeItem.isAdded
//                        defaultExercise.addToAttributes(attribute)
//                        print("Added attribute: \(attribute.name ?? "Unnamed") to exercise: \(defaultExercise.name ?? "Unknown")")
//                    }
//                    
//                    // Добавляем изображение
//                    if let image = exercise.exerciseImage, let imageData = image.pngData() {
//                        defaultExercise.image = imageData
//                    }
//                    
//                    defaultExercise.isDefault = true
//                    
//                    // Логирование для отладки
//                    print("Created exercise: \(defaultExercise.name ?? "Unknown")")
//                }
//            }
//            
//            // Сохраняем контекст
//            try context.save()
//            print("Default exercises initialized successfully.")
//            
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
//}

// MARK: - Initialize Default Exercises in Core Data
extension PersistenceController {
    func initializeDefaultExercises() {
        let context = container.viewContext

        // Проверяем, есть ли уже упражнения в Core Data
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DefaultExercise")
//        let categoryFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ExerciseCategory")

        do {
            let existingExercises = try context.fetch(fetchRequest)

            // Если упражнения уже есть, выходим
            if !existingExercises.isEmpty {
                print("Default exercises already exist. Skipping initialization.")
                return
            }

            // Инициализация дефолтных упражнений
            for exercise in exerciseItems {
                // Проверяем, существует ли категория, или создаем новую
                let categoryName = exercise.categoryName ?? "Uncategorized"
                let categoryFetchRequest: NSFetchRequest<ExerciseCategory> = ExerciseCategory.fetchRequest()
                categoryFetchRequest.predicate = NSPredicate(format: "name == %@", categoryName)

                let category = try context.fetch(categoryFetchRequest).first ?? {
                    let newCategory = ExerciseCategory(context: context)
                    newCategory.name = categoryName
                    newCategory.isDefault = true
                    return newCategory
                }()

                // Создаем упражнение
                let defaultExercise = DefaultExercise(context: context)
                defaultExercise.id = exercise.id
                defaultExercise.isDefault = true
                defaultExercise.name = exercise.exerciseName
                defaultExercise.categories = category
                defaultExercise.isFavourite = exercise.isFavourite
                defaultExercise.exerciseDescription = exercise.exerciseDescription
                defaultExercise.video = exercise.video

                // Добавляем атрибуты
                for attributeItem in exercise.attributeItems {
                    let attribute = ExerciseAttribute(context: context)
                    attribute.name = attributeItem.name
                    attribute.isAdded = attributeItem.isAdded
                    defaultExercise.addToAttributes(attribute)
                }

                // Добавляем изображение
                if let image = exercise.exerciseImage, let imageData = image.pngData() {
                    defaultExercise.image = imageData
                }

                // Логирование для отладки
                print("Created exercise: \(defaultExercise.name ?? "Unknown")")
            }

            // Сохраняем контекст
            try context.save()
            print("Default exercises initialized successfully.")

        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

extension PersistenceController {
    func resetDefaultExercises(viewModel: WorkoutViewModel) {
        let context = container.viewContext
        
        do {
            // Удаляем все DefaultExercise
            let exerciseFetchRequest: NSFetchRequest<NSFetchRequestResult> = DefaultExercise.fetchRequest()
            let exerciseDeleteRequest = NSBatchDeleteRequest(fetchRequest: exerciseFetchRequest)
            try context.execute(exerciseDeleteRequest)
            print("All default exercises deleted.")
            
            // Удаляем все ExerciseCategory
            let categoryFetchRequest: NSFetchRequest<NSFetchRequestResult> = ExerciseCategory.fetchRequest()
            let categoryDeleteRequest = NSBatchDeleteRequest(fetchRequest: categoryFetchRequest)
            try context.execute(categoryDeleteRequest)
            print("All categories deleted.")
            
            // Инициализируем дефолтные упражнения и категории
             initializeDefaultExercises()
            print("Default exercises reinitialized.")
            
            // Перезагружаем данные в ViewModel
            viewModel.loadDefaultExercises()
            viewModel.loadCategories()
            print("ViewModel data reloaded.")
            
            // Сохраняем изменения в контексте
            try context.save()
            print("Context saved successfully.")
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

//extension PersistenceController {
//    func reset() {
//        let context = container.viewContext
//        
//        // Удаляем все объекты из Core Data
//        let entities = container.managedObjectModel.entities
//        for entity in entities {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//            
//            do {
//                try context.execute(deleteRequest)
//                try context.save()
//                print("All \(entity.name ?? "Unknown") entities deleted.")
//            } catch {
//                print("Failed to delete entities: \(error)")
//            }
//        }
//    }
//}
