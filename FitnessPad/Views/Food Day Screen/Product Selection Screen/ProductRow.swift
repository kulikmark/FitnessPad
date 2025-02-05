//
//  ProductRow.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

struct ProductRow: View {
    let product: Product
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.system(size: 16))
                    .foregroundStyle(Color("TextColor"))
                
                HStack {
                    Text(String(format: NSLocalizedString("proteins_label", comment: ""), product.proteins))
                    Text(String(format: NSLocalizedString("fats_label", comment: ""), product.fats))
                    Text(String(format: NSLocalizedString("carbs_label", comment: ""), product.carbohydrates))
                    Text(String(format: NSLocalizedString("calories_label", comment: ""), product.calories))
                }
                .font(.system(size: 14))
                .foregroundColor(.gray)
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }
}
