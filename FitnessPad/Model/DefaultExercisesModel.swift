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

// MARK: - Default Exercise Items
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
