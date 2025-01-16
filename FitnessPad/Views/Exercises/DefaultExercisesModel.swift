//
//  ExercisesModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.04.2022.
//

import SwiftUI

// MARK: - ExerciseItem Model
class DefaultExerciseItem {
    var id: UUID
    var exerciseName: String
    var exerciseImage: UIImage?
    var categoryName: String?
    var attributeItems: [ExerciseAttributeItem] = []

    init(exerciseName: String, exerciseImage: UIImage? = nil, categoryName: String? = nil, attributes: [ExerciseAttributeItem] = []) {
        self.id = UUID()
        self.exerciseName = exerciseName
        self.exerciseImage = exerciseImage
        self.categoryName = categoryName
        self.attributeItems = attributes
    }
    // Convert UIImage to Data
    func toData() -> Data? {
        return exerciseImage?.jpegData(compressionQuality: 1.0)
    }
}

// Модель для атрибутов по умолчанию
struct ExerciseAttributeItem {
    var name: String
    var isAdded: Bool
}

// MARK: - ExerciseGroup Structure
struct ExerciseGroup {
    var name: String
    var exercises: [DefaultExerciseItem]
}

// MARK: - Default Exercise Items
let exerciseItems: [DefaultExerciseItem] = [
    DefaultExerciseItem(exerciseName: "Bicep Curls", exerciseImage: UIImage(named: "Bicep Curls"), attributes: [
        ExerciseAttributeItem(name: "Weight", isAdded: true),
        ExerciseAttributeItem(name: "Reps", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Bench Press", exerciseImage: UIImage(named: "Bench Press"), attributes: [
        ExerciseAttributeItem(name: "Weight", isAdded: true),
        ExerciseAttributeItem(name: "Reps", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Dumbbell Row", exerciseImage: UIImage(named: "Dumbbell Row"), attributes: [
        ExerciseAttributeItem(name: "Weight", isAdded: true),
        ExerciseAttributeItem(name: "Reps", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Hammer Curls", exerciseImage: UIImage(named: "Hammer Curls"), attributes: [
        ExerciseAttributeItem(name: "Weight", isAdded: true),
        ExerciseAttributeItem(name: "Reps", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Outside Running", exerciseImage: UIImage(named: "Outside Running"), attributes: [
        ExerciseAttributeItem(name: "Time", isAdded: true),
        ExerciseAttributeItem(name: "Distance", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Plank", exerciseImage: UIImage(named: "Plank"), attributes: [
        ExerciseAttributeItem(name: "Time", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Pike Push-Ups", exerciseImage: UIImage(named: "Pike Push-Ups"), attributes: [
        ExerciseAttributeItem(name: "Reps", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Pistol Squats", exerciseImage: UIImage(named: "Pistol Squats"), attributes: [
        ExerciseAttributeItem(name: "Reps", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Pull-Ups", exerciseImage: UIImage(named: "Pull-Ups"), attributes: [
        ExerciseAttributeItem(name: "Reps", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Push-Ups", exerciseImage: UIImage(named: "Push-Ups"), attributes: [
        ExerciseAttributeItem(name: "Reps", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Treadmill Running", exerciseImage: UIImage(named: "Treadmill Running"), attributes: [
        ExerciseAttributeItem(name: "Time", isAdded: true),
        ExerciseAttributeItem(name: "Distance", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Shoulder Press", exerciseImage: UIImage(named: "Shoulder Press"), attributes: [
        ExerciseAttributeItem(name: "Weight", isAdded: true),
        ExerciseAttributeItem(name: "Reps", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Squat", exerciseImage: UIImage(named: "Squat"), attributes: [
        ExerciseAttributeItem(name: "Weight", isAdded: true),
        ExerciseAttributeItem(name: "Reps", isAdded: true)
    ]),
    DefaultExerciseItem(exerciseName: "Swimming", exerciseImage: UIImage(named: "Swimming"), attributes: [
        ExerciseAttributeItem(name: "Time", isAdded: true),
        ExerciseAttributeItem(name: "Distance", isAdded: true)
    ])
]


// MARK: - Default Exercise Groups
var defaultExerciseGroups: [ExerciseGroup] = [
    ExerciseGroup(name: "ABS", exercises: [
        DefaultExerciseItem(exerciseName: "Plank", exerciseImage: UIImage(named: "Plank"), categoryName: "ABS", attributes: [
            ExerciseAttributeItem(name: "Time", isAdded: true)
        ])
    ]),
    
    ExerciseGroup(name: "Arms", exercises: [
        DefaultExerciseItem(exerciseName: "Bicep Curls", exerciseImage: UIImage(named: "Bicep Curls"), categoryName: "Arms", attributes: [
            ExerciseAttributeItem(name: "Weight", isAdded: true),
            ExerciseAttributeItem(name: "Reps", isAdded: true)
        ]),
        DefaultExerciseItem(exerciseName: "Hammer Curls", exerciseImage: UIImage(named: "Hammer Curls"), categoryName: "Arms", attributes: [
            ExerciseAttributeItem(name: "Weight", isAdded: true),
            ExerciseAttributeItem(name: "Reps", isAdded: true)
        ])
    ]),
    
    ExerciseGroup(name: "Back", exercises: [
        DefaultExerciseItem(exerciseName: "Dumbbell Row", exerciseImage: UIImage(named: "Dumbbell Row"), categoryName: "Back", attributes: [
            ExerciseAttributeItem(name: "Weight", isAdded: true),
            ExerciseAttributeItem(name: "Reps", isAdded: true)
        ]),
        DefaultExerciseItem(exerciseName: "Pull-Ups", exerciseImage: UIImage(named: "Pull-Ups"), categoryName: "Back", attributes: [
            ExerciseAttributeItem(name: "Reps", isAdded: true)
        ])
    ]),
    
    ExerciseGroup(name: "Cardio", exercises: [
        DefaultExerciseItem(exerciseName: "Outside Running", exerciseImage: UIImage(named: "Outside Running"), categoryName: "Cardio", attributes: [
            ExerciseAttributeItem(name: "Time", isAdded: true),
            ExerciseAttributeItem(name: "Distance", isAdded: true)
        ]),
        DefaultExerciseItem(exerciseName: "Treadmill Running", exerciseImage: UIImage(named: "Treadmill Running"), categoryName: "Cardio", attributes: [
            ExerciseAttributeItem(name: "Time", isAdded: true),
            ExerciseAttributeItem(name: "Distance", isAdded: true)
        ]),
        DefaultExerciseItem(exerciseName: "Swimming", exerciseImage: UIImage(named: "Swimming"), categoryName: "Cardio", attributes: [
            ExerciseAttributeItem(name: "Time", isAdded: true),
            ExerciseAttributeItem(name: "Distance", isAdded: true)
        ])
    ]),
    
    ExerciseGroup(name: "Chest", exercises: [
        DefaultExerciseItem(exerciseName: "Bench Press", exerciseImage: UIImage(named: "Bench Press"), categoryName: "Chest", attributes: [
            ExerciseAttributeItem(name: "Weight", isAdded: true),
            ExerciseAttributeItem(name: "Reps", isAdded: true)
        ]),
        DefaultExerciseItem(exerciseName: "Push-Ups", exerciseImage: UIImage(named: "Push-Ups"), categoryName: "Chest", attributes: [
            ExerciseAttributeItem(name: "Reps", isAdded: true)
        ])
    ]),
    
    ExerciseGroup(name: "Legs", exercises: [
        DefaultExerciseItem(exerciseName: "Pistol Squats", exerciseImage: UIImage(named: "Pistol Squats"), categoryName: "Legs", attributes: [
            ExerciseAttributeItem(name: "Reps", isAdded: true)
        ]),
        DefaultExerciseItem(exerciseName: "Squat", exerciseImage: UIImage(named: "Squat"), categoryName: "Legs", attributes: [
            ExerciseAttributeItem(name: "Weight", isAdded: true),
            ExerciseAttributeItem(name: "Reps", isAdded: true)
        ])
    ]),
    
    ExerciseGroup(name: "Shoulders", exercises: [
        DefaultExerciseItem(exerciseName: "Pike Push-Ups", exerciseImage: UIImage(named: "Pike Push-Ups"), categoryName: "Shoulders", attributes: [
            ExerciseAttributeItem(name: "Reps", isAdded: true)
        ]),
        DefaultExerciseItem(exerciseName: "Shoulder Press", exerciseImage: UIImage(named: "Shoulder Press"), categoryName: "Shoulders", attributes: [
            ExerciseAttributeItem(name: "Weight", isAdded: true),
            ExerciseAttributeItem(name: "Reps", isAdded: true)
        ])
    ])
]
