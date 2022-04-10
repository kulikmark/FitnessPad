//
//  ExercisesModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.04.2022.
//

import Foundation

var setsArray = [ExerciseSet]()

enum ExerciseType: String, CaseIterable  {
    
    case pullups = "Pull-Ups"
    case dumbbellrow = "Dumbbell Row"
    case pushups = "Push-Ups"
    case benchpress = "Bench Press"
    case pikepushups = "Pike Push-Ups"
    case shoulderpress = "Shoulder Press"
    case squat = "Squat"
    case pistolsquats = "Pistol Squats"
    case hummercurls = "Hammer Curls"
    case bicepcurls = "Bicep Curls"
}

struct Exercise: Identifiable {
    var id = UUID()
    var exerciseName: String
    var exerciseImage: String
    var type: ExerciseType
    var exerciseSets = [ExerciseSet]()
    init (with type: ExerciseType) {
        self.type = type
        exerciseName = type.rawValue
        exerciseImage = type.rawValue
    }

static let exercises: [Exercise] = [
    Exercise(with: .pullups),
    Exercise(with: .squat),
    Exercise(with: .shoulderpress),
    Exercise(with: .pushups),
    Exercise(with: .pistolsquats),
    Exercise(with: .hummercurls),
    Exercise(with: .pikepushups),
    Exercise(with: .bicepcurls),
    Exercise(with: .benchpress),
    Exercise(with: .dumbbellrow)
    ]
}

struct ExerciseSet {
    var weight: String
    var reps: String
}



//extension Exercise {
//var exercises: [Exercise] = [
//        Exercise(exerciseName: "Pull-Ups", exerciseImage: "Pull-Ups"),
//        Exercise(exerciseName: "Dumbbell Row", exerciseImage: "Dumbbell Row"),
//        Exercise(exerciseName: "Push-Ups", exerciseImage: "Push-Ups"),
//        Exercise(exerciseName: "Bench Press", exerciseImage: "Bench Press"),
//        Exercise(exerciseName: "Pike Push-Ups", exerciseImage: "Pike Push-Ups"),
//        Exercise(exerciseName: "Shoulder Press", exerciseImage: "Shoulder Press"),
//        Exercise(exerciseName: "Squat", exerciseImage: "Squat"),
//        Exercise(exerciseName: "Pistol Squats", exerciseImage: "Pistol Squats"),
//        Exercise(exerciseName: "Hammer Curls", exerciseImage: "Hammer Curls"),
//        Exercise(exerciseName: "Bicep Curls", exerciseImage: "Bicep Curls")
//    ]
//}
