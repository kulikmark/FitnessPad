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
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding()
//                    .padding(.horizontal, 40)
                    .background(isEnabled ? Color("ButtonColor") : Color.gray)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
        }
        .disabled(!isEnabled)
    }
}
