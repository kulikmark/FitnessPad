//
//  ExerciseSetView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 16.01.2025.
//

//import SwiftUI
//
//struct ExerciseSetView: View {
//    @ObservedObject var viewModel: WorkoutViewModel
//    @Binding var expandedExercises: [String: Bool]
//    var exercise: Exercise
//    
//    var body: some View {
//        VStack {
//            if exercise.setsArray.isEmpty {
//                noSetsView(for: exercise)
//            } else {
//                listView(for: exercise)
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .frame(height: expandedExercises[exercise.name ?? ""] == true ? min(CGFloat(exercise.setsArray.count * 50) + 50, 500) : 0)
//    }
//    
//    // MARK: - Helper Views
//    
//    private func noSetsView(for exercise: Exercise) -> some View {
//        VStack(alignment: .center) {
//            Text("No added sets")
//                .foregroundColor(Color("TextColor"))
//                .frame(maxWidth: .infinity, alignment: .center)
//            
//            addSetButton(for: exercise)
//        }
//        .frame(height: 100)
//    }
//    
//    private func listView(for exercise: Exercise) -> some View {
//        VStack {
//            List {
//                ForEach(exercise.setsArray.enumeratedArray(), id: \.element.id) { index, set in
//                    setSection(for: set, index: index, exercise: exercise)
//                }
//                .onDelete { indexSet in
//                    deleteSets(at: indexSet, from: exercise)
//                }
//            }
//            .scrollIndicators(.hidden)
//            .frame(maxWidth: .infinity)
//            .scrollContentBackground(.hidden)
//            
//            addSetButton(for: exercise)
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.top, 10)
//    }
//    
//    private func deleteSets(at indexSet: IndexSet, from exercise: Exercise) {
//        for index in indexSet {
//            let setToDelete = exercise.setsArray[index]
//            viewModel.deleteSet(setToDelete, in: exercise)
//        }
//    }
//    
//    private func setSection(for set: ExerciseSet, index: Int, exercise: Exercise) -> some View {
//        Section {
//            HStack {
//                Text("Set \(index + 1):")
//                    .foregroundColor(Color("TextColor"))
//                    .frame(width: 80, alignment: .leading)
//                    .padding(.trailing, 10)
//                
//                Spacer()
//                
//                ExerciseAttributes(viewModel: viewModel, exercise: exercise, set: set)
//            }
//            .padding(.horizontal, 0)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .listRowBackground(Color.clear)
//        }
//    }
//    
//    private func addSetButton(for exercise: Exercise) -> some View {
//        Button(action: {
//            viewModel.addSet(to: exercise)
//        }) {
//            HStack {
//                Image(systemName: "plus")
//                    .font(.system(size: 14))
//                    .foregroundColor(Color("TextColor"))
//                Text("Add Set")
//                    .font(.system(size: 14))
//                    .foregroundColor(Color("TextColor"))
//            }
//            .padding(10)
//            .background(Color("ButtonColor"))
//            .cornerRadius(5)
//        }
//        .buttonStyle(PlainButtonStyle()) // Убирает стандартное поведение кнопки в списке
//    }
//}
//


import SwiftUI

struct ExerciseSetView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    var exercise: Exercise
    
    var body: some View {
        VStack {
            if exercise.setsArray.isEmpty {
                noSetsView(for: exercise)
            } else {
                listView(for: exercise)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color("BackgroundColor"))
    }
    
    private func noSetsView(for exercise: Exercise) -> some View {
        VStack(alignment: .center) {
            Text("No added sets")
                .foregroundColor(Color("TextColor"))
                .frame(maxWidth: .infinity, alignment: .center)
            
            addSetButton(for: exercise)
        }
        .frame(height: 100)
    }
    
    private func listView(for exercise: Exercise) -> some View {
        VStack {
            List {
                ForEach(exercise.setsArray.enumeratedArray(), id: \.element.id) { index, set in
                    setSection(for: set, index: index, exercise: exercise)
                }
                .onDelete { indexSet in
                    deleteSets(at: indexSet, from: exercise)
                }
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity)
            .scrollContentBackground(.hidden)
            
            addSetButton(for: exercise)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
    }
    
    private func deleteSets(at indexSet: IndexSet, from exercise: Exercise) {
        for index in indexSet {
            let setToDelete = exercise.setsArray[index]
            viewModel.deleteSet(setToDelete, in: exercise)
        }
    }
    
    private func setSection(for set: ExerciseSet, index: Int, exercise: Exercise) -> some View {
        Section {
            HStack {
                Text("Set \(index + 1):")
                    .foregroundColor(Color("TextColor"))
                    .frame(width: 80, alignment: .leading)
                    .padding(.trailing, 10)
                
                Spacer()
                
                ExerciseAttributes(viewModel: viewModel, exercise: exercise, set: set)
            }
            .padding(.horizontal, 0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowBackground(Color.clear)
        }
    }
    
    private func addSetButton(for exercise: Exercise) -> some View {
        Button(action: {
            viewModel.addSet(to: exercise)
        }) {
            HStack {
                Image(systemName: "plus")
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextColor"))
                Text("Add Set")
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextColor"))
            }
            .padding(10)
            .background(Color("ButtonColor"))
            .cornerRadius(5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
