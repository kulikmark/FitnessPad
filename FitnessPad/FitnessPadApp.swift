//
//  FitnessPadApp.swift
//  FitnessPad
//
//  Created by Марк Кулик on 19.03.2022.
//

import SwiftUI
import CoreData

@main
struct FitnessPadApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    Task {
                        await persistenceController.initializeDefaultExercises()
                    }
                }
        }
    }
}


//    func initializeDefaultExercises(container: NSPersistentContainer) async {
//        let context = container.viewContext
//        let fetchRequest: NSFetchRequest<DefaultExercise> = DefaultExercise.fetchRequest()
//        let categoryFetchRequest: NSFetchRequest<ExerciseCategory> = ExerciseCategory.fetchRequest()
//        
//        do {
//            let existingExercises = try context.fetch(fetchRequest)
//            let existingCategories = try context.fetch(categoryFetchRequest)
//            
//            if existingExercises.isEmpty {
//                for group in defaultExerciseGroups {
//                    // Проверяем или создаем категорию
//                    var category: ExerciseCategory?
//                    if let existingCategory = existingCategories.first(where: { $0.name == group.name }) {
//                        category = existingCategory
//                    } else {
//                        category = ExerciseCategory(context: context)
//                        category?.name = group.name
//                    }
//                    
//                    // Создаем упражнения для группы
//                    for exercise in group.exercises {
//                        let defaultExercise = DefaultExercise(context: context)
//                        defaultExercise.name = exercise.exerciseName
//                        defaultExercise.categories = category // Присваиваем категорию
//                        
//                        if let image = exercise.exerciseImage, let imageData = image.pngData() {
//                            defaultExercise.image = imageData
//                        }
//                        
//                        defaultExercise.isDefault = true
//                    }
//                }
//                try context.save()
//            }
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
