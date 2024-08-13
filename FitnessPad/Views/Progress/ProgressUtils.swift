//
//  calculateProgress.swift
//  FitnessPad
//
//  Created by Марк Кулик on 10.08.2024.
//

import SwiftUI
import CoreData

struct ProgressUtils {
    
    static func calculateProgress(in context: NSManagedObjectContext) -> [ExerciseProgress] {
        let fetchRequest: NSFetchRequest<WorkoutDay> = WorkoutDay.fetchRequest()
        
        do {
            let workoutDays = try context.fetch(fetchRequest)
            var exerciseDict = [String: (startWeight: Double, maxWeight: Double, startDate: Date, endDate: Date)]()
            
            for day in workoutDays {
                if let exercises = day.exercises?.allObjects as? [Exercise] {
                    for exercise in exercises {
                        if let name = exercise.exerciseName, let sets = exercise.sets?.allObjects as? [ExerciseSet], let date = day.date {
                            let maxSetWeight = sets.map { $0.weight }.max() ?? 0.0
                            
                            if exerciseDict[name] == nil {
                                exerciseDict[name] = (startWeight: maxSetWeight, maxWeight: maxSetWeight, startDate: date, endDate: date)
                            } else {
                                if var exerciseData = exerciseDict[name] {
                                    exerciseData.maxWeight = max(exerciseData.maxWeight, maxSetWeight)
                                    exerciseData.endDate = date
                                    exerciseDict[name] = exerciseData
                                } else {
                                    exerciseDict[name] = (startWeight: maxSetWeight, maxWeight: maxSetWeight, startDate: date, endDate: date)
                                }
                            }
                        }
                    }
                }
            }
            
            return exerciseDict.map { (name, data) in
                let progressPercentage = ((data.maxWeight - data.startWeight) / max(data.startWeight, 1.0)) * 100
                return ExerciseProgress(exerciseName: name, progressPercentage: progressPercentage, weightGain: data.maxWeight - data.startWeight, startDate: data.startDate, endDate: data.endDate)
            }
            
        } catch {
            print("Failed to fetch workout days: \(error)")
            return []
        }
    }
    
    static func getUserGoal(in context: NSManagedObjectContext) -> UserGoal? {
        let fetchRequest: NSFetchRequest<UserGoal> = UserGoal.fetchRequest()
        
        do {
            let goals = try context.fetch(fetchRequest)
            return goals.first
        } catch {
            print("Failed to fetch user goals: \(error)")
            return nil
        }
    }
    
    static func calculateWeightChange(in context: NSManagedObjectContext) -> Double {
        let fetchRequest: NSFetchRequest<WorkoutDay> = WorkoutDay.fetchRequest()
        
        do {
            let workoutDays = try context.fetch(fetchRequest)
            let weights = workoutDays.map { $0.bodyWeight }
            guard let minWeight = weights.min(), let maxWeight = weights.max() else { return 0.0 }
            return maxWeight - minWeight
        } catch {
            print("Failed to fetch workout days: \(error)")
            return 0.0
        }
    }
}
