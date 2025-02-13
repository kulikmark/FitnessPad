//
//  BackButton.swift
//  FitnessPad
//
//  Created by Марк Кулик on 12.08.2024.
//
import SwiftUI

struct CustomBackButtonView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(8)
                .background(Circle().fill(Color("ViewColor")))
        }
        .padding(.trailing, 5)
    }
}
