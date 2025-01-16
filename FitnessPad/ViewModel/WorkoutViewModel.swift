//
//  TrainingsViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.03.2022.
//

import SwiftUI
import CoreData

class WorkoutViewModel: ObservableObject {
    @Published private(set) var workoutDaysCache: [Date: WorkoutDay] = [:]
    @Published var allCategories: [ExerciseCategory] = []
    @Published var allDefaultExercises: [DefaultExercise] = []
    @Published var selectedGoal: FitnessGoal?
    let viewContext = PersistenceController.shared.container.viewContext
    
    init() {
        loadDefaultExercises()
        fetchWorkoutDays()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
            print("Context successfully saved")
            objectWillChange.send() // Notify view about the changes
        } catch {
            print("Failed to save context: \(error)")
        }
    }
   
//    func fetchWorkoutDays() {
//        let request: NSFetchRequest<WorkoutDay> = WorkoutDay.fetchRequest()
//        
//        do {
//            let workoutDays = try viewContext.fetch(request)
//            cacheWorkoutDays(from: workoutDays)
//        } catch {
//            print("Ошибка при получении workoutDays: \(error)")
//        }
//    }
    
    func fetchWorkoutDays() {
          DispatchQueue.global(qos: .userInitiated).async {
              let request: NSFetchRequest<WorkoutDay> = WorkoutDay.fetchRequest()
              
              do {
                  let workoutDays = try self.viewContext.fetch(request)
                  DispatchQueue.main.async {
                      self.cacheWorkoutDays(from: workoutDays)
                  }
              } catch {
                  DispatchQueue.main.async {
                      print("Ошибка при получении workoutDays: \(error)")
                  }
              }
          }
      }

    func cacheWorkoutDays(from days: [WorkoutDay]) {
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
    
    // MARK: - Отсортированные тренировки
    var sortedWorkoutDays: [WorkoutDay] {
       workoutDaysCache.values.sorted {
            ($0.date ?? Date()) < ($1.date ?? Date())
        }
    }
    
    func createWorkoutDay(for date: Date) {
        let newWorkoutDay = WorkoutDay(context: viewContext)
        newWorkoutDay.date = Calendar.current.startOfDay(for: date)
        saveContext()
        fetchWorkoutDays()
        objectWillChange.send()
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
    
    func loadEntities<T: NSManagedObject>(_ entityType: T.Type, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let fetchRequest = T.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors

        do {
            return try viewContext.fetch(fetchRequest) as? [T] ?? []
        } catch {
            print("Failed to fetch \(T.self): \(error.localizedDescription)")
            return []
        }
    }

   
//    func loadDefaultExercises() {
//        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        allDefaultExercises = loadEntities(DefaultExercise.self, sortDescriptors: [sortDescriptor])
//    }
    
    func loadDefaultExercises() {
        guard allDefaultExercises.isEmpty else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let exercises = self.loadEntities(DefaultExercise.self, sortDescriptors: [sortDescriptor])
            
            DispatchQueue.main.async {
                self.allDefaultExercises = exercises
            }
        }
    }


//    func loadCategories() {
//        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        allCategories = loadEntities(ExerciseCategory.self, sortDescriptors: [sortDescriptor])
//    }

    func loadCategories() {
        DispatchQueue.global(qos: .userInitiated).async {
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let categories = self.loadEntities(ExerciseCategory.self, sortDescriptors: [sortDescriptor])
            
            DispatchQueue.main.async {
                self.allCategories = categories
            }
        }
    }

    var allDefaultExercisesGroupedByCategory: [(category: String, exercises: [DefaultExercise])] {
        let filteredExercises = allDefaultExercises.filter { $0.categories != nil } // Исключаем упражнения без категории
        let grouped = Dictionary(grouping: filteredExercises) { $0.categories?.name ?? "Uncategorized" }
        
        let sortedKeys = grouped.keys.sorted()
        
        return sortedKeys.map { key in
            (category: key, exercises: grouped[key] ?? [])
        }
    }
    
    func addNewCategory(_ category: String) {
        let newCategory = ExerciseCategory(context: viewContext)
        newCategory.name = category
        newCategory.isDefault = false
        saveContext()
        allCategories.append(newCategory) // Добавляем объект категории, а не строку
        print("\(newCategory.name ?? "Unnamed") category was just created")
    }

    func deleteCategory(_ category: ExerciseCategory) {
        let fetchRequest: NSFetchRequest<ExerciseCategory> = ExerciseCategory.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", category.name ?? "")
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            if let categoryObject = result.first {
                viewContext.delete(categoryObject)
                saveContext()
            }
        } catch {
            print("Failed to fetch category: \(error)")
        }
        
        allCategories.removeAll { $0 == category } // Удаляем объект категории из списка
    }

    
    func addExerciseToWorkoutDay(_ defaultExercise: DefaultExercise, workoutDay: WorkoutDay?) {
        objectWillChange.send()
        
        guard let workoutDay = workoutDay else { return }

        let context = PersistenceController.shared.container.viewContext

        if workoutDay.exercisesArray.contains(where: { $0.id == defaultExercise.id }) {
            print("Exercise '\(defaultExercise.name ?? "Unknown")' is already added to the workout day.")
            return
        }
        // Добавляем новое упражнение
        let newExercise = Exercise(context: context)
        newExercise.id = defaultExercise.id
        newExercise.name = defaultExercise.name
        newExercise.image = defaultExercise.image
       
        newExercise.attributes = defaultExercise.attributes
        newExercise.workoutDay = workoutDay

        // Сохраняем изменения
        do {
            try context.save()
            print("Exercise \(defaultExercise.name ?? "Unknown") successfully added to workout day.")
        } catch {
            print("Failed to save exercise: \(error.localizedDescription)")
        }
    }
    
    func addSet(to exercise: Exercise) {
        let newSet = ExerciseSet(context: viewContext)
        
        // Определяем новый номер сета
        newSet.count = (exercise.setsArray.last?.count ?? 0) + 1

        // Копируем значения из последнего сета или устанавливаем дефолтные значения
        if let lastSet = exercise.setsArray.last {
            newSet.distance = lastSet.distance // Копируем дистанцию
            newSet.time = lastSet.time // Копируем время
            newSet.reps = lastSet.reps // Копируем повторения
            newSet.weight = lastSet.weight // Копируем вес
        } else {
            // Если нет предыдущих сетов, устанавливаем значения по умолчанию
            newSet.distance = 0.0
            newSet.time = 0.0
            newSet.reps = 0
            newSet.weight = 0.0
        }
        
        // Добавляем новый сет к упражнению
        exercise.addToSets(newSet)
        
        // Сохраняем изменения
        saveContext()
    }

    func deleteExerciseFromWorkoutDay(_ exercise: Exercise) {
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
    
    func deleteExerciseFromCoreData(_ exercise: DefaultExercise) {
        guard let exerciseId = exercise.id else {
            print("Exercise ID is nil, cannot proceed with deletion.")
            return
        }

        // Удаляем упражнения из тренировочных дней
        workoutDaysCache.forEach { (_, workoutDay) in
            if let exercisesSet = workoutDay.exercises as? Set<Exercise> {
                // Отфильтровываем упражнения, у которых ID не совпадает
                let filteredExercises = exercisesSet.filter { $0.id != exerciseId }
                
                // Обновляем связь exercises для WorkoutDay
                workoutDay.exercises = NSSet(set: filteredExercises)
                
                print("Updated exercises for workout day: \(filteredExercises.map { $0.name ?? "Unnamed Exercise" })")
            }
        }

        // Сохраняем изменения в Core Data
        saveContext()

        print("Exercise with ID \(exerciseId) successfully deleted from all workout days.")
    }

    func updateExerciseInWorkoutDays(exercise: DefaultExercise) {
        guard let exerciseId = exercise.id else {
            print("Exercise ID is nil, cannot proceed with update.")
            return
        }

        // Обходим все тренировочные дни
        workoutDaysCache.forEach { (_, workoutDay) in
            if let exercisesSet = workoutDay.exercises as? Set<Exercise> {
                // Находим упражнения с совпадающим ID
                exercisesSet.forEach { exerciseInDay in
                    if exerciseInDay.id == exerciseId {
                        // Обновляем свойства упражнения
                        exerciseInDay.name = exercise.name
                        exerciseInDay.image = exercise.image
                        exerciseInDay.attributes = exercise.attributes

                    }
                }
            }
        }

        // Сохраняем изменения в Core Data
        saveContext()
    }

}












