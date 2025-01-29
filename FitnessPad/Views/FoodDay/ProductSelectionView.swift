//
//  ProductSelectionView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 29.01.2025.
//

import Foundation
import SwiftUI

struct ProductSelectionView: View {
    @Binding var selectedProducts: [Product]
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""
    
    var filteredProductsByCategory: [String: [Product]] {
        if searchText.isEmpty {
            return productsByCategory
        } else {
            return productsByCategory.mapValues { products in
                products.filter { product in
                    product.name.localizedCaseInsensitiveContains(searchText)
                }
            }.filter { !$0.value.isEmpty }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProductsByCategory.keys.sorted(), id: \.self) { category in
                    Section(header: Text(category)) {
                        ForEach(filteredProductsByCategory[category]!) { product in
                            ProductRow(product: product, isSelected: selectedProducts.contains(where: { $0.id == product.id })) {
                                if selectedProducts.contains(where: { $0.id == product.id }) {
                                    selectedProducts.removeAll { $0.id == product.id }
                                } else {
                                    selectedProducts.append(product)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search Products")
        }
    }
}

struct ProductRow: View {
    let product: Product
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(product.name)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }
}

//
//#Preview {
//    ProductSelectionView()
//}
