//
//  TrainingsViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.03.2022.
//

import SwiftUI

struct Exercise: Identifiable {
    var id = UUID()
    var exerciseName: String
    var exerciseImage: String
}

class TrainingsViewModel: ObservableObject {
    @Published var chosenDate: Date = Date()
    @Published var chosenExercise = ""
    
    @Published var exercises: [Exercise] = []
    init() {
        self.exercises = [
            Exercise(exerciseName: "Pull-Ups", exerciseImage: "Pull-Ups"),
            Exercise(exerciseName: "Dumbbell Row", exerciseImage: "Dumbbell Row"),
            Exercise(exerciseName: "Push-Ups", exerciseImage: "Push-Ups"),
            Exercise(exerciseName: "Bench Press", exerciseImage: "Bench Press"),
            Exercise(exerciseName: "Pike Push-Ups", exerciseImage: "Pike Push-Ups"),
            Exercise(exerciseName: "Shoulder Press", exerciseImage: "Shoulder Press"),
            Exercise(exerciseName: "Squat", exerciseImage: "Squat"),
            Exercise(exerciseName: "Pistol Squats", exerciseImage: "Pistol Squats"),
            Exercise(exerciseName: "Hammer Curls", exerciseImage: "Hammer Curls"),
            Exercise(exerciseName: "Bicep Curls", exerciseImage: "Bicep Curls")
        ]
    }
}


