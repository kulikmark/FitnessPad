//
//  FavoritesView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 06.02.2025.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @Binding var selectedProducts: [SelectedProductModel] // Для хранения выбранных продуктов
    let isFromFoodDayView: Bool // Определяет, открыт ли экран для выбора продуктов

    var body: some View {
        VStack {
            // Добавляем кнопку "Назад"
            HStack {
                CustomBackButtonView()
                
                Text("favorites_view_title".localized)
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal)
        .padding(.top)
        
        List {
            ForEach(productViewModel.favoriteProducts) { product in
                ProductRow(
                    product: product,
                    isSelected: selectedProducts.contains { $0.product.id == product.id }, // Проверяем, выбран ли продукт
                    action: {
                        if isFromFoodDayView {
                            toggleProductSelection(product) // Добавляем или удаляем продукт
                        }
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            productViewModel.fetchFavoriteProducts() // Загружаем избранные при появлении
        }
    }

    // Функция для добавления/удаления продукта в выбранные
    private func toggleProductSelection(_ product: Product) {
        if selectedProducts.contains(where: { $0.product.id == product.id }) {
            selectedProducts.removeAll { $0.product.id == product.id } // Удаляем продукт
        } else {
            selectedProducts.append(SelectedProductModel(product: product, quantity: 100)) // Добавляем продукт с количеством по умолчанию
        }
    }
}
