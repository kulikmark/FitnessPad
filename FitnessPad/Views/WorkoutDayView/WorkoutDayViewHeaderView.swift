//
//  HeaderView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 14.01.2025.
//

import SwiftUI

import SwiftUI

struct WorkoutDayViewHeaderView: View {
    
    @EnvironmentObject var viewModel: WorkoutViewModel
    @Binding var selectedDate: Date
    
    @State private var bodyWeightString: String = ""
    @State private var isShowingExercisesView = false
    @FocusState private var isWeightFieldFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                Text("Weight:")
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                    .lineLimit(1)
                    .padding(.leading, 20)
                
                TextField("0 kg", text: $bodyWeightString)
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
                        Text("Save")
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
 
            HStack (spacing: 20) {
                addExerciseButton
            }
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
            ExercisesView(isFromWokroutDayView: true, selectedDate: selectedDate)
                .background(Color("BackgroundColor"))
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
        }
    }

    private var addExerciseButton: some View {
        HStack (spacing: 10) {
            Text("Add\nExercise")
                .font(.system(size: 8))
                .foregroundColor(Color("TextColor"))
            Button(action: {
                isShowingExercisesView = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 17))
                    .foregroundColor(Color("TextColor"))
            }
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
    
    func hideKeyboard() {
        UIApplication.shared.endEditing(true)
    }
}
//#Preview {
//    HeaderView()
//}

//struct WorkoutDaysListHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutDayDetailsViewHeaderView(
//            viewModel: WorkoutViewModel(), // Provide a mock or real instance of WorkoutViewModel
//            workoutDay: .constant(WorkoutDay()) // Provide a mock or real WorkoutDay instance
//        )
//        .previewLayout(.sizeThatFits)
//        .padding()
//        .background(Color("BackgroundColor"))
//    }
//}
