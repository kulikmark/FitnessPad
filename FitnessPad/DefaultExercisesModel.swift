//
//  ExercisesModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.04.2022.
//

import CoreData
import SwiftUI

// MARK: - ExerciseItem Model
class DefaultExerciseItem {
    var id: UUID
    var exerciseName: String
    var exerciseImage: UIImage?
    var categoryName: String?
    var attributeItems: [ExerciseAttributeItem] = []
    var isFavourite: Bool
    var exerciseDescription: String?
    var video: Data?

    init(
        exerciseName: String,
        exerciseImage: UIImage? = nil,
        categoryName: String? = nil,
        attributes: [ExerciseAttributeItem] = [],
        isFavourite: Bool = false,
        exerciseDescription: String? = nil,
        video: Data? = nil
    ) {
        self.id = UUID()
        self.exerciseName = exerciseName
        self.exerciseImage = exerciseImage
        self.categoryName = categoryName
        self.attributeItems = attributes
        self.isFavourite = isFavourite
        self.exerciseDescription = exerciseDescription
        self.video = video
    }

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

//// MARK: - Default Exercise Items
//let exerciseItems: [DefaultExerciseItem] = [
//    DefaultExerciseItem(
//        exerciseName: "Bicep Curls",
//        exerciseImage: UIImage(named: "Bicep Curls"),
//        categoryName: "Arms",
//        attributes: [
//            ExerciseAttributeItem(name: "Weight", isAdded: true),
//            ExerciseAttributeItem(name: "Reps", isAdded: true)
//        ],
//        exerciseDescription: "Bicep curls are a classic arm exercise that targets the biceps muscles. Use dumbbells or a barbell for this exercise.",
//        video: loadVideoData(named: "bicep_curls.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Bench Press",
//        exerciseImage: UIImage(named: "Bench Press"),
//        categoryName: "Chest",
//        attributes: [
//            ExerciseAttributeItem(name: "Weight", isAdded: true),
//            ExerciseAttributeItem(name: "Reps", isAdded: true)
//        ],
//        exerciseDescription: "The bench press is a compound exercise that targets the chest, shoulders, and triceps. Perform it on a flat bench with a barbell.",
//        video: loadVideoData(named: "bench_press.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Dumbbell Row",
//        exerciseImage: UIImage(named: "Dumbbell Row"),
//        categoryName: "Back",
//        attributes: [
//            ExerciseAttributeItem(name: "Weight", isAdded: true),
//            ExerciseAttributeItem(name: "Reps", isAdded: true)
//        ],
//        exerciseDescription: "Dumbbell rows are great for strengthening the back muscles. Use a bench for support and perform the exercise with one arm at a time.",
//        video: loadVideoData(named: "dumbbell_row.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Hammer Curls",
//        exerciseImage: UIImage(named: "Hammer Curls"),
//        categoryName: "Arms",
//        attributes: [
//            ExerciseAttributeItem(name: "Weight", isAdded: true),
//            ExerciseAttributeItem(name: "Reps", isAdded: true)
//        ],
//        exerciseDescription: "Hammer curls target the biceps and forearms. Hold the dumbbells with a neutral grip (palms facing each other) for this variation.",
//        video: loadVideoData(named: "hammer_curls.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Outside Running",
//        exerciseImage: UIImage(named: "Outside Running"),
//        categoryName: "Cardio",
//        attributes: [
//            ExerciseAttributeItem(name: "Time", isAdded: true),
//            ExerciseAttributeItem(name: "Distance", isAdded: true)
//        ],
//        exerciseDescription: "Running outdoors is an excellent cardio exercise. It improves cardiovascular health and burns calories effectively.",
//        video: loadVideoData(named: "outside_running.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Plank",
//        exerciseImage: UIImage(named: "Plank"),
//        categoryName: "ABS",
//        attributes: [
//            ExerciseAttributeItem(name: "Time", isAdded: true)
//        ],
//        exerciseDescription: "The plank is a core-strengthening exercise. Maintain a straight body position while holding the plank for the desired time.",
//        video: loadVideoData(named: "plank.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Pike Push-Ups",
//        exerciseImage: UIImage(named: "Pike Push-Ups"),
//        categoryName: "Shoulders",
//        attributes: [
//            ExerciseAttributeItem(name: "Reps", isAdded: true)
//        ],
//        exerciseDescription: "Pike push-ups target the shoulders and triceps. Elevate your hips to form a pike position and perform the push-ups.",
//        video: loadVideoData(named: "pike_push_ups.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Pistol Squats",
//        exerciseImage: UIImage(named: "Pistol Squats"),
//        categoryName: "Legs",
//        attributes: [
//            ExerciseAttributeItem(name: "Reps", isAdded: true)
//        ],
//        exerciseDescription: "Pistol squats are a challenging leg exercise that improves balance and strength. Perform them on one leg at a time.",
//        video: loadVideoData(named: "pistol_squats.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Pull-Ups",
//        exerciseImage: UIImage(named: "Pull-Ups"),
//        categoryName: "Back",
//        attributes: [
//            ExerciseAttributeItem(name: "Reps", isAdded: true)
//        ],
//        exerciseDescription: "Pull-ups are a great upper body exercise that targets the back, shoulders, and arms. Use a pull-up bar for this exercise.",
//        video: loadVideoData(named: "pull_ups.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Push-Ups",
//        exerciseImage: UIImage(named: "Push-Ups"),
//        categoryName: "Chest",
//        attributes: [
//            ExerciseAttributeItem(name: "Reps", isAdded: true)
//        ],
//        exerciseDescription: "Push-ups are a classic bodyweight exercise that targets the chest, shoulders, and triceps. Perform them with proper form.",
//        video: loadVideoData(named: "push_ups.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Treadmill Running",
//        exerciseImage: UIImage(named: "Treadmill Running"),
//        categoryName: "Cardio",
//        attributes: [
//            ExerciseAttributeItem(name: "Time", isAdded: true),
//            ExerciseAttributeItem(name: "Distance", isAdded: true)
//        ],
//        exerciseDescription: "Running on a treadmill is a convenient way to perform cardio indoors. Adjust the speed and incline to match your fitness level.",
//        video: loadVideoData(named: "treadmill_running.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Shoulder Press",
//        exerciseImage: UIImage(named: "Shoulder Press"),
//        categoryName: "Shoulders",
//        attributes: [
//            ExerciseAttributeItem(name: "Weight", isAdded: true),
//            ExerciseAttributeItem(name: "Reps", isAdded: true)
//        ],
//        exerciseDescription: "The shoulder press targets the deltoid muscles. Use dumbbells or a barbell to perform this exercise.",
//        video: loadVideoData(named: "shoulder_press.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Squat",
//        exerciseImage: UIImage(named: "Squat"),
//        categoryName: "Legs",
//        attributes: [
//            ExerciseAttributeItem(name: "Weight", isAdded: true),
//            ExerciseAttributeItem(name: "Reps", isAdded: true)
//        ],
//        exerciseDescription: "Squats are a fundamental lower body exercise that targets the quads, hamstrings, and glutes. Use a barbell or bodyweight.",
//        video: loadVideoData(named: "squat.mp4")
//    ),
//    DefaultExerciseItem(
//        exerciseName: "Swimming",
//        exerciseImage: UIImage(named: "Swimming"),
//        categoryName: "Cardio",
//        attributes: [
//            ExerciseAttributeItem(name: "Time", isAdded: true),
//            ExerciseAttributeItem(name: "Distance", isAdded: true)
//        ],
//        exerciseDescription: "Swimming is a full-body cardio exercise that improves endurance and strength. Swim laps in a pool for the best results.",
//        video: loadVideoData(named: "swimming.mp4")
//    )
//]

let exerciseItems: [DefaultExerciseItem] = [
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("bicep_curls_name", comment: ""),
        exerciseImage: UIImage(named: "Bicep Curls"),
        categoryName: NSLocalizedString("category_arms", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_weight", comment: ""), isAdded: true),
            ExerciseAttributeItem(name: NSLocalizedString("attribute_reps", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("bicep_curls_description", comment: ""),
        video: loadVideoData(named: "bicep_curls.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("bench_press_name", comment: ""),
        exerciseImage: UIImage(named: "Bench Press"),
        categoryName: NSLocalizedString("category_chest", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_weight", comment: ""), isAdded: true),
            ExerciseAttributeItem(name: NSLocalizedString("attribute_reps", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("bench_press_description", comment: ""),
        video: loadVideoData(named: "bench_press.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("dumbbell_row_name", comment: ""),
        exerciseImage: UIImage(named: "Dumbbell Row"),
        categoryName: NSLocalizedString("category_back", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_weight", comment: ""), isAdded: true),
            ExerciseAttributeItem(name: NSLocalizedString("attribute_reps", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("dumbbell_row_description", comment: ""),
        video: loadVideoData(named: "dumbbell_row.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("hammer_curls_name", comment: ""),
        exerciseImage: UIImage(named: "Hammer Curls"),
        categoryName: NSLocalizedString("category_arms", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_weight", comment: ""), isAdded: true),
            ExerciseAttributeItem(name: NSLocalizedString("attribute_reps", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("hammer_curls_description", comment: ""),
        video: loadVideoData(named: "hammer_curls.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("outside_running_name", comment: ""),
        exerciseImage: UIImage(named: "Outside Running"),
        categoryName: NSLocalizedString("category_cardio", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_time", comment: ""), isAdded: true),
            ExerciseAttributeItem(name: NSLocalizedString("attribute_distance", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("outside_running_description", comment: ""),
        video: loadVideoData(named: "outside_running.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("plank_name", comment: ""),
        exerciseImage: UIImage(named: "Plank"),
        categoryName: NSLocalizedString("category_abs", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_time", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("plank_description", comment: ""),
        video: loadVideoData(named: "plank.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("pike_push_ups_name", comment: ""),
        exerciseImage: UIImage(named: "Pike Push-Ups"),
        categoryName: NSLocalizedString("category_shoulders", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_reps", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("pike_push_ups_description", comment: ""),
        video: loadVideoData(named: "pike_push_ups.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("pistol_squats_name", comment: ""),
        exerciseImage: UIImage(named: "Pistol Squats"),
        categoryName: NSLocalizedString("category_legs", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_reps", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("pistol_squats_description", comment: ""),
        video: loadVideoData(named: "pistol_squats.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("pull_ups_name", comment: ""),
        exerciseImage: UIImage(named: "Pull-Ups"),
        categoryName: NSLocalizedString("category_back", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_reps", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("pull_ups_description", comment: ""),
        video: loadVideoData(named: "pull_ups.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("push_ups_name", comment: ""),
        exerciseImage: UIImage(named: "Push-Ups"),
        categoryName: NSLocalizedString("category_chest", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_reps", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("push_ups_description", comment: ""),
        video: loadVideoData(named: "push_ups.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("treadmill_running_name", comment: ""),
        exerciseImage: UIImage(named: "Treadmill Running"),
        categoryName: NSLocalizedString("category_cardio", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_time", comment: ""), isAdded: true),
            ExerciseAttributeItem(name: NSLocalizedString("attribute_distance", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("treadmill_running_description", comment: ""),
        video: loadVideoData(named: "treadmill_running.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("shoulder_press_name", comment: ""),
        exerciseImage: UIImage(named: "Shoulder Press"),
        categoryName: NSLocalizedString("category_shoulders", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_weight", comment: ""), isAdded: true),
            ExerciseAttributeItem(name: NSLocalizedString("attribute_reps", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("shoulder_press_description", comment: ""),
        video: loadVideoData(named: "shoulder_press.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("squat_name", comment: ""),
        exerciseImage: UIImage(named: "Squat"),
        categoryName: NSLocalizedString("category_legs", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_weight", comment: ""), isAdded: true),
            ExerciseAttributeItem(name: NSLocalizedString("attribute_reps", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("squat_description", comment: ""),
        video: loadVideoData(named: "squat.mp4")
    ),
    DefaultExerciseItem(
        exerciseName: NSLocalizedString("swimming_name", comment: ""),
        exerciseImage: UIImage(named: "Swimming"),
        categoryName: NSLocalizedString("category_cardio", comment: ""),
        attributes: [
            ExerciseAttributeItem(name: NSLocalizedString("attribute_time", comment: ""), isAdded: true),
            ExerciseAttributeItem(name: NSLocalizedString("attribute_distance", comment: ""), isAdded: true)
        ],
        exerciseDescription: NSLocalizedString("swimming_description", comment: ""),
        video: loadVideoData(named: "swimming.mp4")
    )
]

// Функция для загрузки видео из ресурсов
func loadVideoData(named: String) -> Data? {
    guard let url = Bundle.main.url(forResource: named, withExtension: nil) else {
        return nil
    }
    return try? Data(contentsOf: url)
}

// Функция для группировки упражнений по категориям
func groupExercisesByCategory() -> [ExerciseGroup] {
    var groupedExercises: [String: [DefaultExerciseItem]] = [:]
    
    for exercise in exerciseItems {
        guard let category = exercise.categoryName else { continue }
        if groupedExercises[category] == nil {
            groupedExercises[category] = []
        }
        groupedExercises[category]?.append(exercise)
    }
    
    return groupedExercises.map { ExerciseGroup(name: $0.key, exercises: $0.value) }
}

// MARK: - Default Exercise Groups
let defaultExerciseGroups = groupExercisesByCategory()
