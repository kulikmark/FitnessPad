//
//  CategoryGridView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

struct CategoryGridView: View {
    @Binding var selectedProducts: [Product]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategories: Set<String> = []
    @State private var isShowingCategoryFilter = false
    @State private var selectedTab: String = ""
    
    var categories: [Category] {
        let uniqueCategories = Set(productsByCategory.flatMap { $0.value.map { $0.category } })
        return Array(uniqueCategories).sorted { $0.name < $1.name }
    }
    
    // Определяем сетку для LazyVGrid
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                categoryGridViewTitle
                
                //Выбрано: \(количество) продуктов
                if !selectedProducts.isEmpty {
                    HStack {
                        Text("Выбрано \(selectedProducts.count) позиций".localized)
                            .font(.system(size: 18))
                            .foregroundColor(Color("TextColor"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("save_button".localized)
                                .font(.system(size: 12))
                                .foregroundColor(Color("ButtonTextColor"))
                                .padding(8)
                                .background(Color("ButtonColor"))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                // Сетка категорий
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(categories, id: \.name) { category in
                        NavigationLink(destination: ProductListView(category: category.name, selectedProducts: $selectedProducts)) {
                            CategoryTile(category: category)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    }
                
                .padding()
            }
            .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        }
    }
    
    // MARK: - Header
    var categoryGridViewTitle: some View {
        HStack {
        Text("category_grid_title".localized)
            .font(.system(size: 24))
            .fontWeight(.medium)
            .foregroundColor(Color("TextColor"))
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            CloseButtonCircle()
    }
        .padding(.horizontal)
    }
}
