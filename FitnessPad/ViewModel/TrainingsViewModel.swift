//
//  TrainingsViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.03.2022.
//

import SwiftUI

class TrainingsViewModel: ObservableObject {
    @Published var chosenDate: Date = Date()
    @Published var chosenExercise = ""

    @Published var exercisesArray: [Exercise] = []
    
    func addExercise(chosenExercise: Exercise) {
        exercisesArray.append(chosenExercise)
    }
}


