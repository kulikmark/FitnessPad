//
//  MealFormViewExtension.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import Foundation

extension MealFormView {
    var totalProteins: Double {
        selectedProducts.reduce(0) { $0 + $1.totalProteins }
    }
    
    var totalFats: Double {
        selectedProducts.reduce(0) { $0 + $1.totalFats }
    }
    
    var totalCarbohydrates: Double {
        selectedProducts.reduce(0) { $0 + $1.totalCarbohydrates }
    }
    
    var totalCalories: Double {
        selectedProducts.reduce(0) { $0 + $1.totalCalories }
    }
}
