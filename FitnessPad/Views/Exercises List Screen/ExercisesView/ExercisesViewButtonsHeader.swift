//
//  ExercisesViewButtonsHeader.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.02.2025.
//

import SwiftUI

struct ExercisesViewButtonsHeader: View {
    @Binding var showFavouritesOnly: Bool
    @Binding var isShowingAddExerciseView: Bool
    @Binding var alertType: AlertType?
    @Binding var showingAlert: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            ButtonWithLabelAndImage(
                label: "restore_exercises_button",
                systemImageName: "arrow.counterclockwise",
                labelColor: Color("TextColor"),
                imageColor: Color("TextColor"),
                action: {
                    alertType = .resetDefaults
                    showingAlert = true
                }
            )
            Spacer()
            ButtonWithLabelAndImage(
                label: "favourites_only_button",
                systemImageName: showFavouritesOnly ? "heart.fill" : "heart",
                labelColor: Color("TextColor"),
                imageColor: showFavouritesOnly ? .red : Color("TextColor"),
                action: {
                    showFavouritesOnly.toggle()
                }
            )
            ButtonWithLabelAndImage(
                label: "add_exercise_button",
                systemImageName: "plus",
                labelColor: Color("TextColor"),
                imageColor: Color("TextColor"),
                action: {
                    isShowingAddExerciseView = true
                }
            )
        }
        .padding(.horizontal)
    }
}
