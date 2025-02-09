//
//  FoodDayViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 04.02.2025.
//

import SwiftUI
import CoreData

class FoodDayViewModel: ObservableObject {
    @Published var foodDaysCache: [Date: FoodDay] = [:]
    @Published var meals: [Meal] = []
    
    private let foodService: FoodService
    
    init(
        foodService: FoodService
       
    ) {
        self.foodService = foodService
       
        fetchFoodDays()
        fetchMeals()
    }
    
    // MARK: - Food Management
    
    func fetchFoodDays() {
        let foodDays = foodService.fetchFoodDays()
        foodDaysCache = foodService.cacheFoodDays(from: foodDays)
    }
    
    func foodDay(for date: Date) -> FoodDay? {
        foodService.foodDay(for: date, in: foodDaysCache)
    }
    
    func cacheFoodDays(from days: [FoodDay]) {
           foodDaysCache = foodService.cacheFoodDays(from: days)
       }
    
    func fetchMeals() {
        meals = foodService.fetchMeals()
        
    }
    
    func updateWaterIntake(for date: Date, newWaterIntake: Double) {
        foodService.updateWaterIntake(for: date, newWaterIntake: newWaterIntake)
        
        // Обновляем кэш в ViewModel после изменения данных
        if let foodDay = foodService.foodDay(for: date, in: foodDaysCache) {
            foodDaysCache[Calendar.current.startOfDay(for: date)] = foodDay
        }
    }
    
    func addMeal(name: String, products: String, proteins: Double, fats: Double, carbohydrates: Double, calories: Double, date: Date) {
        foodService.addMeal(
            name: name,
            products: products,
            proteins: proteins,
            fats: fats,
            carbohydrates: carbohydrates,
            calories: calories,
            date: date
        )
        fetchFoodDays()
        fetchMeals()
        
        // Отладка: выводим значение date
            print("Adding meal \(name) with date: \(date)")
    }
    
    func updateMeal(_ meal: Meal, name: String, products: String, proteins: Double, fats: Double, carbohydrates: Double, calories: Double) {
        foodService.updateMeal(
            meal: meal,
            name: name,
            products: products,
            calories: calories,
            proteins: proteins,
            fats: fats,
            carbohydrates: carbohydrates
        )
        fetchFoodDays()
        fetchMeals()
        
        // Отладка: выводим текущую дату meal
           if let mealDate = meal.date {
               print("Updating meal \(name) with current date: \(mealDate)")
           } else {
               print("Meal date is nil!")
           }
    }

    func deleteMeal(_ meal: Meal) {
        foodService.deleteMeal(meal)
        fetchFoodDays()
        fetchMeals()
    }
    
    func getTotalCalories(for date: Date) -> Double {
        foodService.totalCalories(for: date, in: foodDaysCache)
    }
}
