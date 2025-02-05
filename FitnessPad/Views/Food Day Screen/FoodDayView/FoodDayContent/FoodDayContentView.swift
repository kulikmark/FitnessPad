//
//  FoodDayContentView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

// MARK: - Основной компонент FoodDayContentView
struct FoodDayContentView: View {
    @Binding var selectedDate: Date
    @EnvironmentObject var foodDayViewModel: FoodDayViewModel
    @EnvironmentObject var foodService: FoodService
    
    @State private var isAddingMeal: Bool = false
    @State private var editingMeal: Meal? = nil
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        VStack {
            // Проверяем, есть ли данные для выбранной даты
            let foodDay = foodDayViewModel.foodDay(for: selectedDate)
            let meals = foodDay?.meals?.allObjects as? [Meal] ?? []
            
            // Отображаем сводную информацию только если есть meals
            if !meals.isEmpty {
                DaySummaryView(
                    totalCalories: foodService.totalCalories(for: selectedDate, in: foodDayViewModel.foodDaysCache),
                    totalProteins: foodService.totalProteins(for: selectedDate, in: foodDayViewModel.foodDaysCache),
                    totalFats: foodService.totalFats(for: selectedDate, in: foodDayViewModel.foodDaysCache),
                    totalCarbohydrates: foodService.totalCarbohydrates(for: selectedDate, in: foodDayViewModel.foodDaysCache)
                )
            }
            
            // Список приемов пищи
            MealListView(
                meals: foodDay?.meals?.allObjects as? [Meal] ?? [],
                onDelete: deleteMeal,
                onEdit: editMeal
            )
            
            // Кнопка для добавления приема пищи
            addMealButton()
        }
        .padding(.horizontal)
        
        // Обработка редактирования и добавления приемов пищи
        .fullScreenCover(isPresented: $isAddingMeal) {
            MealFormView(selectedDate: selectedDate, foodDayViewModel: foodDayViewModel)
        }
        .fullScreenCover(item: $editingMeal) { meal in
            MealFormView(meal: meal, selectedDate: selectedDate, foodDayViewModel: foodDayViewModel)
        }
    }
    
    // Функция для создания кнопки добавления приема пищи
      private func addMealButton() -> some View {
          Button(action: {
              isAddingMeal = true
          }) {
              HStack {
                  Image(systemName: "plus")
                  Text("Add Meal".localized)
              }
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color("ButtonColor"))
              .foregroundColor(Color("ButtonTextColor"))
              .cornerRadius(10)
          }
          .padding(.bottom, 50)
      }
    
    // Удаление приема пищи
    private func deleteMeal(at offsets: IndexSet) {
        guard let foodDay = foodDayViewModel.foodDay(for: selectedDate) else { return }
        if let meals = foodDay.meals?.allObjects as? [Meal] {
            for index in offsets {
                let meal = meals[index]
                foodDayViewModel.deleteMeal(meal)
            }
        }
    }
    
    // Удаление конкретного приема пищи
    private func deleteMeal(_ meal: Meal) {
        foodDayViewModel.deleteMeal(meal)
    }
    
    // Редактирование приема пищи
    private func editMeal(_ meal: Meal) {
        editingMeal = meal
    }
}