//    func deleteExerciseFromWorkoutDays(exerciseToDelete: DefaultExercise) {
//        let context = PersistenceController.shared.container.viewContext
//
//        // Проходим по кэшированным тренировочным дням
//        for workoutDay in workoutDaysCache.values {
//            if let exercises = workoutDay.exercises as? Set<Exercise> {
//                // Ищем упражнение по имени и удаляем его
//                if let exerciseToRemove = exercises.first(where: { $0.name == exerciseToDelete.name }) {
//                    workoutDay.removeFromExercises(exerciseToRemove)
//                    print("Removed exercise '\(exerciseToRemove.name ?? "Unknown")' from workout day.")
//                }
//            }
//        }
//
//        // Сохраняем изменения
//        do {
//            try context.save()
//            print("Exercise removed from all workout days.")
//        } catch {
//            print("Error removing exercise from workout days: \(error.localizedDescription)")
//        }
//    }

//    func addSet(to exercise: Exercise) {
//        let newSet = ExerciseSet(context: viewContext)
//        newSet.count = (exercise.setsArray.last?.count ?? 0) + 1
//
//        if exercise.categories?.name == "Cardio" {
//            // Если категория "Cardio", используем distance и time
//            newSet.distance = exercise.setsArray.last?.distance ?? 0.0 // Копируем дистанцию
//            newSet.time = exercise.setsArray.last?.time ?? 0.0 // Копируем время
//        } else {
//            // Для всех остальных категорий используем weight и reps
//            newSet.reps = exercise.setsArray.last?.reps ?? 0 // Копируем повторения
//            newSet.weight = exercise.setsArray.last?.weight ?? 0.0 // Копируем вес
//        }
//
//        exercise.addToSets(newSet)
//        saveContext()
//    }


