//
//  BodyWeightViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 04.02.2025.
//

import SwiftUI
import CoreData

class BodyWeightViewModel: ObservableObject {

    private let bodyWeightService: BodyWeightService

    init(
        bodyWeightService: BodyWeightService
    ) {
     
        self.bodyWeightService = bodyWeightService
    }
    
    // MARK: - Body Weight Management
    func saveBodyWeight(for date: Date, weight: Double) {
        bodyWeightService.saveBodyWeight(for: date, weight: weight)
    }
    
    func updateBodyWeight(for date: Date, newWeight: Double) {
        bodyWeightService.updateBodyWeight(for: date, newWeight: newWeight)
    }
    
    func fetchBodyWeight(for date: Date) -> BodyWeight? {
        bodyWeightService.fetchBodyWeight(for: date)
    }
    
    func fetchBodyWeights() -> [BodyWeight] {
        bodyWeightService.fetchBodyWeights()
    }
    
}
