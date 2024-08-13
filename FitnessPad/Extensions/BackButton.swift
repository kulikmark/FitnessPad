//
//  BackButton.swift
//  FitnessPad
//
//  Created by Марк Кулик on 12.08.2024.
//
import SwiftUI

struct CustomBackButtonView: View {
    var body: some View {
        HStack {
            // Кастомная кнопка в виде круга с шевроном
            Circle()
                .fill(Color("ViewColor2")) // Цвет фона кнопки
                .frame(width: 40, height: 40) // Размер круга
                .overlay(
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("TextColor")) // Цвет шеврона
                        .font(.system(size: 20, weight: .bold)) // Размер и стиль шеврона
                )
                .onTapGesture {
                    // Действие при нажатии на кнопку
                    // Для возврата на предыдущий экран используем dismiss
                    dismiss()
                }
        }
    }
    
    @Environment(\.dismiss) private var dismiss
}
