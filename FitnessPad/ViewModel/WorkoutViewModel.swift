//
//  TrainingsViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.03.2022.
//

import SwiftUI
import CoreData

class WorkoutViewModel: ObservableObject {
    @Published var workoutDays: [WorkoutDay] = []
    @Published var selectedGoal: FitnessGoal?
    let viewContext = PersistenceController.shared.container.viewContext
    
    @Published private(set) var workoutDaysCache: [Date: WorkoutDay] = [:]
    
    func saveContext() {
        do {
            try viewContext.save()
            print("Context successfully saved")
            objectWillChange.send() // Notify view about the changes
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func fetchWorkoutDays() {
        // Загружаем данные из CoreData или другого источника
        let request: NSFetchRequest<WorkoutDay> = WorkoutDay.fetchRequest()
        
        do {
            let workoutDays = try viewContext.fetch(request)
            
            // После загрузки данных кэшируем их
            cacheWorkoutDays(from: workoutDays)
        } catch {
            print("Ошибка при получении workoutDays: \(error)")
        }
    }

    func cacheWorkoutDays(from days: [WorkoutDay]) {
        // Кэшируем workoutDays
        workoutDaysCache = Dictionary(uniqueKeysWithValues: days.compactMap { day in
            guard let date = day.date else { return nil }
            return (date, day)
        })
    }

    func workoutDay(for date: Date) -> WorkoutDay? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        return workoutDaysCache.values.first { calendar.isDate($0.date ?? Date(), inSameDayAs: startOfDay) }
    }

    func deleteWorkoutDay(_ workoutDay: WorkoutDay) {
            viewContext.delete(workoutDay)
            saveContext()
        fetchWorkoutDays() 
        }
    
    // Метод для обновления bodyWeight в workoutDay
        func updateBodyWeight(for workoutDay: WorkoutDay, newWeight: Double) {
            workoutDay.bodyWeight = newWeight
            saveContext()
            objectWillChange.send()
        }
     
    func addExercise(_ item: DefaultExerciseItem, workoutDay: WorkoutDay?) {
        guard let workoutDay = workoutDay else { return }
        
        let context = PersistenceController.shared.container.viewContext

        // Проверяем, есть ли уже упражнение с таким именем
        if workoutDay.exercisesArray.contains(where: { $0.name == item.exerciseName }) {
            // Отображаем алерт или логируем сообщение
            print("Exercise '\(item.exerciseName)' is already added to the workout day.")
            return
        }

        // Добавляем новое упражнение
        let newExercise = Exercise(context: context)
        newExercise.name = item.exerciseName
        newExercise.image = item.exerciseImage?.jpegData(compressionQuality: 0.8)
        newExercise.workoutDay = workoutDay

        do {
            try context.save()
            print("Exercise \(item.exerciseName) successfully added to workout day.")
        } catch {
            print("Failed to save exercise: \(error.localizedDescription)")
        }
    }
    
    func addSet(to exercise: Exercise) {
        let newSet = ExerciseSet(context: viewContext)
       
        newSet.count = (exercise.setsArray.last?.count ?? 0) + 1
        newSet.reps = exercise.setsArray.last?.reps ?? 0 // Копируем повторения
        newSet.weight = exercise.setsArray.last?.weight ?? 0.0 // Копируем вес
        exercise.addToSets(newSet)

        saveContext()
    }

    func deleteExercise(_ exercise: Exercise) {
        viewContext.delete(exercise)
        do {
            try viewContext.save()
            print("Exercise deleted successfully")
            objectWillChange.send() // Уведомляем SwiftUI об изменениях
        } catch {
            print("Error saving context after deleting exercise: \(error)")
        }
    }
    
    func deleteSet(_ set: ExerciseSet, in exercise: Exercise) {
           viewContext.delete(set)
           exercise.setsArray.enumerated().forEach { index, set in
               set.count = Int16(index + 1) // Пересчитываем порядок
           }
           saveContext()
       }

}


//func renameCategory(from oldName: String, to newName: String) {
//           let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
//           fetchRequest.predicate = NSPredicate(format: "exerciseCategory == %@", oldName)
//
//           do {
//               let exercises = try viewContext.fetch(fetchRequest)
//               for exercise in exercises {
//                   exercise.category = newName
//               }
//               saveContext()
//           } catch {
//               print("Failed to rename category: \(error.localizedDescription)")
//           }
//       }

    
//    func fetchOrCreateWorkoutDay(for date: Date) -> WorkoutDay {
//        let fetchRequest: NSFetchRequest<WorkoutDay> = WorkoutDay.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "date == %@", date as NSDate)
//
//        do {
//            if let existingWorkoutDay = try viewContext.fetch(fetchRequest).first {
//                return existingWorkoutDay
//            } else {
//                let newWorkoutDay = WorkoutDay(context: viewContext)
//                newWorkoutDay.date = date
//                saveContext()
//                return newWorkoutDay
//            }
//        } catch {
//            print("Failed to fetch or create workout day: \(error)")
//            let fallbackWorkoutDay = WorkoutDay(context: viewContext)
//            fallbackWorkoutDay.date = date
//            return fallbackWorkoutDay
//        }
//    }

//func saveGoal(_ goal: FitnessGoal) {
//        let fetchRequest: NSFetchRequest<UserGoal> = UserGoal.fetchRequest()
//
//        do {
//            let fetchedGoals = try viewContext.fetch(fetchRequest)
//
//            // Удаляем старую цель, если она существует
//            if let existingGoal = fetchedGoals.first {
//                print("Deleting existing goal: \(existingGoal.aim ?? "")")
//                viewContext.delete(existingGoal)
//            }
//
//            // Создаем новую цель
//            let userGoal = UserGoal(context: viewContext)
//            userGoal.aim = goal.rawValue
//
//            // Сохраняем контекст
//            try viewContext.save()
//            print("Successfully saved goal: \(goal.rawValue)")
//
//            // Обновляем selectedGoal
//            self.selectedGoal = goal
//
//        } catch {
//            print("Failed to save user goal: \(error)")
//        }
//    }

//    func fetchUserGoal() {
//        let fetchRequest: NSFetchRequest<UserGoal> = UserGoal.fetchRequest()
//
//        do {
//            let fetchedGoals = try viewContext.fetch(fetchRequest)
//            if let savedGoal = fetchedGoals.first {
//                self.selectedGoal = FitnessGoal(rawValue: savedGoal.aim ?? "")
//            }
//        } catch {
//            print("Failed to fetch user goals: \(error)")
//        }
//    }
