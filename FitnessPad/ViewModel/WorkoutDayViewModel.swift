//
//  TrainingsViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.03.2022.
//

import SwiftUI
import CoreData

class WorkoutDayViewModel: ObservableObject {
    @Published var workoutDaysCache: [Date: WorkoutDay] = [:]
    
    private let workoutDayService: WorkoutDayService
    private let workoutDayExerciseService: WorkoutDayExerciseService
    
    init(
        workoutDayService: WorkoutDayService,
        bodyWeightService: BodyWeightService,
        workoutDayExerciseService: WorkoutDayExerciseService
    ) {
        self.workoutDayService = workoutDayService
        self.workoutDayExerciseService = workoutDayExerciseService
        
        fetchWorkoutDays()
    }
    
    // MARK: - Workout Days Management
    
    /// Загружает тренировочные дни и кэширует их.
    func fetchWorkoutDays() {
        let workoutDays = workoutDayService.fetchWorkoutDays()
        workoutDaysCache = workoutDayService.cacheWorkoutDays(from: workoutDays)
    }
    
    /// Возвращает тренировочный день для указанной даты.
    func workoutDay(for date: Date) -> WorkoutDay? {
        workoutDayService.workoutDay(for: date, in: workoutDaysCache)
    }
    
    var sortedWorkoutDays: [WorkoutDay] {
        workoutDaysCache.values.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
    }
    
    /// Создает или обновляет тренировочный день для указанной даты.
    func createOrUpdateWorkoutDay(for date: Date) -> WorkoutDay {
        workoutDayService.createOrUpdateWorkoutDay(for: date)
    }
    
    /// Удаляет тренировочный день.
    func deleteWorkoutDay(_ workoutDay: WorkoutDay) {
        workoutDayService.deleteWorkoutDay(workoutDay)
        fetchWorkoutDays()
    }
    
    // MARK: - WorkoutDay Exercise Management
    
    func addExerciseToWorkoutDay(_ exercise: DefaultExercise, date: Date) {
        let workoutDay = self.workoutDay(for: date) ?? createOrUpdateWorkoutDay(for: date)
        workoutDayExerciseService.addExerciseToWorkoutDay(exercise, workoutDay: workoutDay, date: date)
        fetchWorkoutDays()
    }
    
    func deleteExerciseFromWorkoutDay(_ exercise: Exercise) {
        workoutDayExerciseService.deleteExerciseFromWorkoutDay(exercise)
        fetchWorkoutDays()
    }
    
    // MARK: - Sets Management
    func addSet(to exercise: Exercise) {
        workoutDayExerciseService.addSet(to: exercise)
        fetchWorkoutDays()
    }
    
    func deleteSet(_ set: ExerciseSet, from exercise: Exercise) {
        workoutDayExerciseService.deleteSet(set, in: exercise)
        fetchWorkoutDays()
    }
}
