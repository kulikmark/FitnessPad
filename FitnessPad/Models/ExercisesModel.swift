//
//  ExercisesModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.04.2022.
//

import Foundation

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
        Exercise(with: .dumbbellrow),
        Exercise(with: .shoulderpress),
        Exercise(with: .pikepushups),
        Exercise(with: .pushups),
        Exercise(with: .benchpress),
        Exercise(with: .squat),
        Exercise(with: .pistolsquats),
        Exercise(with: .hummercurls),
        Exercise(with: .bicepcurls)
    ]
}

struct ExerciseSet: Identifiable {
    var id = UUID()
    var count: String = "1"
    var weight: String
    var reps: String
}
