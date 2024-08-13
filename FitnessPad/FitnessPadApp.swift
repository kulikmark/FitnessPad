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
                    // Предварительная загрузка данных при запуске приложения
                    preloadDefaultExercises()
                }
        }
    }
    
    private func preloadDefaultExercises() {
        let viewContext = persistenceController.container.viewContext
        
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        do {
            let existingExercises = try viewContext.fetch(fetchRequest)
            
            // Проверяем, есть ли уже упражнения в базе данных
            if existingExercises.isEmpty {
                for group in defaultExerciseGroups {
                    for item in group.exercises {
                        let exercise = Exercise(context: viewContext)
                        exercise.exerciseName = item.exerciseName
                        exercise.exerciseImage = item.toData()
                        exercise.exerciseCategory = item.categoryName
                        exercise.isDefault = true  // Устанавливаем флаг isDefault для предустановленных упражнений
                        
                        // Добавляем пустые наборы упражнений, если необходимо
                        let newSet = ExerciseSet(context: viewContext)
                        newSet.count = 1
                        newSet.weight = 0.0
                        newSet.reps = 0
                        exercise.addToSets(newSet)

                        // Отладочное сообщение
                        print("Created default exercise: \(exercise.exerciseName ?? "") with isDefault: \(exercise.isDefault)")
                    }
                }
                try viewContext.save()
                print("Saved default exercises.")
            } else {
                print("Default exercises already exist.")
            }
        } catch {
            print("Failed to fetch or save default exercises: \(error)")
        }
    }
}
