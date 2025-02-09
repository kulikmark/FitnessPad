//
//  CategoryTile.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

struct CategoryTile: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    let category: Category
    var isCustom: Bool
    var onDelete: (() -> Void)?
    
    var minHeight: CGFloat = 130
    var maxHeight: CGFloat = 130
    
    @State private var isShowingEditView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) { // Выравнивание текста по левому краю и отступ между элементами
            // Контейнер для изображения
            Group {
                if isCustom, let customCategory = productViewModel.customCategories.first(where: { $0.name == category.name }) {
                    if let imageData = customCategory.categoryImage,
                       let uiImage = UIImage(data: imageData) {
                        // Пользовательское изображение
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 150, maxWidth: 200, minHeight: minHeight, maxHeight: maxHeight) // Увеличиваем высоту изображения
                            .clipped()
                            .cornerRadius(12)
                    } else {
                        // Изображение-заглушка для статических категорий без изображения
                        Image("products")
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 150, maxWidth: 200, minHeight: minHeight, maxHeight: maxHeight)
                            .clipped()
                            .cornerRadius(12)
                    }
                } else {
                    // Для статических категорий
                    if !category.categoryImage.isEmpty {
                        Image(category.categoryImage)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 150, maxWidth: 200, minHeight: minHeight, maxHeight: maxHeight)
                            .cornerRadius(12)
                            .clipped()
                    }
                }
            }
            
            Spacer()
            
            // Контейнер для текста с фиксированной высотой
                  VStack(alignment: .leading, spacing: 0) {
                      Text(category.name.localized)
                          .font(.system(size: 16, weight: .medium))
                          .foregroundColor(Color("TextColor"))
                          .multilineTextAlignment(.leading)
                          .lineLimit(nil)
                          .fixedSize(horizontal: false, vertical: true)
                          .alignmentGuide(.firstTextBaseline) { dimension in
                              dimension[.top] // Выравниваем по базовой линии
                          }
                  }
                  .frame(height: 30) // Фиксированная высота для текстового контейнера
                  .padding(.horizontal, 10)
                  .padding(.bottom, 10)
              }
        .frame(minWidth: 150, maxWidth: 200, minHeight: 150, maxHeight: 200)
        .background(Color("ViewColor"))
        .cornerRadius(12)
        .contextMenu {
            if isCustom {
                Button(action: {
                    isShowingEditView = true
                }) {
                    Label("Редактировать", systemImage: "pencil")
                }
                
                Button(role: .destructive, action: {
                    onDelete?()
                }) {
                    Label("Удалить", systemImage: "trash")
                }
            }
        }
        .sheet(isPresented: $isShowingEditView) {
            if let customCategory = productViewModel.customCategories.first(where: { $0.name == category.name }) {
                CategoryFormView(
                    productViewModel: productViewModel,
                    categoryToEdit: customCategory
                )
            }
        }
    }
}
