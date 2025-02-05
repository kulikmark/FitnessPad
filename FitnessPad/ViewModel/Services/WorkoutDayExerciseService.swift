//
//  WorkoutDayExerciseService.swift
//  FitnessPad
//
//  Created by Марк Кулик on 04.02.2025.
//

import SwiftUI
import CoreData

class WorkoutDayExerciseService: ObservableObject {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Save Context
    func saveContext() {
        do {
            try context.save()
            print("Context saved successfully.")
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch All Exercises
    func fetchWorkoutExercises() -> [Exercise] {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch exercises: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Add Exercise to Workout Day
    func addExerciseToWorkoutDay(_ defaultExercise: DefaultExercise, workoutDay: WorkoutDay?, date: Date) {
        let workoutDay = workoutDay ?? WorkoutDay(context: context)
        workoutDay.id = UUID()
        workoutDay.date = Calendar.current.startOfDay(for: date)

        if workoutDay.exercisesArray.contains(where: { $0.id == defaultExercise.id }) {
            print("Exercise '\(defaultExercise.name ?? "Unknown")' is already added to the workout day.")
            return
        }

        let newExercise = Exercise(context: context)
        newExercise.id = defaultExercise.id
        newExercise.name = defaultExercise.name
        newExercise.image = defaultExercise.image
        newExercise.attributes = defaultExercise.attributes
        newExercise.workoutDay = workoutDay

        saveContext()
    }

    // MARK: - Delete Exercise from Workout Day
    func deleteExerciseFromWorkoutDay(_ exercise: Exercise) {
        guard let workoutDay = exercise.workoutDay else { return }
        context.delete(exercise)

        do {
            try context.save()
            print("Exercise deleted successfully")

            if workoutDay.exercisesArray.isEmpty {
                context.delete(workoutDay)
                try context.save()
                print("WorkoutDay deleted because no exercises are left.")
            }
        } catch {
            print("Error saving context after deleting exercise: \(error)")
        }
    }
    
    // MARK: - Sets Management
    func addSet(to exercise: Exercise) {
        let newSet = ExerciseSet(context: context)
        newSet.count = (exercise.setsArray.last?.count ?? 0) + 1
        
        if let lastSet = exercise.setsArray.last {
            newSet.distance = lastSet.distance
            newSet.time = lastSet.time
            newSet.reps = lastSet.reps
            newSet.weight = lastSet.weight
        } else {
            newSet.distance = 0.0
            newSet.time = 0.0
            newSet.reps = 0
            newSet.weight = 0.0
        }
        
        exercise.addToSets(newSet)
        saveContext()
    }
    
    func deleteSet(_ set: ExerciseSet, in exercise: Exercise) {
        context.delete(set)
        exercise.setsArray.enumerated().forEach { index, set in
            set.count = Int16(index + 1)
        }
        saveContext()
    }
}
