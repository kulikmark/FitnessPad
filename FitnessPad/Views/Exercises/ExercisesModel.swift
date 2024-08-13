//
//  ExercisesModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.04.2022.
//

import Foundation

//enum ExerciseType: String, CaseIterable  {
//    
//    case pullups = "Pull-Ups"
//    case dumbbellrow = "Dumbbell Row"
//    case pushups = "Push-Ups"
//    case benchpress = "Bench Press"
//    case pikepushups = "Pike Push-Ups"
//    case shoulderpress = "Shoulder Press"
//    case squat = "Squat"
//    case pistolsquats = "Pistol Squats"
//    case hummercurls = "Hammer Curls"
//    case bicepcurls = "Bicep Curls"
//}
//
//struct ExerciseGroup {
//    let name: String
//    let exercises: [ExerciseItem]
//}
//
//struct ExerciseItem: Identifiable, Equatable {
//    var id = UUID()
//    var exerciseName: String
//    var exerciseImage: String
//    var type: ExerciseType
//    var exerciseSets = [ExerciseSet]()
//    init (with type: ExerciseType) {
//        self.type = type
//        exerciseName = type.rawValue
//        exerciseImage = type.rawValue
//    }
//    
//    static let exercises: [ExerciseItem] = [
//        ExerciseItem(with: .pullups),
//        ExerciseItem(with: .dumbbellrow),
//        ExerciseItem(with: .shoulderpress),
//        ExerciseItem(with: .pikepushups),
//        ExerciseItem(with: .pushups),
//        ExerciseItem(with: .benchpress),
//        ExerciseItem(with: .squat),
//        ExerciseItem(with: .pistolsquats),
//        ExerciseItem(with: .hummercurls),
//        ExerciseItem(with: .bicepcurls)
//    ]
//}
//
//let exerciseGroups: [ExerciseGroup] = [
//    ExerciseGroup(name: "Chest", exercises: [
//        ExerciseItem(with: .benchpress),
//        ExerciseItem(with: .pushups)
//    ]),
//    ExerciseGroup(name: "Shoulders", exercises: [
//        ExerciseItem(with: .shoulderpress),
//        ExerciseItem(with: .pikepushups)
//    ]),
//    ExerciseGroup(name: "ABS", exercises: []),
//    ExerciseGroup(name: "Arms", exercises: [
//        ExerciseItem(with: .hummercurls),
//        ExerciseItem(with: .bicepcurls)
//    ]),
//    ExerciseGroup(name: "Back", exercises: [
//        ExerciseItem(with: .pullups),
//        ExerciseItem(with: .dumbbellrow)
//    ]),
//    ExerciseGroup(name: "Legs", exercises: [
//        ExerciseItem(with: .squat),
//        ExerciseItem(with: .pistolsquats)
//    ]),
//    ExerciseGroup(name: "Cardio", exercises: []),
//    
//    ExerciseGroup(name: "Others", exercises: [])
//]

//import Foundation
//import SwiftUI
//import CoreData
//
//// Модель ExerciseItem теперь включает Core Data
//class ExerciseItem: Identifiable {
//    var id = UUID()
//    var exerciseName: String
//    var exerciseImage: UIImage?
//
//    init(exerciseName: String, exerciseImage: UIImage? = nil) {
//        self.exerciseName = exerciseName
//        self.exerciseImage = exerciseImage
//    }
//
//    // Преобразование UIImage в Data
//    func toData() -> Data? {
//        return exerciseImage?.jpegData(compressionQuality: 1.0)
//    }
//}
//
//struct ExerciseGroup {
//    let name: String
//    var exercises: [ExerciseItem]
//}
//
//// Создание ExerciseItem с использованием UIImage из Assets
//let exerciseItems: [ExerciseItem] = [
//    ExerciseItem(exerciseName: "Pull-Ups", exerciseImage: UIImage(named: "Pull-Ups")),
//    ExerciseItem(exerciseName: "Dumbbell Row", exerciseImage: UIImage(named: "Dumbbell Row")),
//    ExerciseItem(exerciseName: "Shoulder Press", exerciseImage: UIImage(named: "Shoulder Press")),
//    ExerciseItem(exerciseName: "Pike Push-Ups", exerciseImage: UIImage(named: "Pike Push-Ups")),
//    ExerciseItem(exerciseName: "Push-Ups", exerciseImage: UIImage(named: "Push-Ups")),
//    ExerciseItem(exerciseName: "Bench Press", exerciseImage: UIImage(named: "Bench Press")),
//    ExerciseItem(exerciseName: "Squat", exerciseImage: UIImage(named: "Squat")),
//    ExerciseItem(exerciseName: "Pistol Squats", exerciseImage: UIImage(named: "Pistol Squats")),
//    ExerciseItem(exerciseName: "Hammer Curls", exerciseImage: UIImage(named: "Hammer Curls")),
//    ExerciseItem(exerciseName: "Bicep Curls", exerciseImage: UIImage(named: "Bicep Curls"))
//]
//
//var exerciseGroups: [ExerciseGroup] = [
//    ExerciseGroup(name: "Chest", exercises: [
//        ExerciseItem(exerciseName: "Bench Press", exerciseImage: UIImage(named: "Bench Press")),
//        ExerciseItem(exerciseName: "Push-Ups", exerciseImage: UIImage(named: "Push-Ups"))
//    ]),
//    ExerciseGroup(name: "Shoulders", exercises: [
//        ExerciseItem(exerciseName: "Shoulder Press", exerciseImage: UIImage(named: "Shoulder Press")),
//        ExerciseItem(exerciseName: "Pike Push-Ups", exerciseImage: UIImage(named: "Pike Push-Ups"))
//    ]),
//    ExerciseGroup(name: "ABS", exercises: []),
//    ExerciseGroup(name: "Arms", exercises: [
//        ExerciseItem(exerciseName: "Hammer Curls", exerciseImage: UIImage(named: "Hammer Curls")),
//        ExerciseItem(exerciseName: "Bicep Curls", exerciseImage: UIImage(named: "Bicep Curls"))
//    ]),
//    ExerciseGroup(name: "Back", exercises: [
//        ExerciseItem(exerciseName: "Pull-Ups", exerciseImage: UIImage(named: "Pull-Ups")),
//        ExerciseItem(exerciseName: "Dumbbell Row", exerciseImage: UIImage(named: "Dumbbell Row"))
//    ]),
//    ExerciseGroup(name: "Legs", exercises: [
//        ExerciseItem(exerciseName: "Squat", exerciseImage: UIImage(named: "Squat")),
//        ExerciseItem(exerciseName: "Pistol Squats", exerciseImage: UIImage(named: "Pistol Squats"))
//    ]),
//    ExerciseGroup(name: "Cardio", exercises: []),
//    ExerciseGroup(name: "Others", exercises: [])
//]
