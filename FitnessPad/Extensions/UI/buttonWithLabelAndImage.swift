//
//  buttonWithLabelAndImage.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

extension View {
    func ButtonWithLabelAndImage(
        label: String,
        systemImageName: String,
        labelFont: Font = .system(size: 8),
        imageFont: Font = .system(size: 17),
        labelColor: Color = Color("TextColor"),
        imageColor: Color = Color("TextColor"),
        action: @escaping () -> Void
    ) -> some View {
        HStack(spacing: 10) {
            Text(label.localized)
                .font(labelFont)
                .foregroundColor(labelColor)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
            
            Button(action: action) {
                Image(systemName: systemImageName)
                    .font(imageFont)
                    .foregroundColor(imageColor)
            }
        }
    }
}
