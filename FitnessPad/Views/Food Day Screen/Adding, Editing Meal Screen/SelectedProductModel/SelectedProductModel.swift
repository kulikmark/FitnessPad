//
//  SelectedProduct.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import Foundation

struct SelectedProductModel: Identifiable {
    let id = UUID()
    let product: ProductItem
    var quantity: Double = 100
    
    var totalProteins: Double {
        (product.proteins * quantity) / 100
    }
    
    var totalFats: Double {
        (product.fats * quantity) / 100
    }
    
    var totalCarbohydrates: Double {
        (product.carbohydrates * quantity) / 100
    }
    
    var totalCalories: Double {
        (product.calories * quantity) / 100
    }
}
