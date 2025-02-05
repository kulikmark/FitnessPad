//
//  ExercisesViewSearchBar.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

struct ExercisesViewSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField(LocalizedStringKey("exercises_search_placeholder"), text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Spacer()
                        if !text.isEmpty { // Показываем кнопку, если текст не пустой
                            Button(action: {
                                text = "" // Очищаем текст
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(8)
                            }
                        }
                    }
                )
                .padding(.trailing, 10)
        }
        .padding(.horizontal)
    }
}
