//
//  WokroutDay+ExercisesArray.swift
//  FitnessPad
//
//  Created by Марк Кулик on 13.01.2025.
//

import Foundation

extension WorkoutDay {
    var exercisesArray: [Exercise] {
        let set = exercises as? Set<Exercise> ?? []
        return set.sorted { $0.name ?? "" < $1.name ?? "" }
    }
}
