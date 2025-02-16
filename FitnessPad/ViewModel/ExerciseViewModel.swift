//
//  ExerciseViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 04.02.2025.
//

import SwiftUI
import CoreData

class ExerciseViewModel: ObservableObject {
    @Published var allCategories: [ExerciseCategory] = []
    @Published var allDefaultExercises: [DefaultExercise] = []
    @Published var selectedExercise: DefaultExercise?
    @Published var isEditingExercise = false
 
    private let defaultExerciseService: ExerciseService
    private let exerciseCategoryService: ExerciseCategoryService
    private var workoutDaysCache: [Date: WorkoutDay] // Добавляем переменную
    
    init(
        defaultExerciseService: ExerciseService,
        exerciseCategoryService: ExerciseCategoryService,
        workoutDaysCache: [Date: WorkoutDay] // Принимаем workoutDaysCache
    ) {
        self.defaultExerciseService = defaultExerciseService
        self.exerciseCategoryService = exerciseCategoryService
        self.workoutDaysCache = workoutDaysCache // Сохраняем переданный workoutDaysCache
        
        loadCategories()
        loadDefaultExercises()
    }
    
    // MARK: - Category Management
    func loadCategories() {
        allCategories = exerciseCategoryService.loadCategories()
    }
    
    func addCategory(_ category: String) {
        exerciseCategoryService.addNewCategory(category)
    }
    
    func deleteCategory(_ category: ExerciseCategory) {
        exerciseCategoryService.deleteCategory(category)
    }
    
    // MARK: - Exercises Management
    func loadDefaultExercises() {
        allDefaultExercises = defaultExerciseService.loadDefaultExercises()
    }
    
    var allDefaultExercisesGroupedByCategory: [(category: String, exercises: [DefaultExercise])] {
        defaultExerciseService.groupDefaultExercisesByCategory(allDefaultExercises)
    }
    
    func toggleFavourite(for exercise: DefaultExercise) {
        defaultExerciseService.toggleFavourite(for: exercise)
        loadDefaultExercises()
    }
    
    // MARK: - Exercises Core Data Management
    func addExerciseToCoreData(name: String, exerciseDescription: String, category: ExerciseCategory?, image: UIImage?, video: Data?, attributes: Set<String>, isDefault: Bool = false) {
        defaultExerciseService.addExerciseToCoreData(name: name, exerciseDescription: exerciseDescription, category: category, image: image, video: video, attributes: attributes, isDefault: isDefault)
        loadDefaultExercises()
    }
    
    func updateExerciseInCoreData(exercise: DefaultExercise, name: String, exerciseDescription: String, category: ExerciseCategory?, image: UIImage?, video: Data?, attributes: Set<String>) {
        defaultExerciseService.updateExerciseInCoreData(exercise, name: name, exerciseDescription: exerciseDescription, category: category, image: image, video: video, attributes: attributes)
        loadDefaultExercises()
    }
    
    func deleteExerciseFromCoreData(exercise: DefaultExercise) {
        defaultExerciseService.deleteExerciseFromCoreData(exercise, workoutDaysCache: workoutDaysCache)
        loadDefaultExercises()
    }
     
}
