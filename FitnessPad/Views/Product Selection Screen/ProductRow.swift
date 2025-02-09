//
//  ProductRow.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

//import SwiftUI
//
//struct ProductRow: View {
//    let product: Product
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 5) {
//                Text(product.name)
//                    .font(.system(size: 16))
//                    .foregroundStyle(Color("TextColor"))
//                
//                HStack {
//                    Text(String(format: NSLocalizedString("proteins_label", comment: ""), product.proteins))
//                    Text(String(format: NSLocalizedString("fats_label", comment: ""), product.fats))
//                    Text(String(format: NSLocalizedString("carbs_label", comment: ""), product.carbohydrates))
//                    Text(String(format: NSLocalizedString("calories_label", comment: ""), product.calories))
//                }
//                .font(.system(size: 14))
//                .foregroundColor(.gray)
//            }
//            Spacer()
//            if isSelected {
//                Image(systemName: "checkmark")
//            }
//        }
//        .contentShape(Rectangle())
//        .onTapGesture(perform: action)
//    }
//}


import SwiftUI

import SwiftUI

struct ProductRow: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    let product: ProductItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isShowingEditView = false // Состояние для отображения ProductFormView
    
    var body: some View {
        HStack {
            // Основная кнопка для выбора продукта
            Button(action: action) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(product.name)
                            .font(.system(size: 16))
                            .foregroundStyle(Color("TextColor"))
                        
                        HStack {
                            Text(String(format: NSLocalizedString("proteins_label", comment: ""), product.proteins))
                            Text(String(format: NSLocalizedString("fats_label", comment: ""), product.fats))
                            Text(String(format: NSLocalizedString("carbs_label", comment: ""), product.carbohydrates))
                            Text(String(format: NSLocalizedString("calories_label", comment: ""), product.calories))
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    }
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle()) // Для корректного распознавания нажатий
            }
            .buttonStyle(PlainButtonStyle()) // Применяем стиль кнопки здесь
            
            // Кнопка избранного
            Button(action: {
                if productViewModel.favoriteProducts.contains(where: { $0.id == product.id }) {
                    productViewModel.removeFromFavorites(product)
                } else {
                    productViewModel.addToFavorites(product)
                }
            }) {
                Image(systemName: productViewModel.favoriteProducts.contains(where: { $0.id == product.id }) ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Кнопка редактирования (только для пользовательских продуктов)
            if let customProduct = productViewModel.customProducts.first(where: { $0.name == product.name }) {
                Button(action: {
                    isShowingEditView = true // Показываем модальное окно редактирования
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $isShowingEditView) {
                    let defaultCategoryName = CustomCategory(context: PersistenceController.shared.container.viewContext)
                    ProductFormView(productViewModel: productViewModel, category: customProduct.category ?? defaultCategoryName)
                }
            }
        }
    }
}
