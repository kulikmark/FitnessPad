//
//  ProductListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

struct ProductListView: View {
    @Environment(\.presentationMode) var presentationMode
    let category: String
    @State private var searchText: String = ""
    @Binding var selectedProducts: [Product]
    
    // Фильтруем продукты по выбранной категории
    var products: [Product] {
        let allProducts = productsByCategory[category] ?? []
        
        if searchText.isEmpty {
            return allProducts
        } else {
            return allProducts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            // Поле поиска
            ProductSelectionViewSearchBar(text: $searchText)
            
            List {
                // Раздел для выбранных продуктов
                if !selectedProducts.isEmpty {
                    Section(header: Text(LocalizedStringKey("selected_products_section"))) {
                        ForEach(selectedProducts) { product in
                            ProductRow(product: product, isSelected: true) {
                                selectedProducts.removeAll { $0.id == product.id }
                            }
                        }
                    }
                }
                
                ForEach(products) { product in
                    ProductRow(product: product, isSelected: selectedProducts.contains(where: { $0.id == product.id })) {
                        if selectedProducts.contains(where: { $0.id == product.id }) {
                            selectedProducts.removeAll { $0.id == product.id }
                        } else {
                            selectedProducts.append(product)
                        }
                    }
                }
                
            }
            
            Button("save_changes_label".localized) {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(Color("ButtonTextColor"))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("ButtonColor"))
            .cornerRadius(10)
            .padding(.horizontal)
        }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text(category)
                            .font(.system(size: 20))
                            .fontWeight(.medium)
                            .foregroundColor(Color("TextColor"))
                            .minimumScaleFactor(0.5) // Уменьшает шрифт до 50% от исходного размера
                            .lineLimit(2)
                    }
                }
                .navigationBarBackButtonHidden(true) // Убираем кнопку "Назад"
            }
    }

