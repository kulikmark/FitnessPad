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
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var selectedCategories: Set<String> = []
    @State private var isShowingCategoryFilter = false
    @State private var selectedTab: String = "" // Для отслеживания выбранной категории

    var categories: [String] {
        // Получаем уникальные категории
        let allCategories = productsByCategory.flatMap { $0.value.map { $0.category } }
        return Array(Set(allCategories)).sorted()
    }

    var filteredProductsByCategory: [String: [Product]] {
        var filtered = productsByCategory

        // Если поле поиска не пустое, игнорируем выбранную категорию и ищем по всем продуктам
        if !searchText.isEmpty {
            filtered = productsByCategory.mapValues { products in
                products.filter { product in
                    product.name.localizedCaseInsensitiveContains(searchText)
                }
            }.filter { !$0.value.isEmpty }
        } else {
            // Если поле поиска пустое, применяем фильтрацию по выбранной категории
            if !selectedCategories.isEmpty {
                filtered = filtered.filter { selectedCategories.contains($0.key) }
            }

            // Если выбрана конкретная категория, фильтруем по ней
            if !selectedTab.isEmpty {
                filtered = filtered.filter { $0.key == selectedTab }
            }
        }

        return filtered
    }

    var body: some View {
            VStack {
                // Поле поиска
                    SearchBar(text: $searchText)
                        .padding(.horizontal)


                // Горизонтальный скролл с категориями
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // Кнопка "All" для отображения всех продуктов
                        Button(action: {
                            selectedTab = ""
                        }) {
                            Text("All")
                                .font(.system(size: 14))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selectedTab.isEmpty ? Color("ButtonColor") : Color.gray.opacity(0.2))
                                .foregroundColor(selectedTab.isEmpty ? Color("ButtonTextColor") : .primary)
                                .cornerRadius(20)
                        }

                        // Кнопки для каждой категории
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedTab = category
                            }) {
                                Text(category)
                                    .font(.system(size: 14))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(selectedTab == category ? Color("ButtonColor") : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedTab == category ? Color("ButtonTextColor") : .primary)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Список продуктов
                List {
                    // Раздел для выбранных продуктов
                    if !selectedProducts.isEmpty {
                        Section(header: Text("Selected Products")) {
                            ForEach(selectedProducts) { product in
                                ProductRow(product: product, isSelected: true) {
                                    selectedProducts.removeAll { $0.id == product.id }
                                }
                            }
                        }
                    }

                    // Раздел для продуктов по категориям
                    ForEach(filteredProductsByCategory.keys.sorted(), id: \.self) { category in
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
        
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search Products", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.trailing, 10)
                .padding(.bottom, 5)
            CloseButtonCircle()
                .padding(.bottom, 5)
        }
    }
}

struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }
}

struct ProductRow: View {
    let product: Product
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.system(size: 16))
                    .foregroundStyle(Color("TextColor"))
                
                HStack {
                    Text("P: \(product.proteins, specifier: "%.1f") g")
                    Text("F: \(product.fats, specifier: "%.1f") g")
                    Text("C: \(product.carbohydrates, specifier: "%.1f") g")
                    Text("\(product.calories, specifier: "%.0f") kcal")
                }
                .font(.system(size: 14))
                .foregroundColor(.gray)
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
//        .padding()
    }
}

