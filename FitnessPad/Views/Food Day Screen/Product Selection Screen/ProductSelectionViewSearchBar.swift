//
//  SearchBar.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

struct ProductSelectionViewSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField(LocalizedStringKey("product_search_placeholder"), text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Spacer()
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(8)
                            }
                        }
                    }
                )
            CloseButtonCircle()
              
        }
        .padding(.horizontal)
    }
}
