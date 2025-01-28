//
//  CustomTextField.swift
//  FitnessPad
//
//  Created by Марк Кулик on 17.01.2025.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isValid: Bool
    var errorMessage: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
                .padding()
                .background(isValid ? Color("ViewColor") : Color.red.opacity(0.3))
                .cornerRadius(15)
                .padding(8)
                .keyboardType(keyboardType)
            
            Text(errorMessage)
                .font(.system(size: 12))
                .foregroundColor(isValid ? .gray : .red)
                .padding(.leading, 16)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color("ViewColor").opacity(0.2))
        .cornerRadius(8)
    }
}

//#Preview {
//    CustomTextField()
//}
