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
           let fetchRequest: NSFetchRequest<WorkoutDay> = WorkoutDay.fetchRequest()
           let sortDescriptor = NSSortDescriptor(keyPath: \WorkoutDay.date, ascending: true)
           fetchRequest.sortDescriptors = [sortDescriptor]
           
           do {
               workoutDays = try viewContext.fetch(fetchRequest)
           } catch {
               print("Failed to fetch workout days: \(error.localizedDescription)")
           }
       }
    
    func workoutDay(for date: Date) -> WorkoutDay? {
        return workoutDays.first { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }
    }

    
    func fetchUserGoal() {
        let fetchRequest: NSFetchRequest<UserGoal> = UserGoal.fetchRequest()
        
        do {
            let fetchedGoals = try viewContext.fetch(fetchRequest)
            if let savedGoal = fetchedGoals.first {
                self.selectedGoal = FitnessGoal(rawValue: savedGoal.aim ?? "")
            }
        } catch {
            print("Failed to fetch user goals: \(error)")
        }
    }
    
    func saveGoal(_ goal: FitnessGoal) {
        let fetchRequest: NSFetchRequest<UserGoal> = UserGoal.fetchRequest()
        
        do {
            let fetchedGoals = try viewContext.fetch(fetchRequest)
            
            // Удаляем старую цель, если она существует
            if let existingGoal = fetchedGoals.first {
                print("Deleting existing goal: \(existingGoal.aim ?? "")")
                viewContext.delete(existingGoal)
            }
            
            // Создаем новую цель
            let userGoal = UserGoal(context: viewContext)
            userGoal.aim = goal.rawValue
            
            // Сохраняем контекст
            try viewContext.save()
            print("Successfully saved goal: \(goal.rawValue)")
            
            // Обновляем selectedGoal
            self.selectedGoal = goal
            
        } catch {
            print("Failed to save user goal: \(error)")
        }
    }

    func addExerciseToWorkoutDay(_ exercise: Exercise, for workoutDay: WorkoutDay) {
           workoutDay.addToExercises(exercise)
           
           do {
               try viewContext.save()
           } catch {
               print("Failed to save context with error: \(error)")
           }
       }
    
    func deleteExercise(_ exercise: Exercise) {
        viewContext.delete(exercise)
        do {
            try viewContext.save()
        } catch {
            print("Error saving context after deleting exercise: \(error)")
        }
    }
    
    func deleteSet(_ set: ExerciseSet) {
        viewContext.delete(set)
        do {
            try viewContext.save()
        } catch {
            print("Error saving context after deleting set: \(error)")
        }
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
