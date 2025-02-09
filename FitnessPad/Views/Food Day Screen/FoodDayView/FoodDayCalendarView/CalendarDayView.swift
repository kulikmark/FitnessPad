//
//  CalendarDayView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

// MARK: - Отдельный день в календаре
struct CalendarDayView: View {
    var date: Date
    var isSelected: Bool
    @EnvironmentObject var foodDayViewModel: FoodDayViewModel

    var body: some View {
        VStack {
//                Text(getDayOfWeek(from: date)) // День недели
//                    .font(.caption)
//                    .foregroundColor(isSelected ? Color("ButtonTextColor") : .gray)
                
                
                Text(getDay(from: date)) // Число
                    .font(.title2)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? Color("ButtonTextColor") : .primary)
            
            Spacer()
            
            // Отображаем точку, если есть meals для этой даты
            if hasMeals(for: date) {
                Circle()
                    .fill(isSelected ? Color("ButtonTextColor") : Color("TextColor"))
                    .frame(width: 5, height: 5)
            }
        }
//        .frame(width: 30, height: 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
        .background(isSelected ? Color("ButtonColor") : Color.clear)
        .cornerRadius(10)
    }

    // Получаем день недели (например, "Пн")
    private func getDayOfWeek(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }

    // Получаем число (например, "15")
    private func getDay(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    // Проверяем, есть ли meals для этой даты
    private func hasMeals(for date: Date) -> Bool {
        if let foodDay = foodDayViewModel.foodDay(for: date),
           let meals = foodDay.meals,
           !meals.allObjects.isEmpty {
            return true
        }
        return false
    }
}
