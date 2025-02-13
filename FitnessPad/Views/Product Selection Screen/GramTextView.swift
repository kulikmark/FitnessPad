//
//  GramTextView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 12.02.2025.
//

import SwiftUI

// Компонент для отображения граммовки
struct GramTextView: View {
    let grams: Double
    var onTap: () -> Void
    
    var body: some View {
        Text(formatGrams(grams))
            .font(.system(size: 14))
            .frame(minWidth: 40, maxWidth: 60)
            .padding(6)
            .background(Color(.systemGray4))
            .foregroundColor(Color("ButtonTextColor"))
            .cornerRadius(8)
            .onTapGesture(perform: onTap)
    }
    
    // Функция для форматирования граммов
    private func formatGrams(_ grams: Double) -> String {
        if grams >= 1000 {
            let kilograms = grams / 1000
            return String(format: "%.2f kg", kilograms)
        } else {
            return String(format: "%.0f g", grams)
        }
    }
}
