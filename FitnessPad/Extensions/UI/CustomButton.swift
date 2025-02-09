//
//  CustomButton.swift
//  FitnessPad
//
//  Created by Марк Кулик on 17.01.2025.
//

import SwiftUI
struct CustomButton: View {
    var title: String
    var isEnabled: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18))
                .foregroundColor(Color("ButtonTextColor"))
                .frame(maxWidth: .infinity) // Заполнение по ширине
                .padding()
                .background(isEnabled ? Color("ButtonColor") : Color.gray)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .disabled(!isEnabled)
    }
}

