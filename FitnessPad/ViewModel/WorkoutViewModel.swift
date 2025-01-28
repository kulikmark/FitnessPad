//
//  TrainingsViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.03.2022.
//

import SwiftUI
import CoreData

class WorkoutViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var workoutDaysCache: [Date: WorkoutDay] = [:]
    @Published var allCategories: [ExerciseCategory] = []
    @Published var allDefaultExercises: [DefaultExercise] = []
    @Published var foodDaysCache: [Date: FoodDay] = [:]
    @Published var meals: [Meal] = []
    @Published var daySummary: DaySummary?
    
    let viewContext = PersistenceController.shared.container.viewContext
    
    // MARK: - Initialization
    init() {
        loadDefaultExercises()
        fetchWorkoutDays()
        fetchFoodDays()
        fetchMeals()
        fetchDaySummary()
    }
    
    // MARK: - Core Data Operations
    func saveContext() {
        do {
            try viewContext.save()
            print("Context successfully saved")
            objectWillChange.send()
        } catch {
            print("Failed to save context: \(error)")
        }
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
    
    // MARK: - Workout Days Management
    func fetchWorkoutDays() {
        let request: NSFetchRequest<WorkoutDay> = WorkoutDay.fetchRequest()
        do {
            let workoutDays = try self.viewContext.fetch(request)
            self.cacheWorkoutDays(from: workoutDays)
            self.objectWillChange.send()
        } catch {
            print("Ошибка при получении workoutDays: \(error)")
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
    
    var sortedWorkoutDays: [WorkoutDay] {
        workoutDaysCache.values.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
    }
    
    // MARK: - Food Days Management
    func fetchFoodDays() {
        let request: NSFetchRequest<FoodDay> = FoodDay.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FoodDay.date, ascending: true)]
        
        do {
            let foodDays = try self.viewContext.fetch(request)
            self.cacheFoodDays(from: foodDays)
            print("Fetched \(foodDaysCache.count) FoodDays")
        } catch {
            print("Failed to fetch food days: \(error)")
        }
    }
    
    func foodDay(for date: Date) -> FoodDay? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return foodDaysCache.values.first { calendar.isDate($0.date ?? Date(), inSameDayAs: startOfDay) }
    }
    
    func cacheFoodDays(from days: [FoodDay]) {
        foodDaysCache = Dictionary(uniqueKeysWithValues: days.compactMap { day in
            guard let date = day.date else { return nil }
            return (date, day)
        })
    }
    
    var sortedFoodDays: [FoodDay] {
        foodDaysCache.values.sorted { ($0.date ?? Date()) < ($1.date ?? Date()) }
    }
    
    // MARK: - Meals Management
    func fetchMeals() {
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Meal.date, ascending: true)]
        
        do {
            meals = try viewContext.fetch(request)
            print("Fetched \(meals.count) meals")
        } catch {
            print("Failed to fetch meals: \(error)")
        }
    }
    
    func addMeal(name: String, proteins: Double, fats: Double, carbohydrates: Double, calories: Double, date: Date) {
        let context = PersistenceController.shared.container.viewContext
        let foodDay = self.foodDay(for: date) ?? FoodDay(context: context)
        foodDay.id = UUID()
        foodDay.date = Calendar.current.startOfDay(for: date)
        
        let newMeal = Meal(context: context)
        newMeal.id = UUID()
        newMeal.name = name
        newMeal.proteins = proteins
        newMeal.fats = fats
        newMeal.carbohydrates = carbohydrates
        newMeal.calories = calories
        newMeal.foodDay = foodDay
        
        if let meals = foodDay.meals?.allObjects as? [Meal], !meals.isEmpty {
            if let lastMeal = meals.max(by: { $0.count < $1.count }) {
                newMeal.count = lastMeal.count + 1
            } else {
                newMeal.count = 1
            }
        } else {
            newMeal.count = 1
        }
        
        foodDay.addToMeals(newMeal)
        saveContext()
        fetchFoodDays()
        fetchMeals()
        updateDaySummary(for: foodDay)
        print("Meal saved: \(newMeal.name ?? "Unknown")")
    }
    
    func updateMeal(meal: Meal, name: String, calories: Double, proteins: Double, fats: Double, carbohydrates: Double) {
        meal.name = name
        meal.calories = calories
        meal.proteins = proteins
        meal.fats = fats
        meal.carbohydrates = carbohydrates
        saveContext()
    }
    
    func deleteMeal(_ meal: Meal) {
        guard let foodDay = meal.foodDay else { return }
        viewContext.delete(meal)
        saveContext()
        
        if let meals = foodDay.meals?.allObjects as? [Meal], !meals.isEmpty {
            let sortedMeals = meals.sorted { $0.count < $1.count }
            for (index, meal) in sortedMeals.enumerated() {
                meal.count = Int64(index + 1)
            }
            saveContext()
        }
        
        if let meals = foodDay.meals?.allObjects as? [Meal], meals.isEmpty {
            if let daySummary = foodDay.daySummary {
                viewContext.delete(daySummary)
                foodDay.daySummary = nil
                saveContext()
                print("DaySummary deleted because no meals are left.")
            }
        } else {
            updateDaySummary(for: foodDay)
        }
    }
    
    // MARK: - Day Summary Management
    func fetchDaySummary() {
        let request: NSFetchRequest<DaySummary> = DaySummary.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", Date() as CVarArg)
        
        do {
            daySummary = try viewContext.fetch(request).first
            if let summary = daySummary {
                print("DaySummary: \(summary.totalCalories) calories, \(summary.totalProteins) proteins")
            } else {
                print("No DaySummary found for today")
            }
        } catch {
            print("Failed to fetch day summary: \(error)")
        }
    }
    
    func updateDaySummary(for foodDay: FoodDay) {
        let totalCalories = foodDay.meals?.reduce(0) { $0 + (($1 as? Meal)?.calories ?? 0.0) } ?? 0
        let totalProteins = foodDay.meals?.reduce(0) { $0 + (($1 as? Meal)?.proteins ?? 0.0) } ?? 0
        let totalFats = foodDay.meals?.reduce(0) { $0 + (($1 as? Meal)?.fats ?? 0.0) } ?? 0
        let totalCarbohydrates = foodDay.meals?.reduce(0) { $0 + (($1 as? Meal)?.carbohydrates ?? 0.0) } ?? 0
        
        if let summary = foodDay.daySummary {
            summary.totalCalories = totalCalories
            summary.totalProteins = totalProteins
            summary.totalFats = totalFats
            summary.totalCarbohydrates = totalCarbohydrates
        } else {
            let newSummary = DaySummary(context: viewContext)
            newSummary.id = UUID()
            newSummary.totalCalories = totalCalories
            newSummary.totalProteins = totalProteins
            newSummary.totalFats = totalFats
            newSummary.totalCarbohydrates = totalCarbohydrates
            newSummary.date = foodDay.date ?? Date()
            foodDay.daySummary = newSummary
        }
        
        saveContext()
        print("DaySummary updated for FoodDay: \(foodDay.date ?? Date())")
    }
    
    // MARK: - Body Weight Management
      func saveBodyWeight(for date: Date, weight: Double) {
          let bodyWeight = BodyWeight(context: viewContext)
          bodyWeight.date = date
          bodyWeight.weight = weight
          
          // Связываем с WorkoutDay или FoodDay, если они существуют
          if let workoutDay = workoutDay(for: date) {
              workoutDay.bodyWeight = bodyWeight
          }
          
          if let foodDay = foodDay(for: date) {
              foodDay.bodyWeight = bodyWeight
          }
          
          saveContext()
      }
      
      func updateBodyWeight(for date: Date, newWeight: Double) {
          if let bodyWeight = fetchBodyWeight(for: date) {
              bodyWeight.weight = newWeight
          } else {
              saveBodyWeight(for: date, weight: newWeight)
          }
          saveContext()
      }
      
      func fetchBodyWeight(for date: Date) -> BodyWeight? {
          let request: NSFetchRequest<BodyWeight> = BodyWeight.fetchRequest()
          request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
          
          do {
              return try viewContext.fetch(request).first
          } catch {
              print("Failed to fetch body weight: \(error)")
              return nil
          }
      }
    
    /// Возвращает все записи о весе, отсортированные по дате.
    func fetchBodyWeights() -> [BodyWeight] {
        let request: NSFetchRequest<BodyWeight> = BodyWeight.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \BodyWeight.date, ascending: true)]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch body weights: \(error)")
            return []
        }
    }
    
    // MARK: - Exercises Management
    func fetchAllExercises() -> [Exercise] {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch exercises: \(error.localizedDescription)")
            return []
        }
    }
    
    func loadDefaultExercises() {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let exercises = self.loadEntities(DefaultExercise.self, sortDescriptors: [sortDescriptor])
        
        DispatchQueue.main.async {
            self.allDefaultExercises = exercises
            self.objectWillChange.send()
        }
        
        for exercise in exercises {
            print("Exercise: \(exercise.name ?? "Unknown")")
            print("ID: \(exercise.id?.uuidString ?? "No ID")")
            print("Category: \(exercise.categories?.name ?? "No Category")")
            
            if let attributes = exercise.attributes as? Set<ExerciseAttribute> {
                print("Attributes:")
                for attribute in attributes {
                    print("  - \(attribute.name ?? "Unnamed"): \(attribute.isAdded ? "Added" : "Not Added")")
                }
            } else {
                print("Attributes: None")
            }
            
            if let imageData = exercise.image, let image = UIImage(data: imageData) {
                print("Image: \(image)")
            } else {
                print("Image: None")
            }
            
            print("-----------------------------")
        }
    }
    
    func loadCategories() {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let categories = self.loadEntities(ExerciseCategory.self, sortDescriptors: [sortDescriptor])
        self.allCategories = categories
        self.objectWillChange.send()
    }
    
    var allDefaultExercisesGroupedByCategory: [(category: String, exercises: [DefaultExercise])] {
        let filteredExercises = allDefaultExercises.filter { $0.categories != nil }
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
        allCategories.append(newCategory)
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
        
        allCategories.removeAll { $0 == category }
    }
    
    func addExerciseToWorkoutDay(_ defaultExercise: DefaultExercise, workoutDay: WorkoutDay?, date: Date) {
        let context = PersistenceController.shared.container.viewContext
        let workoutDay = self.workoutDay(for: date) ?? WorkoutDay(context: context)
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
        
        do {
            try context.save()
            print("Exercise \(defaultExercise.name ?? "Unknown") successfully added to workout day.")
            fetchWorkoutDays()
            objectWillChange.send()
        } catch {
            print("Failed to save exercise: \(error.localizedDescription)")
        }
    }
    
    func addSet(to exercise: Exercise) {
        let newSet = ExerciseSet(context: viewContext)
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
    
    func deleteExerciseFromWorkoutDay(_ exercise: Exercise) {
        guard let workoutDay = exercise.workoutDay else { return }
        viewContext.delete(exercise)
        
        do {
            try viewContext.save()
            print("Exercise deleted successfully")
            
            if workoutDay.exercisesArray.isEmpty {
                viewContext.delete(workoutDay)
                try viewContext.save()
                print("WorkoutDay deleted because no exercises are left.")
            }
            fetchWorkoutDays()
            objectWillChange.send()
        } catch {
            print("Error saving context after deleting exercise: \(error)")
        }
    }
    
    func deleteSet(_ set: ExerciseSet, in exercise: Exercise) {
        viewContext.delete(set)
        exercise.setsArray.enumerated().forEach { index, set in
            set.count = Int16(index + 1)
        }
        saveContext()
    }
    
    func toggleFavourite(for exercise: DefaultExercise) {
        exercise.isFavourite.toggle()
        do {
            try viewContext.save()
            print("Exercise \(exercise.name ?? "Unknown") is now \(exercise.isFavourite ? "favourited" : "unfavourited").")
            objectWillChange.send()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func addExerciseToCoreData(name: String, category: ExerciseCategory?, image: UIImage?, attributes: Set<String>, isDefault: Bool = false) {
        let newExercise = DefaultExercise(context: viewContext)
        newExercise.id = UUID()
        newExercise.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        newExercise.categories = category
        newExercise.image = image?.jpegData(compressionQuality: 1.0)
        newExercise.isDefault = isDefault
        
        for attribute in attributes {
            let newAttribute = ExerciseAttribute(context: viewContext)
            newAttribute.name = attribute
            newAttribute.isAdded = true
            newExercise.addToAttributes(newAttribute)
        }
        
        saveContext()
        loadDefaultExercises()
        objectWillChange.send()
    }
    
    func updateExerciseInCoreData(_ exercise: DefaultExercise, name: String, category: ExerciseCategory?, image: UIImage?, attributes: Set<String>) {
        exercise.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        exercise.categories = category
        exercise.image = image?.jpegData(compressionQuality: 1.0)
        
        let currentAttributes = exercise.attributes?.allObjects as? [ExerciseAttribute] ?? []
        for attribute in currentAttributes {
            if !attributes.contains(attribute.name ?? "") {
                viewContext.delete(attribute)
            }
        }
        
        for attribute in attributes {
            if !currentAttributes.contains(where: { $0.name == attribute }) {
                let newAttribute = ExerciseAttribute(context: viewContext)
                newAttribute.name = attribute
                newAttribute.isAdded = true
                exercise.addToAttributes(newAttribute)
            }
        }
        
        saveContext()
    }
    
    func deleteExerciseFromCoreData(_ exercise: DefaultExercise) {
        guard let exerciseId = exercise.id else {
            print("Exercise ID is nil, cannot proceed with deletion.")
            return
        }
        workoutDaysCache.forEach { (_, workoutDay) in
            if let exercisesSet = workoutDay.exercises as? Set<Exercise> {
                let filteredExercises = exercisesSet.filter { $0.id != exerciseId }
                workoutDay.exercises = NSSet(set: filteredExercises)
                print("Updated exercises for workout day: \(filteredExercises.map { $0.name ?? "Unnamed Exercise" })")
            }
        }
        
        saveContext()
        print("Exercise with ID \(exerciseId) successfully deleted from all workout days.")
    }
    
    func updateExerciseInWorkoutDays(exercise: DefaultExercise) {
        guard let exerciseId = exercise.id else {
            print("Exercise ID is nil, cannot proceed with update.")
            return
        }
        workoutDaysCache.forEach { (_, workoutDay) in
            if let exercisesSet = workoutDay.exercises as? Set<Exercise> {
                exercisesSet.forEach { exerciseInDay in
                    if exerciseInDay.id == exerciseId {
                        exerciseInDay.name = exercise.name
                        exerciseInDay.image = exercise.image
                        exerciseInDay.attributes = exercise.attributes
                    }
                }
            }
        }
        saveContext()
    }
    
    // MARK: - Recommendations
    func getWorkoutRecommendations() -> [String] {
        var recommendations: [String] = []
        
        let exercises = fetchAllExercises()
        let mostFrequentExercises = exercises
            .filter { $0.setsArray.count > 0 }
            .sorted { $0.setsArray.count > $1.setsArray.count }
            .prefix(3)
        
        if !mostFrequentExercises.isEmpty {
            recommendations.append("You frequently perform: \(mostFrequentExercises.map { $0.name ?? "Unknown" }.joined(separator: ", ")). Keep it up!")
        }
        
        let exercisesWithNoProgress = exercises
            .filter { $0.setsArray.count > 0 && $0.setsArray.last?.weight == $0.setsArray.first?.weight }
        
        if !exercisesWithNoProgress.isEmpty {
            recommendations.append("Consider increasing weight for: \(exercisesWithNoProgress.map { $0.name ?? "Unknown" }.joined(separator: ", ")).")
        }
        
        let categories = allCategories
        let exercisesByCategory = Dictionary(grouping: exercises) { $0.categories?.name ?? "Uncategorized" }
        
        for category in categories {
            if exercisesByCategory[category.name ?? ""] == nil {
                recommendations.append("You haven't trained \(category.name ?? "this category") recently. Try adding some exercises!")
            }
        }
        
        return recommendations
    }
}
