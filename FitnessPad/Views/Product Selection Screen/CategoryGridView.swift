//
//  CategoryGridView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI
// CategoryGridView.swift

struct CategoryGridView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    @Binding var selectedProducts: [SelectedProductModel]
    @Binding var selectedCategory: String?
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategories: Set<String> = []
    @State private var isShowingCategoryFilter = false
    @State private var selectedTab: String = ""
    
    @State private var showDeleteAlert = false
    @State private var categoryToDelete: CustomCategory?
    
    @State private var searchText: String = ""
    let searchCategory = Category(name: "Поиск", categoryImage: "search")
    
    var isSelectingCategory: Bool
    
    let isFromFoodDayView: Bool
    
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
                if searchText.isEmpty {
                    categoryGridViewTitle
                }
                
                ProductSelectionViewSearchBar(text: $searchText)
                
                if !searchText.isEmpty {
                    ProductListView(
                        category: Category(
                            name: "Поиск",
                            categoryImage: "search"),
                        selectedProducts: $selectedProducts,
                        productViewModel: productViewModel,
                        isFromSearch: true,
                        searchText: $searchText,
                        isFromFoodDayView: isFromFoodDayView
                    )
                } else {
                    ScrollView {
                       
                        
                        if !selectedProducts.isEmpty && isFromFoodDayView {
                            selectedProductsSection
                        }
                        
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
    
//    var categoryGridViewTitle: some View {
//        HStack {
//            Text("category_grid_title".localized)
//                .font(.system(size: 24))
//                .fontWeight(.medium)
//                .foregroundColor(Color("TextColor"))
//                .frame(maxWidth: .infinity, alignment: .leading)
//            
//            Spacer()
//            HStack(spacing: 20) {
//                NavigationLink(
//                    destination: FavoritesView(
//                        selectedProducts: $selectedProducts, // Передаем выбранные продукты
//                        isFromFoodDayView: isFromFoodDayView // Передаем флаг isFromFoodDayView
//                    )
//                ) {
//                    Image(systemName: "heart")
//                }
//                NavigationLink(destination: CategoryFormView(productViewModel: productViewModel)) {
//                    Image(systemName: "plus")
//                }
//            }
//        }
//        .padding(.horizontal)
//    }
    var categoryGridViewTitle: some View {
        HStack {
            Text("category_grid_title".localized)
                .font(.system(size: 24))
                .fontWeight(.medium)
                .foregroundColor(Color("TextColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack(spacing: 15) {
                // Кнопка "Избранные продукты"
                NavigationLink(destination: FavoritesView(
                    selectedProducts: $selectedProducts,
                    isFromFoodDayView: isFromFoodDayView
                )) {
                    Text("Избранные\nпродукты")
                        .font(.system(size: 8)) // Размер текста 8
                        .foregroundColor(Color("TextColor"))
                        .multilineTextAlignment(.center)
                    
                        Image(systemName: "heart")
                            .font(.system(size: 17)) // Размер иконки 17
                            .foregroundColor(Color("TextColor")) 
                }

                // Кнопка "Добавить категорию"
                NavigationLink(destination: CategoryFormView(
                    productViewModel: productViewModel
                )) {
                    Text("Добавить\nкатегорию")
                        .font(.system(size: 8)) // Размер текста 8
                        .foregroundColor(Color("TextColor"))
                        .multilineTextAlignment(.center)
                    
                        Image(systemName: "plus")
                            .font(.system(size: 17)) // Размер иконки 17
                            .foregroundColor(Color("TextColor"))
                }
            }
        }
        .padding(.horizontal)
    }
    
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
    
    var categoriesGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(categories, id: \.name) { category in
                let isCustom = productViewModel.customCategories.contains { $0.name == category.name }
                NavigationLink(destination:
                                ProductListView(
                    category: category,
                    selectedProducts: $selectedProducts,
                    productViewModel: productViewModel,
                    searchText: $searchText,
                    isFromFoodDayView: isFromFoodDayView
                                )
                ) {
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
            isSelectingCategory: false,
            isFromFoodDayView: true // Пример значения
        )
        .environmentObject(mockProductViewModel)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
