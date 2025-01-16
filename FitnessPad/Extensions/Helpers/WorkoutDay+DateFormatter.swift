//
//  WorkoutDay+DateFormatter.swift
//  FitnessPad
//
//  Created by Марк Кулик on 15.01.2025.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: self)
    }
}
