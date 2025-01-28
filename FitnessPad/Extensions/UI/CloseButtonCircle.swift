//
//  CloseButtonCircle.swift
//  FitnessPad
//
//  Created by Марк Кулик on 23.01.2025.
//

import SwiftUI

struct CloseButtonCircle: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(8)
                .background(Circle().fill(Color("ViewColor")))
        }
        .padding(.trailing, 16)
        .padding(.top, 16)
    }
}

#Preview {
    CloseButtonCircle()
}
