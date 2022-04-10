//
//  ChosenExerciseViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.04.2022.
//

import SwiftUI

class ChosenExerciseViewModel: ObservableObject {
    @Published var exerciseName: String = ""
    @Published var set: String = ""
    @Published var weights: String = ""
    @Published var reps: String = ""
}
