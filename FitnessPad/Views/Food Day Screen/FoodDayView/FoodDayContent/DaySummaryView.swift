//
//  DaySummaryView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

// MARK: - Компонент для сводной информации
struct DaySummaryView: View {
    var totalCalories: Double
    var totalProteins: Double
    var totalFats: Double
    var totalCarbohydrates: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Total for day:".localized) // Локализованный текст
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color("TextColor"))

            NutritionInfoRow(label: "Calories".localized, value: totalCalories, unit: "meal_calories")
            NutritionInfoRow(label: "Proteins".localized, value: totalProteins, unit: "meal_grams")
            NutritionInfoRow(label: "Fats".localized, value: totalFats, unit: "meal_grams")
            NutritionInfoRow(label: "Carbohydrates".localized, value: totalCarbohydrates, unit: "meal_grams")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color("ViewColor").opacity(0.2))
        .cornerRadius(8)
    }
}
