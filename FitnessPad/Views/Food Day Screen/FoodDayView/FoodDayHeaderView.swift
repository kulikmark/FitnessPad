//
//  FoodDayHeaderView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 27.01.2025.
//

import SwiftUI

struct FoodDayHeaderView: View {
    
    @EnvironmentObject var viewModel: WorkoutDayViewModel
    @Binding var currentMonth: Date
    @State private var showCaloriesCalculator = false

    var body: some View {
        HStack {
            // Заголовок с месяцем и годом
            Text(formattedMonthYear)
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            // Кнопка для открытия калькулятора калорий
            ButtonWithLabelAndImage(
                          label: "calculate_calories_label",
                          systemImageName: "pencil.and.ruler",
                          labelColor: Color("TextColor"),
                          imageColor: Color("TextColor"),
                          action: {
                              showCaloriesCalculator = true
                          }
                      )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.bottom)
        .fullScreenCover(isPresented: $showCaloriesCalculator) {
            CaloriesCalculator()
                .environmentObject(viewModel)
        }
    }

    // Форматирование месяца и года
    private var formattedMonthYear: String {
        let month = format("LLLL")
        let year = format("yyyy")
        return "\(month.capitalized) \(year)"
    }
    
    // Форматирование даты
    private func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = format
        return formatter.string(from: currentMonth)
    }
    
    func hideKeyboard() {
        UIApplication.shared.endEditing(true)
    }
}