//    func loadDefaultExercises() {
//        let fetchRequest: NSFetchRequest<DefaultExercise> = DefaultExercise.fetchRequest()
//
//        do {
//            allDefaultExercises = try viewContext.fetch(fetchRequest)
//
//            if allDefaultExercises.isEmpty {
//                print("No default exercises found in Core Data.")
//            } else {
//                print("Loaded \(allDefaultExercises.count) default exercises from Core Data:")
//                for exercise in allDefaultExercises {
//                    print("- Name: \(exercise.name ?? "Unknown"), Category: \(exercise.categories?.name ?? "Unknown")")
//                }
//            }
//        } catch {
//            let nsError = error as NSError
//            print("Failed to load default exercises: \(nsError), \(nsError.userInfo)")
//        }
//    }
//
//    func loadCategories() {
//        let fetchRequest: NSFetchRequest<ExerciseCategory> = ExerciseCategory.fetchRequest()
//
//        do {
//            let categories = try viewContext.fetch(fetchRequest)
//            // Сортируем категории по имени
//            allCategories = categories.sorted {
//                ($0.name ?? "").localizedCaseInsensitiveCompare($1.name ?? "") == .orderedAscending
//            }
//        } catch {
//            print("Failed to load categories from CoreData: \(error)")
//        }
//    }
