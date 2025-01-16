//
//  Exercise+SetsArray.swift
//  FitnessPad
//
//  Created by Марк Кулик on 13.01.2025.
//

import Foundation

extension Exercise {
    var setsArray: [ExerciseSet] {
        let set = sets as? Set<ExerciseSet> ?? []
        return set.sorted { $0.count < $1.count }
    }
}
