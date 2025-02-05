//
//  NutritionInfoRow.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

struct NutritionInfoRow: View {
    let label: String
    let value: Double
    let unit: String
    
    var body: some View {
        HStack {
            Text(label.localized) // Локализуем метку
            Spacer()
            Text("\(value, specifier: "%.1f") \(unit.localized)") // Локализуем единицу измерения
                .foregroundColor(.secondary)
        }
    }
}
