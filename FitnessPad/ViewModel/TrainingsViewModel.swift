//
//  TrainingsViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.03.2022.
//

import SwiftUI

class TrainingsViewModel: ObservableObject {
    @Published var chosenDate: Date = Date()
    
    @Published var chosenExerciseType: ExerciseType = .pullups
    
    @Published var exercisesArray: [Exercise] = []
    
    func addExercise(chosenExerciseType: ExerciseType) {
        var exercise = Exercise.init(with: chosenExerciseType)
        exercise.exerciseSets.append(ExerciseSet(weight: "", reps: ""))
        exercisesArray.append(exercise)
    }
}



