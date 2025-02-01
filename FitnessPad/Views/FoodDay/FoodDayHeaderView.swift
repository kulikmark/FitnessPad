//
//  FoodDayHeaderView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 27.01.2025.
//

import SwiftUI

struct FoodDayHeaderView: View {
    
    @EnvironmentObject var viewModel: WorkoutViewModel
    @Binding var currentMonth: Date
    @State private var showCaloriesCalculator = false
    
    var body: some View {
        HStack {
            // Заголовок с месяцем и годом
            Text(currentMonth, formatter: monthYearFormatter)
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            // Кнопка для открытия калькулятора калорий
            Button(action: {
                showCaloriesCalculator = true
            }) {
                Image(systemName: "pencil.and.ruler")
                    .font(.system(size: 24))
                    .foregroundColor(Color("ButtonColor"))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.bottom)
        .fullScreenCover(isPresented: $showCaloriesCalculator) {
            CaloriesCalculator()
                .environmentObject(viewModel)
        }
    }

    // Форматтер для месяца и года
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    func hideKeyboard() {
        UIApplication.shared.endEditing(true)
    }
}
