//
//  FoodService.swift
//  FitnessPad
//
//  Created by Марк Кулик on 03.02.2025.
//


import CoreData

class FoodService: ObservableObject {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Save Context
    func saveContext() {
        do {
            try context.save()
            print("Context successfully saved")
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    // MARK: - Fetch Food Days
    func fetchFoodDays() -> [FoodDay] {
        let request: NSFetchRequest<FoodDay> = FoodDay.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FoodDay.date, ascending: true)]

        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch food days: \(error)")
            return []
        }
    }
    
    // MARK: - Cache Food Days
    func cacheFoodDays(from days: [FoodDay]) -> [Date: FoodDay] {
        var cache: [Date: FoodDay] = [:]
        for day in days {
            guard let date = day.date else { continue }
            if cache[date] == nil {
                cache[date] = day
            }
        }
        return cache
    }
    
    // MARK: - Get Food Day for Date
    func foodDay(for date: Date, in cache: [Date: FoodDay]) -> FoodDay? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return cache.values.first { calendar.isDate($0.date ?? Date(), inSameDayAs: startOfDay) }
    }
    
    func fetchMeals() -> [Meal] {
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Meal.date, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch meals: \(error)")
        }
        return []
    }
    
//    func updateWaterIntake(for date: Date, newWaterIntake: Double) {
//        let fetchRequest: NSFetchRequest<FoodDay> = FoodDay.fetchRequest()
//        let startOfDay = Calendar.current.startOfDay(for: date)
//        fetchRequest.predicate = NSPredicate(format: "date == %@", startOfDay as CVarArg)
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            let foodDay = results.first ?? FoodDay(context: context)
//            foodDay.date = startOfDay
//            foodDay.water = newWaterIntake
//            try context.save()
//        } catch {
//            print("Failed to update water intake: \(error)")
//        }
//    }
    func updateWaterIntake(for date: Date, newWaterIntake: Double) -> FoodDay? {
        let fetchRequest: NSFetchRequest<FoodDay> = FoodDay.fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        fetchRequest.predicate = NSPredicate(format: "date == %@", startOfDay as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            let foodDay = results.first ?? FoodDay(context: context)
            foodDay.date = startOfDay
            foodDay.water = newWaterIntake
            
            // Если вода равна 0 и нет приемов пищи, удаляем FoodDay
            if newWaterIntake == 0 {
                if let meals = foodDay.meals?.allObjects as? [Meal], meals.isEmpty {
                    context.delete(foodDay)
                    try context.save()
                    return nil // Возвращаем nil, так как FoodDay был удален
                }
            }
            
            try context.save()
            return foodDay // Возвращаем созданный или обновленный FoodDay
        } catch {
            print("Failed to update water intake: \(error)")
            return nil
        }
    }


    // MARK: - Add Meal
    func addMeal(name: String, products: String, proteins: Double, fats: Double, carbohydrates: Double, calories: Double, date: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        // Проверяем, существует ли уже FoodDay для этой даты
        let fetchRequest: NSFetchRequest<FoodDay> = FoodDay.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", startOfDay as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            let foodDay = results.first ?? FoodDay(context: context)
            foodDay.date = startOfDay

            let newMeal = Meal(context: context)
            newMeal.id = UUID()
            newMeal.date = date
            newMeal.createdAt = Date()
            newMeal.name = name
            newMeal.products = products
            newMeal.proteins = proteins
            newMeal.fats = fats
            newMeal.carbohydrates = carbohydrates
            newMeal.calories = calories
            newMeal.foodDay = foodDay

            foodDay.addToMeals(newMeal)

            saveContext()
        } catch {
            print("Failed to add meal: \(error)")
        }
    }
    
    // MARK: - Update Meal
    func updateMeal(meal: Meal, name: String, products: String, calories: Double, proteins: Double, fats: Double, carbohydrates: Double) {
        meal.name = name
        meal.products = products
        meal.calories = calories
        meal.proteins = proteins
        meal.fats = fats
        meal.carbohydrates = carbohydrates
        
        saveContext()
    }

//    func deleteMeal(_ meal: Meal) {
//        guard let foodDay = meal.foodDay else { return }
//        
//        // Удаляем meal
//        context.delete(meal)
//        saveContext()
//        
//        // Проверяем, остались ли еще meal в foodDay
//        if let meals = foodDay.meals?.allObjects as? [Meal], meals.isEmpty {
//            // Если meal больше нет, удаляем и foodDay
//            context.delete(foodDay)
//            saveContext()
//        }
//    }
    
    func deleteMeal(_ meal: Meal) {
        guard let foodDay = meal.foodDay else { return }
        
        // Удаляем meal
        context.delete(meal)
        saveContext()
        
        // Проверяем, остались ли еще meal в foodDay или есть вода
        if let meals = foodDay.meals?.allObjects as? [Meal], meals.isEmpty {
            // Если meal больше нет и вода равна 0, удаляем и foodDay
            if foodDay.water == 0 {
                context.delete(foodDay)
                saveContext()
            }
        }
    }
    
    // MARK: - Day Summary Management
    func totalCalories(for date: Date, in foodDaysCache: [Date: FoodDay]) -> Double {
        guard let foodDay = foodDay(for: date, in: foodDaysCache),
              let meals = foodDay.meals?.allObjects as? [Meal] else {
            return 0
        }
        return meals.reduce(0) { $0 + $1.calories }
    }

    func totalProteins(for date: Date, in foodDaysCache: [Date: FoodDay]) -> Double {
        guard let foodDay = foodDay(for: date, in: foodDaysCache),
              let meals = foodDay.meals?.allObjects as? [Meal] else {
            return 0
        }
        return meals.reduce(0) { $0 + $1.proteins }
    }

    func totalFats(for date: Date, in foodDaysCache: [Date: FoodDay]) -> Double {
        guard let foodDay = foodDay(for: date, in: foodDaysCache),
              let meals = foodDay.meals?.allObjects as? [Meal] else {
            return 0
        }
        return meals.reduce(0) { $0 + $1.fats }
    }

    func totalCarbohydrates(for date: Date, in foodDaysCache: [Date: FoodDay]) -> Double {
        guard let foodDay = foodDay(for: date, in: foodDaysCache),
              let meals = foodDay.meals?.allObjects as? [Meal] else {
            return 0
        }
        return meals.reduce(0) { $0 + $1.carbohydrates }
    }

}
