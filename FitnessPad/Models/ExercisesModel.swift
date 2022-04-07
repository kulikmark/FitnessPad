//
//  ExercisesModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.04.2022.
//

import Foundation

extension Exercise {
static let exercises: [Exercise] = [
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

struct Exercise: Identifiable {
    var id = UUID()
    var exerciseName: String
    var exerciseImage: String
//    var set: Int
//    var weight: String
//    var reps: String
}
