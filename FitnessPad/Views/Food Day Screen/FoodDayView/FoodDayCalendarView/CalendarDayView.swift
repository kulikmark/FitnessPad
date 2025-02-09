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
            // Анимированное изменение числа
            Text(getDay(from: date))
                .font(.title2)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? Color("ButtonTextColor") : .primary)
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
//                .animation(.easeInOut(duration: 0.3), value: date) // Анимация при изменении даты

            Spacer()

            // Отображаем точку, если есть meals для этой даты
            if hasMealsOrWater(for: date) {
                Circle()
                    .fill(isSelected ? Color("ButtonTextColor") : Color("TextColor"))
                    .frame(width: 5, height: 5)
            }
        }
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
//    private func hasMeals(for date: Date) -> Bool {
//        if let foodDay = foodDayViewModel.foodDay(for: date),
//           let meals = foodDay.meals,
//           !meals.allObjects.isEmpty {
//            return true
//        }
//        return false
//    }
    // Проверяем, есть ли meals или вода для этой даты
    private func hasMealsOrWater(for date: Date) -> Bool {
        if let foodDay = foodDayViewModel.foodDay(for: date) {
            // Проверяем, есть ли приемы пищи
            if let meals = foodDay.meals, !meals.allObjects.isEmpty {
                return true
            }
            // Проверяем, есть ли вода
            if foodDay.water > 0 {
                return true
            }
        }
        return false
    }
}
