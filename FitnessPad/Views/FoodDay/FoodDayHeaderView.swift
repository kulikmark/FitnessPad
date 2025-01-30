//
//  FoodDayHeaderView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 27.01.2025.
//

import SwiftUI

struct FoodDayHeaderView: View {
    
    @EnvironmentObject var viewModel: WorkoutViewModel
    @Binding var selectedDate: Date
    @Binding var currentMonth: Date
    @State private var bodyWeightString: String = ""
    @State private var showCaloriesCalculator = false
    @FocusState private var isWeightFieldFocused: Bool
    
    var body: some View {
        HStack {
            // Заголовок с месяцем и годом
            Text(currentMonth, formatter: monthYearFormatter)
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            Text("Weight:")
                .font(.system(size: 12))
                .foregroundColor(Color("TextColor"))
                .lineLimit(1)
            
            TextField("0 kg", text: $bodyWeightString)
                .font(.system(size: 14))
                .foregroundColor(Color("TextColor"))
                .frame(minWidth: 40, maxWidth: 50)
                .padding(8)
                .background(Color("ViewColor"))
                .cornerRadius(10)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .focused($isWeightFieldFocused)
            
            if isWeightFieldFocused {
                Button(action: {
                    saveWeight()
                    isWeightFieldFocused = false
                }) {
                    Text("Save")
                        .font(.system(size: 12))
                        .foregroundColor(Color("ButtonTextColor"))
                        .padding(8)
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                }
                .transition(.opacity)
            }
            
            // Кнопка для открытия калькулятора калорий
            Button(action: {
                showCaloriesCalculator = true
            }) {
                Image(systemName: "pencil.and.ruler")
                    .font(.system(size: 24))
                    .foregroundColor(Color("ButtonColor"))
            }
            .padding(.leading, 5)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.bottom)
        .onAppear {
            if let bodyWeight = viewModel.fetchBodyWeight(for: selectedDate) {
                bodyWeightString = String(format: "%.1f", bodyWeight.weight)
            }
        }
        .onChange(of: selectedDate) { _, newDate in
            if let bodyWeight = viewModel.fetchBodyWeight(for: newDate) {
                bodyWeightString = String(format: "%.1f", bodyWeight.weight)
            } else {
                bodyWeightString = ""
            }
        }
        .fullScreenCover(isPresented: $showCaloriesCalculator) {
            CaloriesCalculator()
                .environmentObject(viewModel)
        }
    }
    
    private func saveWeight() {
        if !bodyWeightString.isEmpty {
            let formattedValue = bodyWeightString.replacingOccurrences(of: ",", with: ".")
            if let weight = Double(formattedValue) {
                viewModel.updateBodyWeight(for: selectedDate, newWeight: weight)
            }
        } else {
            viewModel.updateBodyWeight(for: selectedDate, newWeight: 0.0)
        }
        isWeightFieldFocused = false
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
//
//#Preview {
//    FoodDayHeaderView()
//}
