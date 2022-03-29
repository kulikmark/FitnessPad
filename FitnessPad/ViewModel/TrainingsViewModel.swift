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
}

class TrainingsViewModel: ObservableObject {
    @Published var chosenDate: Date = Date()
    @Published var chosenExercise: String = String()
    
    @Published var exercises: [Exercise] = []
    init() {
        self.exercises = [
            Exercise(exerciseName: "Pull-Ups"),
            Exercise(exerciseName: "Push-Ups"),
            Exercise(exerciseName: "Pike Push-Ups"),
            Exercise(exerciseName: "Squat"),
            Exercise(exerciseName: "Pistol Squats"),
            Exercise(exerciseName: "Bench Press"),
            Exercise(exerciseName: "Shoulder Press"),
            Exercise(exerciseName: "Bicep Curls")
        ]
    }
}


