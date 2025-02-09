//
//  ProductListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

struct ProductListView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    let category: Category // Используем Category вместо String
    @Binding var selectedProducts: [ProductItem]
    
    @ObservedObject var productViewModel: ProductViewModel
    
    @State private var isShowingProductForm = false
    
    // Добавляем параметр searchText
    var searchText: String = ""
    
    var body: some View {
        VStack {
            List {
                selectedProductsSection
                productsSection
                customProductsSection
            }
            
            addProductButton
            saveButton
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text(category.name) // Используем category.name
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextColor"))
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Секция с выбранными продуктами
    private var selectedProductsSection: some View {
        Group {
            if !selectedProducts.isEmpty {
                Section(header: Text(LocalizedStringKey("selected_products_section"))) {
                    ForEach(selectedProducts) { product in
                        ProductRow(product: product, isSelected: true) {
                            selectedProducts.removeAll { $0.id == product.id }
                        }
                    }
                }
            }
        }
    }
    
    // Секция с предустановленными продуктами
    private var productsSection: some View {
        Section {
            ForEach(filteredProducts) { product in
                ProductRow(product: product, isSelected: selectedProducts.contains { $0.id == product.id }) {
                    toggleProductSelection(product)
                }
            }
        }
    }
    
    // Секция с пользовательскими продуктами
    private var customProductsSection: some View {
        Section {
            ForEach(productViewModel.customProducts.filter { $0.category?.name == category.name }, id: \.id) { customProduct in
                let product = ProductItem(
                    name: customProduct.name ?? "",
                    category: Category(name: customProduct.category?.name ?? "", categoryImage: ""),
                    proteins: customProduct.proteins,
                    fats: customProduct.fats,
                    carbohydrates: customProduct.carbohydrates,
                    calories: customProduct.calories
                )
                ProductRow(product: product, isSelected: selectedProducts.contains { $0.name == customProduct.name }) {
                    toggleCustomProductSelection(customProduct)
                }
            }
        }
    }
    
    // Кнопка "+" для добавления продукта
    private var addProductButton: some View {
        Group {
            if let customCategory = productViewModel.customCategories.first(where: { $0.name == category.name }) {
                Button(action: {
                    isShowingProductForm = true
                }) {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .sheet(isPresented: $isShowingProductForm) {
                    ProductFormView(productViewModel: productViewModel, category: customCategory)
                }
            }
        }
    }
    
    // Кнопка сохранения
    private var saveButton: some View {
        Button("save_changes_label".localized) {
            dismiss() // Используем dismiss из Environment
        }
        .foregroundColor(Color("ButtonTextColor"))
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color("ButtonColor"))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    // Отфильтрованные продукты
    private var filteredProducts: [ProductItem] {
        if category.name == "Поиск" {
            // Если это категория "Поиск", фильтруем все продукты
            let allProducts = Array(productsByCategory.values.flatMap { $0 })
            return allProducts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        } else {
            // Иначе фильтруем продукты по выбранной категории
            let allProducts = productsByCategory[category] ?? []
            if searchText.isEmpty {
                return allProducts
            } else {
                return allProducts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    // Переключение выбора продукта
    private func toggleProductSelection(_ product: ProductItem) {
        if selectedProducts.contains(where: { $0.id == product.id }) {
            selectedProducts.removeAll { $0.id == product.id }
        } else {
            selectedProducts.append(product)
        }
    }
    
    // Переключение выбора пользовательского продукта
    private func toggleCustomProductSelection(_ customProduct: CustomProduct) {
        let product = ProductItem(
            name: customProduct.name ?? "",
            category: Category(name: customProduct.category?.name ?? "", categoryImage: ""),
            proteins: customProduct.proteins,
            fats: customProduct.fats,
            carbohydrates: customProduct.carbohydrates,
            calories: customProduct.calories
        )
        if selectedProducts.contains(where: { $0.name == customProduct.name }) {
            selectedProducts.removeAll { $0.name == customProduct.name }
        } else {
            selectedProducts.append(product)
        }
    }
}
