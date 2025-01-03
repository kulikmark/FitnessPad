//
//  ExercisesModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.04.2022.
//

import SwiftUI


// MARK: - ExerciseItem Model
class DefaultExerciseItem {
    var exerciseName: String
    var exerciseImage: UIImage?
    var categoryName: String?

    init(exerciseName: String, exerciseImage: UIImage? = nil, categoryName: String? = nil) {
        self.exerciseName = exerciseName
        self.exerciseImage = exerciseImage
        self.categoryName = categoryName
    }

    // Convert UIImage to Data
    func toData() -> Data? {
        return exerciseImage?.jpegData(compressionQuality: 1.0)
    }

}

// MARK: - ExerciseGroup Structure
struct ExerciseGroup {
    var name: String
    var exercises: [DefaultExerciseItem]
}

// MARK: - Default Exercise Items
let exerciseItems: [DefaultExerciseItem] = [
    // MARK: - Add exercise items
    DefaultExerciseItem(exerciseName: "Bicep Curls", exerciseImage: UIImage(named: "Bicep Curls")),
    DefaultExerciseItem(exerciseName: "Bench Press", exerciseImage: UIImage(named: "Bench Press")),
    DefaultExerciseItem(exerciseName: "Dumbbell Row", exerciseImage: UIImage(named: "Dumbbell Row")),
    DefaultExerciseItem(exerciseName: "Hammer Curls", exerciseImage: UIImage(named: "Hammer Curls")),
    DefaultExerciseItem(exerciseName: "Pike Push-Ups", exerciseImage: UIImage(named: "Pike Push-Ups")),
    DefaultExerciseItem(exerciseName: "Pistol Squats", exerciseImage: UIImage(named: "Pistol Squats")),
    DefaultExerciseItem(exerciseName: "Pull-Ups", exerciseImage: UIImage(named: "Pull-Ups")),
    DefaultExerciseItem(exerciseName: "Push-Ups", exerciseImage: UIImage(named: "Push-Ups")),
    DefaultExerciseItem(exerciseName: "Shoulder Press", exerciseImage: UIImage(named: "Shoulder Press")),
    DefaultExerciseItem(exerciseName: "Squat", exerciseImage: UIImage(named: "Squat"))
]

// MARK: - Default Exercise Groups
var defaultExerciseGroups: [ExerciseGroup] = [
    // MARK: - Define exercise groups
    ExerciseGroup(name: "ABS", exercises: []),
    ExerciseGroup(name: "Arms", exercises: [
        DefaultExerciseItem(exerciseName: "Bicep Curls", exerciseImage: UIImage(named: "Bicep Curls"), categoryName: "Arms"),
        DefaultExerciseItem(exerciseName: "Hammer Curls", exerciseImage: UIImage(named: "Hammer Curls"), categoryName: "Arms")
    ]),
    ExerciseGroup(name: "Back", exercises: [
        DefaultExerciseItem(exerciseName: "Dumbbell Row", exerciseImage: UIImage(named: "Dumbbell Row"), categoryName: "Back"),
        DefaultExerciseItem(exerciseName: "Pull-Ups", exerciseImage: UIImage(named: "Pull-Ups"), categoryName: "Back")
    ]),
    ExerciseGroup(name: "Cardio", exercises: []),
    ExerciseGroup(name: "Chest", exercises: [
        DefaultExerciseItem(exerciseName: "Bench Press", exerciseImage: UIImage(named: "Bench Press"), categoryName: "Chest"),
        DefaultExerciseItem(exerciseName: "Push-Ups", exerciseImage: UIImage(named: "Push-Ups"), categoryName: "Chest")
    ]),
    ExerciseGroup(name: "Legs", exercises: [
        DefaultExerciseItem(exerciseName: "Pistol Squats", exerciseImage: UIImage(named: "Pistol Squats"), categoryName: "Legs"),
        DefaultExerciseItem(exerciseName: "Squat", exerciseImage: UIImage(named: "Squat"), categoryName: "Legs")
    ]),
    ExerciseGroup(name: "Shoulders", exercises: [
        DefaultExerciseItem(exerciseName: "Pike Push-Ups", exerciseImage: UIImage(named: "Pike Push-Ups"), categoryName: "Shoulders"),
        DefaultExerciseItem(exerciseName: "Shoulder Press", exerciseImage: UIImage(named: "Shoulder Press"), categoryName: "Shoulders")
    ])
]
