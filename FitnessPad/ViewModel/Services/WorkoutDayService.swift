//
//  WorkoutDayService.swift
//  FitnessPad
//
//  Created by Марк Кулик on 03.02.2025.
//

import Foundation
import CoreData

class WorkoutDayService {
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

    // MARK: - Fetch Workout Days
    func fetchWorkoutDays() -> [WorkoutDay] {
        let request: NSFetchRequest<WorkoutDay> = WorkoutDay.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch workout days: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Cache Workout Days
    func cacheWorkoutDays(from days: [WorkoutDay]) -> [Date: WorkoutDay] {
        return Dictionary(uniqueKeysWithValues: days.compactMap { day in
            guard let date = day.date else { return nil }
            return (date, day)
        })
    }

    // MARK: - Get Workout Day for Date
    func workoutDay(for date: Date, in cache: [Date: WorkoutDay]) -> WorkoutDay? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return cache.values.first { calendar.isDate($0.date ?? Date(), inSameDayAs: startOfDay) }
    }

    // MARK: - Create or Update Workout Day
    func createOrUpdateWorkoutDay(for date: Date) -> WorkoutDay {
        let workoutDay = WorkoutDay(context: context)
        workoutDay.id = UUID()
        workoutDay.date = Calendar.current.startOfDay(for: date)
        return workoutDay
    }

    // MARK: - Delete Workout Day
    func deleteWorkoutDay(_ workoutDay: WorkoutDay) {
        context.delete(workoutDay)
        saveContext()
    }
}
