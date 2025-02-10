//
//  CategoryGridView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

struct CategoryGridView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @Binding var selectedProducts: [ProductItem]
    @Binding var selectedCategory: String?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategories: Set<String> = []
    @State private var isShowingCategoryFilter = false
    @State private var selectedTab: String = ""
    
    @State private var showDeleteAlert = false
    @State private var categoryToDelete: CustomCategory?
    
    @State private var searchText: String = ""
    let searchCategory = Category(name: "Поиск", categoryImage: "search")
    
    var isSelectingCategory: Bool
    
    var categories: [Category] {
        let staticCategories = Set(productsByCategory.flatMap { $0.value.map { $0.category } })
        let customCategories = productViewModel.customCategories.map { Category(name: $0.name ?? "", categoryImage: "") }
        return Array((staticCategories) + customCategories).sorted { $0.name < $1.name }
    }
    
    let columns = [
        GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // Если текст поиска не пустой, показываем ProductListView
                if !searchText.isEmpty {
                    ProductListView(
                        category: searchCategory, // Используем временную категорию
                        selectedProducts: $selectedProducts,
                        productViewModel: productViewModel,
                        searchText: searchText // Передаем searchText
                    )
                } else {
                    // Иначе показываем стандартный экран категорий
                    ScrollView {
                        categoryGridViewTitle
                        
                        if !selectedProducts.isEmpty {
                            selectedProductsSection
                        }
                        
                        // Поле поиска
                        ProductSelectionViewSearchBar(text: $searchText)
                        
                        categoriesGrid
                    }
                }
            }
            .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
            .padding(.bottom, 40)
            .alert("Удалить категорию?", isPresented: $showDeleteAlert) {
                Button("Удалить", role: .destructive) {
                    if let category = categoryToDelete {
                        productViewModel.deleteCustomCategory(category)
                    }
                }
                Button("Отмена", role: .cancel) {}
            } message: {
                Text("Вы уверены, что хотите удалить эту категорию?")
            }
        }
    }
    
    // Заголовок экрана
    var categoryGridViewTitle: some View {
        HStack {
            Text("category_grid_title".localized)
                .font(.system(size: 24))
                .fontWeight(.medium)
                .foregroundColor(Color("TextColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            HStack(spacing: 20) {
                NavigationLink(destination: FavoritesView()) {
                    Image(systemName: "heart")
                }
                NavigationLink(destination: CategoryFormView(productViewModel: productViewModel)) {
                    Image(systemName: "plus")
                }
            }
        }
        .padding(.horizontal)
    }
    
    // Секция с выбранными продуктами
    var selectedProductsSection: some View {
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
    var categoriesGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(categories, id: \.name) { category in
                let isCustom = productViewModel.customCategories.contains { $0.name == category.name }
                // Вместо передачи строки передаем Category
                NavigationLink(destination: ProductListView(category: category, selectedProducts: $selectedProducts, productViewModel: productViewModel)) {
                    CategoryTile(category: category, isCustom: isCustom) {
                        if isCustom, let customCategory = productViewModel.customCategories.first(where: { $0.name == category.name }) {
                            categoryToDelete = customCategory
                            showDeleteAlert = true
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct CategoryGridView_Previews: PreviewProvider {
    static var previews: some View {
        // Создаем мок-ProductViewModel
        let productService = ProductService(context: PersistenceController.shared.container.viewContext)
        let mockProductViewModel = ProductViewModel(productService: productService)

        
        // Возвращаем CategoryGridView с мок-данными
        CategoryGridView(
            selectedProducts: .constant([]), // Пустой массив выбранных продуктов
            selectedCategory: .constant(nil), // Никакая категория не выбрана
            isSelectingCategory: false // Пример значения
        )
        .environmentObject(mockProductViewModel)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
