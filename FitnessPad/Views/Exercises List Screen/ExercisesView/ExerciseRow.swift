//
//  ExerciseRow.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.02.2025.
//

import SwiftUI

struct ExerciseRow: View {
    let exercise: DefaultExercise
    let deleteExercise: (DefaultExercise) -> Void
    let isFromWokroutDayView: Bool
    let exerciseViewModel: ExerciseViewModel
    let workoutViewModel: WorkoutDayViewModel
    let selectedDate: Date
    let alertType: Binding<AlertType?>
    let showingAlert: Binding<Bool>
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        Button {
            if isFromWokroutDayView {
                addExerciseToWorkoutDay(for: exercise, isFromWokroutDayView: true)
            } else {
                exerciseViewModel.selectedExercise = exercise
                navigationPath.append(exercise)
            }
        } label: {
            HStack {
                exerciseImage(for: exercise)
                    .frame(width: 100, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                
                Text(exercise.name ?? "Unknown")
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                    .padding(.leading, 10)
                
                Spacer()
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
        }
        .swipeActions {
            if exercise.isDefault {
                lockedSwipeAction(for: exercise)
            } else {
                deleteSwipeAction(for: exercise)
            }
            favouriteSwipeAction(for: exercise)
        }
    }
    
    private func addExerciseToWorkoutDay(for exercise: DefaultExercise, isFromWokroutDayView: Bool = false) {
        if isFromWokroutDayView {
            if let workoutDay = workoutViewModel.workoutDay(for: selectedDate),
               workoutDay.exercisesArray.contains(where: { $0.id == exercise.id }) {
                alertType.wrappedValue = .alreadyAdded
                showingAlert.wrappedValue = true
            } else {
                workoutViewModel.addExerciseToWorkoutDay(exercise, date: selectedDate)
                workoutViewModel.fetchWorkoutDays()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private func deleteSwipeAction(for exercise: DefaultExercise) -> some View {
        Button(action: {
            deleteExercise(exercise)
        }) {
            Label("Delete", systemImage: "trash")
                .foregroundColor(.text)
        }
        .tint(.red)
    }
    
    private func favouriteSwipeAction(for exercise: DefaultExercise) -> some View {
        Button(action: {
            toggleFavourite(for: exercise)
        }) {
            Image(uiImage: UIImage(systemName: exercise.isFavourite ? "heart.fill" : "heart")!
                .withTintColor(exercise.isFavourite ? .red : .gray, renderingMode: .alwaysOriginal))
        }
        .tint(.clear)
    }
    
    private func toggleFavourite(for exercise: DefaultExercise) {
        exerciseViewModel.toggleFavourite(for: exercise)
    }
    
    private func lockedSwipeAction(for exercise: DefaultExercise) -> some View {
        Button(action: {
            alertType.wrappedValue = .defaultExercise
            showingAlert.wrappedValue = true
        }) {
            Image(systemName: "lock.fill")
                .foregroundColor(.text)
        }
        .tint(.gray)
    }
    
    private func exerciseImage(for item: DefaultExercise) -> some View {
        let defaultExerciseImage = UIImage(named: "defaultExerciseImage")!
        let image: UIImage
        if let imageData = item.image, let userImage = UIImage(data: imageData) {
            image = userImage
        } else {
            image = defaultExerciseImage
        }
        
        return Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}
