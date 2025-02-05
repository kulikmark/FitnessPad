//
//  MealRowView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

// MARK: - Компонент для строки с информацией о приеме пищи
struct MealRowView: View {
    @EnvironmentObject var foodDayViewModel: FoodDayViewModel
    var meal: Meal
    var onEdit: (Meal) -> Void
    var onDelete: (Meal) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(meal.name ?? "Unknown Meal".localized) // Локализованный текст
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color("TextColor"))
            NutritionInfoRow(label: "Calories".localized, value: meal.calories, unit: "meal_calories")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color("ViewColor"))
        .cornerRadius(10)
        .listRowBackground(Color("BackgroundColor"))
        .onTapGesture(perform: {
            onEdit(meal)
        })
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            // Кнопка удаления
            Button(role: .destructive) {
                onDelete(meal)
                foodDayViewModel.fetchMeals()
            } label: {
                Label("Delete".localized, systemImage: "trash") // Локализованный текст
            }
        }
    }
}
