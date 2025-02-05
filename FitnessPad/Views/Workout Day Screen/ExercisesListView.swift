//
//  ExercisesListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 16.01.2025.
//

//import SwiftUI
//
//struct ExercisesListView: View {
//    @ObservedObject var viewModel: WorkoutViewModel
//    @Binding var workoutDay: WorkoutDay?
//    @Binding var expandedExercises: [String: Bool]
//    
//    var body: some View {
//        Group {
//            if let workoutDay = workoutDay, workoutDay.exercisesArray.isEmpty {
//                VStack {
//                    Spacer()
//                    emptyExercisesScreenView
//                    Spacer()
//                }
//            } else {
//                List {
//                    ForEach(workoutDay?.exercisesArray ?? [], id: \.self) { exercise in
//                        exerciseRow(for: exercise)
//                            .listRowBackground(Color.clear)
//                    }
//                }
//                .scrollIndicators(.hidden)
//                .scrollContentBackground(.hidden)
//                .listStyle(PlainListStyle())
//                .padding(.bottom, 33)
//            }
//        }
//    }
//    
//    private var emptyExercisesScreenView: some View {
//        VStack {
//            if let workoutDay = workoutDay, workoutDay.exercisesArray.isEmpty {
//                Text("Add an Exercise or Delete the WorkoutDay by tapping button on the upper right corner.")
//                    .font(.footnote)
//                    .foregroundColor(Color("TextColor"))
//                    .multilineTextAlignment(.center)
//            }
//        }
//        .padding()
//        .background(Color("ViewColor").opacity(0.2))
//        .cornerRadius(15)
//        .padding(.horizontal, 20)
//    }
//    
//    private func exerciseRow(for exercise: Exercise) -> some View {
//        ExerciseRowView(exercise: exercise, viewModel: viewModel, expandedExercises: $expandedExercises)
//    }
//}

import SwiftUI

struct ExercisesListView: View {
    @EnvironmentObject var viewModel: WorkoutDayViewModel
    @Binding var selectedDate: Date
    
    var body: some View {
                List {
                    ForEach(viewModel.workoutDay(for: selectedDate)?.exercisesArray ?? [], id: \.self) { exercise in
                        ExerciseRowView(exercise: exercise)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                }
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
                .padding(.bottom, 33)
    }
    
    private var emptyExercisesScreenView: some View {
        VStack {
            if let workoutDay = viewModel.workoutDay(for: selectedDate), workoutDay.exercisesArray.isEmpty {
                Text("Add an Exercise or Delete the WorkoutDay by tapping button on the upper right corner.")
                    .font(.footnote)
                    .foregroundColor(Color("TextColor"))
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color("ViewColor").opacity(0.2))
        .cornerRadius(15)
        .padding(.horizontal, 20)
    }
}
