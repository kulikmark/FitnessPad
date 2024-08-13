//
//  TrainingsViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.03.2022.
//

//import SwiftUI
//import CoreData
//
//class WorkoutViewModel: ObservableObject {
//    
//    let viewContext = PersistenceController.shared.container.viewContext
//    
//    func saveContext() {
//        do {
//            try viewContext.save()
//            print("Context successfully saved")
//            objectWillChange.send() // Notify view about the changes
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//    }
//    
//     func deleteExercise(_ exercise: Exercise) {
//        viewContext.delete(exercise)
//        do {
//            try viewContext.save()
//        } catch {
//            // Handle the error
//            print("Error saving context after deleting exercise: \(error)")
//        }
//    }
//    
//     func deleteSet(_ set: ExerciseSet) {
//        viewContext.delete(set)
//        do {
//            try viewContext.save()
//        } catch {
//            // Handle the error
//            print("Error saving context after deleting set: \(error)")
//        }
//    }
//    
//    func getExercise(for type: ExerciseType) -> Exercise? {
//        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
//        
//        do {
//            let results = try viewContext.fetch(fetchRequest)
//            return results.first
//        } catch {
//            print("Failed to fetch exercise: \(error)")
//            return nil
//        }
//    }
//
//    func addExercise(workoutDay: WorkoutDay, chosenExerciseType: ExerciseType) {
//        let workoutDay = workoutDay
//        
//        let newExercise = Exercise(context: viewContext)
//        newExercise.type = chosenExerciseType.rawValue
//        newExercise.exerciseName = ExerciseItem.exercises.first { $0.type == chosenExerciseType }?.exerciseName ?? "Unknown"
//        
//        workoutDay.addToExercises(newExercise)
//        
//        saveContext()
//    }
//}


//import SwiftUI
//import CoreData
//
//class WorkoutViewModel: ObservableObject {
//    
//    let viewContext = PersistenceController.shared.container.viewContext
//    
//    func saveContext() {
//        do {
//            try viewContext.save()
//            print("Context successfully saved")
//            objectWillChange.send() // Notify view about the changes
//        } catch {
//            print("Failed to save context: \(error)")
//        }
//    }
//    
//    func deleteExercise(_ exercise: Exercise) {
//        viewContext.delete(exercise)
//        do {
//            try viewContext.save()
//        } catch {
//            // Handle the error
//            print("Error saving context after deleting exercise: \(error)")
//        }
//    }
//    
//    func deleteSet(_ set: ExerciseSet) {
//        viewContext.delete(set)
//        do {
//            try viewContext.save()
//        } catch {
//            // Handle the error
//            print("Error saving context after deleting set: \(error)")
//        }
//    }
//    
//    func getExercise(for exerciseName: String) -> Exercise? {
//        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "exerciseName == %@", exerciseName)
//        
//        do {
//            let results = try viewContext.fetch(fetchRequest)
//            return results.first
//        } catch {
//            print("Failed to fetch exercise: \(error)")
//            return nil
//        }
//    }
//
//    func addExercise(workoutDay: WorkoutDay, chosenExercise: ExerciseItem) {
//        let newExercise = Exercise(context: viewContext)
//        newExercise.exerciseName = chosenExercise.exerciseName
//        
//        // Преобразуйте изображение в Data, если оно не в формате Data
//        if let imageName = chosenExercise.exerciseImage as? String,
//           let image = UIImage(named: imageName),
//           let imageData = image.jpegData(compressionQuality: 1.0) {
//            newExercise.exerciseImage = imageData
//        } else {
//            print("Image not found or invalid format")
//        }
//        
//        workoutDay.addToExercises(newExercise)
//        
//        saveContext()
//    }
//
//}


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
    
    func renameCategory(from oldName: String, to newName: String) {
           let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "exerciseCategory == %@", oldName)

           do {
               let exercises = try viewContext.fetch(fetchRequest)
               for exercise in exercises {
                   exercise.exerciseCategory = newName
               }
               saveContext()
           } catch {
               print("Failed to rename category: \(error.localizedDescription)")
           }
       }
    
    func deleteExercises(in categoryName: String) {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "exerciseCategory == %@ AND exerciseCategory != %@", categoryName, "Default")
        
        do {
            let exercisesToDelete = try viewContext.fetch(fetchRequest)
            for exercise in exercisesToDelete {
                viewContext.delete(exercise)
            }
            try viewContext.save()
        } catch {
            print("Error saving context after deleting exercises: \(error)")
        }
    }
}
