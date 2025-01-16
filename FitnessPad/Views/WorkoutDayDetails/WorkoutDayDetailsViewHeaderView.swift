//
//  HeaderView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 14.01.2025.
//

import SwiftUI

struct WorkoutDayDetailsViewHeaderView: View {
    
    @ObservedObject var viewModel: WorkoutViewModel
    @Binding var workoutDay: WorkoutDay?
    
//    @State private var bodyWeight: Double = 0.0
    @State private var bodyWeightString: String = ""
    @State private var isShowingExercisesView = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        HStack {
            HStack {
                Text("Your weight today:")
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                    .lineLimit(1)
                    .padding(.leading, 20)
                
                TextField("0.0", text: $bodyWeightString)
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                    .frame(minWidth: 40, maxWidth: 50)
                    .padding(8)
                    .background(Color("ViewColor"))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .toolbar {
                           ToolbarItemGroup(placement: .keyboard) {
                               Spacer()
                               Button("Done") {
                                   hideKeyboard()
                               }
                           }
                       }
                    .onChange(of: bodyWeightString) { _, newValue in
                        if !bodyWeightString.isEmpty {
                            let formattedValue = newValue.replacingOccurrences(of: ",", with: ".")
                            if let weight = Double(formattedValue) {
                                workoutDay?.bodyWeight = weight
                                saveBodyWeight()
                            }
                        } else {
                            workoutDay?.bodyWeight = 0.0
                            saveBodyWeight()
                        }
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
 
            HStack (spacing: 20) {
                    deleteWorkoutDayButton
                    addExerciseButton
                }
                .padding(.trailing, 20)
        }
        .padding(.bottom, 20)
        .onAppear {
            if let weight = workoutDay?.bodyWeight, weight > 0 {
                bodyWeightString = String(format: "%.1f", weight)
            }
        }
        .onChange(of: workoutDay) { _, newWorkoutDay in
            if let weight = newWorkoutDay?.bodyWeight, weight > 0 {
                bodyWeightString = String(format: "%.1f", weight)
            } else {
                bodyWeightString = ""
            }
        }
        .sheet(isPresented: $isShowingExercisesView) {
            ExercisesView(viewModel: viewModel, workoutDay: $workoutDay)
                .background(Color("BackgroundColor"))
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Workout Day"),
                message: Text("Are you sure you want to delete this workout day?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let workoutDay = workoutDay {
                        viewModel.deleteWorkoutDay(workoutDay)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var deleteWorkoutDayButton: some View {
        Button(action: {
            showDeleteAlert = true
        }) {
            Image(systemName: "trash")
                .font(.system(size: 16))
                .foregroundColor(Color("TextColor"))
        }
    }
    
    private var addExerciseButton: some View {
        Button(action: {
            isShowingExercisesView = true
        }) {
            HStack {
                Image(systemName: "plus")
                    .font(.system(size: 18))
                    .foregroundColor(Color("TextColor"))
            }
        }
    }

      private func saveBodyWeight() {
          guard let workoutDay = workoutDay, let weight = Double(bodyWeightString), weight > 0 else { return }
          workoutDay.bodyWeight = weight
          viewModel.updateBodyWeight(for: workoutDay, newWeight: weight)
      }
    
    func hideKeyboard() {
        UIApplication.shared.endEditing(true)
    }
}

//#Preview {
//    HeaderView()
//}

struct WorkoutDaysListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDayDetailsViewHeaderView(
            viewModel: WorkoutViewModel(), // Provide a mock or real instance of WorkoutViewModel
            workoutDay: .constant(WorkoutDay()) // Provide a mock or real WorkoutDay instance
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color("BackgroundColor"))
    }
}
