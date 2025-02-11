//
//  ProductListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

// ProductListView.swift

struct ProductListView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    let category: Category
    @Binding var selectedProducts: [SelectedProductModel]
    
    @ObservedObject var productViewModel: ProductViewModel
    
    @State private var isShowingProductForm = false
    @State private var isGramInputPresented: Bool = false
    @State private var selectedProductForEditing: SelectedProductModel? = nil
    
    @State private var isShowingEditView = false
    
    var isFromSearch: Bool = false
    @Binding var searchText: String
    
    let isFromFoodDayView: Bool
    
    var productToEdit: CustomProduct?
    
    var body: some View {
        VStack {
            List {
                selectedProductsSection
                productsSection
            }
            
            addProductButton
            saveButton
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text(category.name)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextColor"))
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .sheet(isPresented: $isGramInputPresented) {
            GramInputView(
                selectedProducts: $selectedProducts,
                selectedProductForEditing: $selectedProductForEditing,
                isGramInputPresented: $isGramInputPresented
            )
        }
    }
    
    private var selectedProductsSection: some View {
        Group {
            if !selectedProducts.isEmpty {
                Section(header: Text(LocalizedStringKey("selected_products_section"))) {
                    ForEach($selectedProducts) { $selectedProduct in
                        HStack {
                            Text(selectedProduct.product.name)
                            Spacer()
                            Text(formatGrams(selectedProduct.quantity))
                                .frame(minWidth: 40, maxWidth: 70)
                                .padding(6)
                                .background(.gray)
                                .foregroundColor(Color("ButtonTextColor"))
                                .cornerRadius(8)
                                .onTapGesture {
                                    selectedProductForEditing = selectedProduct
                                    isGramInputPresented = true
                                }
                        }
                    }
                }
            }
        }
    }

    
    private var productsSection: some View {
        Section {
            if category.name == "Избранное" {
                // Отображаем избранные продукты
                ForEach(productViewModel.favoriteProducts) { product in
                    ProductRow(
                        product: product,
                        isSelected: selectedProducts.contains { $0.product.id == product.id },
                        action: {
                            toggleProductSelection(product)
                        }
                    )
                }
            } else {
                // Отображаем обычные продукты
                ForEach(filteredProducts) { product in
                    ProductRow(
                        product: product,
                        isSelected: selectedProducts.contains { $0.product.id == product.id },
                        action: {
                            toggleProductSelection(product)
                        }
                    )
                }
            }
        }
    }
    
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
                    ProductFormView(
                        productViewModel: productViewModel,
                        category: customCategory,
                        productToEdit: productToEdit)
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button("save_changes_label".localized) {
            if isFromSearch {
                searchText = ""
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .foregroundColor(Color("ButtonTextColor"))
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color("ButtonColor"))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var filteredProducts: [Product] {
        if category.name == "Поиск" {
            // Combine all products (both standard and custom) into one array
            let allProducts = productsByCategory.values
                .flatMap { $0.map { Product(from: $0) } } +
                productViewModel.customProducts.map { Product(from: $0) }
            
            // Filter by search text
            return allProducts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        } else {
            // For non-search categories, include both standard and custom products
            let standardProducts = productsByCategory[category]?.map { Product(from: $0) } ?? []
            let customProducts = productViewModel.customProducts
                .filter { $0.category?.name == category.name }
                .map { Product(from: $0) }
            
            let allProducts = standardProducts + customProducts
            
            if searchText.isEmpty {
                return allProducts
            } else {
                return allProducts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    private func toggleProductSelection(_ product: Product) {
        if let index = selectedProducts.firstIndex(where: { $0.product.id == product.id }) {
            selectedProducts.remove(at: index)
        } else {
            if isFromFoodDayView {
                let newSelectedProduct = SelectedProductModel(product: product, quantity: 100)
                selectedProducts.append(newSelectedProduct)
                selectedProductForEditing = newSelectedProduct
                isGramInputPresented = true // Открываем окно ввода граммов
            }
        }
    }

    private func formatGrams(_ grams: Double) -> String {
        if grams >= 1000 {
            let kilograms = grams / 1000
            return String(format: "%.2f kg", kilograms)
        } else {
            return String(format: "%.0f g", grams)
        }
    }
}
