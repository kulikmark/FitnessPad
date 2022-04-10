//
//  TrainingsViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.03.2022.
//

import SwiftUI

class TrainingsViewModel: ObservableObject {
    @Published var chosenDate: Date = Date()
    
    // !Renamed!
    @Published var chosenExerciseType: ExerciseType

    @Published var exercisesArray: [Exercise] = []
    
    func addExercise(chosenExerciseType: ExerciseType) {
        let exercise = Exercise.init(with: chosenExerciseType)
        setsArray.append(ExerciseSet(weight: "", reps: ""))
        exercisesArray.append(exercise)
    }
}



