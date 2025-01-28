//
//  ExerciseRowView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 16.01.2025.
//

//import SwiftUI
//
//struct ExerciseRowView: View {
//    var exercise: Exercise
//    @ObservedObject var viewModel: WorkoutViewModel
//    @Binding var expandedExercises: [String: Bool]
//    
//    var body: some View {
//        Section {
//                HStack {
//                    exerciseImage
//                    exerciseName
//                    Spacer()
//                    expandButton
//                }
//                .frame(height: 60)
//
//                if expandedExercises[exercise.name ?? ""] == true {
//                    // Передаем необходимые параметры в ExerciseSetView
//                    ExerciseSetView(viewModel: viewModel, expandedExercises: $expandedExercises, exercise: exercise)
//                }
//        }
//        .listRowBackground(Color.clear) // Добавляем фоновый цвет для строки
//    }
//
//    
//    
//    private var exerciseImage: some View {
//        if let imageData = exercise.image, let uiImage = UIImage(data: imageData) {
//            return Image(uiImage: uiImage)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 100, height: 50)
//                .clipShape(RoundedRectangle(cornerRadius: 3))
//        } else {
//            return Image("defaultExerciseImage")
//                .resizable()
//                .scaledToFill()
//                .frame(width: 100, height: 50)
//                .clipShape(RoundedRectangle(cornerRadius: 3))
//        }
//    }
//    
//    private var exerciseName: some View {
//        Text("\(exercise.name ?? "Unknown Exercise")")
//            .font(.system(size: 16))
//            .foregroundColor(Color("TextColor"))
//            .padding(.leading, 10)
//            .swipeActions {
//                Button(action: {
//                    withAnimation {
//                        deleteExercise(exercise)
//                    }
//                }) {
//                    Text("Delete")
//                        .foregroundColor(.white)
//                        .padding(10)
//                        .cornerRadius(5)
//                }
//                .tint(.red)
//            }
//    }
//    
//    private var expandButton: some View {
//        Button(action: {
//            let exerciseName = exercise.name ?? "Unknown Exercise"
//            expandedExercises[exerciseName] = !(expandedExercises[exerciseName] ?? false)
//        }) {
//            Image(systemName: expandedExercises[exercise.name ?? ""] == true ? "chevron.up" : "chevron.down")
//                .foregroundColor(.gray)
//                .frame(width: 20, height: 20)
//        }
//    }
//    
//    func deleteExercise(_ exercise: Exercise) {
//        viewModel.deleteExerciseFromWorkoutDay(exercise)
//    }
//}

import SwiftUI

struct ExerciseRowView: View {
    var exercise: Exercise
    @EnvironmentObject var viewModel: WorkoutViewModel
    @State private var isShowingSetView = false // Добавляем состояние для отображения sheet
    
    var body: some View {
        Section {
            HStack {
                exerciseImage
                exerciseName
                Spacer()
                expandButton
            }
            .frame(height: 60)
            .contentShape(Rectangle()) // Делаем всю строку кликабельной
            .onTapGesture {
                isShowingSetView.toggle() // Показываем sheet при нажатии на строку
            }
        }
        .listRowBackground(Color.clear)
        .fullScreenCover(isPresented: $isShowingSetView) {
            ExerciseSetView(exercise: exercise)
        }
    }
    
    private var exerciseImage: some View {
        if let imageData = exercise.image, let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 3))
        } else {
            return Image("defaultExerciseImage")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 3))
        }
    }
    
    private var exerciseName: some View {
        Text("\(exercise.name ?? "Unknown Exercise")")
            .font(.system(size: 16))
            .foregroundColor(Color("TextColor"))
            .padding(.leading, 10)
            .swipeActions {
                Button(action: {
                    withAnimation {
                        deleteExercise(exercise)
                    }
                }) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .padding(10)
                        .cornerRadius(5)
                }
                .tint(.red)
            }
    }
    
    private var expandButton: some View {
        Button(action: {
            isShowingSetView.toggle() // Показываем sheet при нажатии на кнопку
        }) {
            Image(systemName: "chevron.right") // Меняем стрелочку на "вправо"
                .foregroundColor(.gray)
                .frame(width: 20, height: 20)
        }
    }
    
    func deleteExercise(_ exercise: Exercise) {
        viewModel.deleteExerciseFromWorkoutDay(exercise)
    }
}
