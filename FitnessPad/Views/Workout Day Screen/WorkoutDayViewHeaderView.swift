//
//  HeaderView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 14.01.2025.
//

import SwiftUI

struct WorkoutDayViewHeaderView: View {
    
    @EnvironmentObject var viewModel: BodyWeightViewModel
    @Binding var selectedDate: Date
    
    @State private var bodyWeightString: String = ""
    @State private var isShowingExercisesView = false
    @FocusState private var isWeightFieldFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                Text(NSLocalizedString("weight_label", comment: "Weight label"))
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                    .lineLimit(1)
                    .padding(.leading, 20)
                
                TextField(NSLocalizedString("weight_placeholder", comment: "Weight placeholder"), text: $bodyWeightString)
                    .font(.system(size: 16))
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
                        Text(NSLocalizedString("save_button_title", comment: "Save button"))
                            .font(.system(size: 16))
                            .foregroundColor(Color("ButtonTextColor"))
                            .padding(8)
                            .background(Color("ButtonColor"))
                            .cornerRadius(10)
                    }
                    .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Add Exercise Button
            ButtonWithLabelAndImage(
                label: "add_exercise_label",
                systemImageName: "plus",
                labelColor: Color("TextColor"),
                imageColor: Color("TextColor"),
                action: {
                    isShowingExercisesView = true
                }
            )
            .padding(.trailing, 20)
        }
        .padding(.bottom, 20)
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
        .sheet(isPresented: $isShowingExercisesView) {
            ExercisesView(
                isFromWokroutDayView: true,
                selectedDate: selectedDate
            )
                .background(Color("BackgroundColor"))
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
                .padding(.top, 20)
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
}
