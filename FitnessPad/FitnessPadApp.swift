//
//  FitnessPadApp.swift
//  FitnessPad
//
//  Created by Марк Кулик on 19.03.2022.
//

import SwiftUI
import CoreData

//@main
//struct FitnessPadApp: App {
//    let persistenceController = PersistenceController.shared
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .onAppear {
//                    // Предварительная загрузка данных при запуске приложения
//                    initializeDefaultExercises(container: persistenceController.container)
//                }
//        }
//    }
//
//    func initializeDefaultExercises(container: NSPersistentContainer) {
//        let context = container.viewContext
//        let fetchRequest: NSFetchRequest<DefaultExercise> = DefaultExercise.fetchRequest()
//
//        do {
//            let existingExercises = try context.fetch(fetchRequest)
//            if existingExercises.isEmpty {
//                for group in defaultExerciseGroups {
//                    for exercise in group.exercises {
//                        let defaultExercise = DefaultExercise(context: context)
//                        defaultExercise.name = exercise.exerciseName
//                        defaultExercise.category = exercise.categoryName
//
//                        // Преобразуем UIImage в Data для хранения в Core Data
//                        if let image = exercise.exerciseImage, let imageData = image.pngData() {
//                            defaultExercise.image = imageData
//                        }
//                    }
//                }
//                try context.save()
//            }
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
//
//
//}


@main
struct FitnessPadApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    // Перемещаем инициализацию в асинхронную задачу для предотвращения ошибок с доступом к памяти
                    Task {
                        await initializeDefaultExercises(container: persistenceController.container)
                    }
                }
        }
    }
    
//    func initializeDefaultExercises(container: NSPersistentContainer) async {
//        let context = container.viewContext
//        let fetchRequest: NSFetchRequest<DefaultExercise> = DefaultExercise.fetchRequest()
//        
//        do {
//            let existingExercises = try context.fetch(fetchRequest)
//            
//            if existingExercises.isEmpty {
//                for group in defaultExerciseGroups {
//                    for exercise in group.exercises {
//                        let defaultExercise = DefaultExercise(context: context)
//                        
//                        // Убедитесь, что имя и категория передаются корректно
//                        defaultExercise.name = exercise.exerciseName
//                        defaultExercise.category = exercise.categoryName // Устанавливаем категорию
//                        
//                        // Преобразуем UIImage в Data для хранения в Core Data
//                        if let image = exercise.exerciseImage, let imageData = image.pngData() {
//                            defaultExercise.image = imageData
//                        }
//                        
//                        // Устанавливаем флаг isDefault в true для предустановленных упражнений
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

    func initializeDefaultExercises(container: NSPersistentContainer) async {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<DefaultExercise> = DefaultExercise.fetchRequest()
        let categoryFetchRequest: NSFetchRequest<ExerciseCategory> = ExerciseCategory.fetchRequest()
        
        do {
            let existingExercises = try context.fetch(fetchRequest)
            let existingCategories = try context.fetch(categoryFetchRequest)
            
            if existingExercises.isEmpty {
                for group in defaultExerciseGroups {
                    // Проверяем или создаем категорию
                    var category: ExerciseCategory?
                    if let existingCategory = existingCategories.first(where: { $0.name == group.name }) {
                        category = existingCategory
                    } else {
                        category = ExerciseCategory(context: context)
                        category?.name = group.name
                    }
                    
                    // Создаем упражнения для группы
                    for exercise in group.exercises {
                        let defaultExercise = DefaultExercise(context: context)
                        defaultExercise.name = exercise.exerciseName
                        defaultExercise.categories = category // Присваиваем категорию
                        
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
