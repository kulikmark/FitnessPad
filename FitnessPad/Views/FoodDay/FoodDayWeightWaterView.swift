//
//  FoodDayWeightWaterView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 31.01.2025.
//

import SwiftUI

import SwiftUI

struct FoodDayWeightWaterView: View {
    
    @EnvironmentObject var viewModel: WorkoutViewModel
    @Binding var selectedDate: Date
    
    @State private var waterIntake: Double = 0.0
    @State private var bodyWeightString: String = ""
    @FocusState private var isWeightFieldFocused: Bool
    
    var body: some View {
        HStack {
            // Вес тела
            HStack(spacing: 10) {
                Image(systemName: "scalemass") // Иконка весов
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                
                TextField("0 kg", text: $bodyWeightString)
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextColor"))
                    .frame(minWidth: 50, maxWidth: 70)
                    .padding(8)
                    .background(Color("ViewColor"))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .focused($isWeightFieldFocused)
                    .onChange(of: isWeightFieldFocused) { _, isFocused in
                        if isFocused {
                            // Убираем "kg" при фокусе
                            bodyWeightString = bodyWeightString.replacingOccurrences(of: " kg", with: "")
                        } else {
                            // Добавляем "kg" при потере фокуса
                            if !bodyWeightString.isEmpty {
                                bodyWeightString += " kg"
                            }
                        }
                    }
                
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
            }
            
            Spacer()
            
            // Учет воды
            HStack(spacing: 10) {
                Image(systemName: "waterbottle") // Иконка бутылки воды
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                
                // Кнопка уменьшения количества воды
                Button(action: {
                    updateWaterIntake(by: -100)
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(Color("ButtonTextColor"))
                        .font(.system(size: 14))
                        .frame(width: 30, height: 30)
                }
                .background(Color("ButtonColor"))
                .clipShape(Circle())
                
                // Текущее количество воды
                Text(formatWaterIntake(waterIntake))
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextColor"))
                    .frame(minWidth: 40, maxWidth: 50)
                
                // Кнопка увеличения количества воды
                Button(action: {
                    updateWaterIntake(by: 100)
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color("ButtonTextColor"))
                        .font(.system(size: 14))
                        .frame(width: 30, height: 30)
                }
                .background(Color("ButtonColor"))
                .clipShape(Circle())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .onAppear {
            // Загружаем вес и воду при появлении
            if let bodyWeight = viewModel.fetchBodyWeight(for: selectedDate) {
                bodyWeightString = String(format: "%.1f kg", bodyWeight.weight)
            }
            loadWaterIntake()
        }
        .onChange(of: selectedDate) { _, newDate in
            // Обновляем вес и воду при изменении даты
            if let bodyWeight = viewModel.fetchBodyWeight(for: newDate) {
                bodyWeightString = String(format: "%.1f kg", bodyWeight.weight)
            } else {
                bodyWeightString = ""
            }
            loadWaterIntake()
        }
    }
    
    private func saveWeight() {
        if !bodyWeightString.isEmpty {
            // Удаляем "kg" перед сохранением
            let formattedValue = bodyWeightString.replacingOccurrences(of: " kg", with: "")
            if let weight = Double(formattedValue) {
                viewModel.updateBodyWeight(for: selectedDate, newWeight: weight)
            }
        } else {
            viewModel.updateBodyWeight(for: selectedDate, newWeight: 0.0)
            // Обновляем bodyWeightString, если поле пустое
            bodyWeightString = "0.0 kg"
        }
        isWeightFieldFocused = false
    }
    
    // Загрузка количества воды
    private func loadWaterIntake() {
        if let foodDay = viewModel.foodDay(for: selectedDate) {
            waterIntake = foodDay.water
        } else {
            waterIntake = 0
        }
    }
    
    private func updateWaterIntake(by amount: Double) {
        waterIntake += amount
        if waterIntake < 0 {
            waterIntake = 0
        }
        viewModel.updateWaterIntake(for: selectedDate, newWaterIntake: waterIntake)
    }
    
    private func formatWaterIntake(_ intake: Double) -> String {
        if intake >= 1000 {
            let liters = intake / 1000
            return String(format: "%.1f l", liters)
        } else {
            return String(format: "%.0f ml", intake)
        }
    }
}
