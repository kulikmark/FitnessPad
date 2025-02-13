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
    
    @State private var isGramInputPresented: Bool = false
    @State private var selectedProductForEditing: SelectedProductModel? = nil
    
    @State private var isSelectedProductsExpanded: Bool = false
    
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
                    categoryGridViewHeader
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
                    if !selectedProducts.isEmpty && isFromFoodDayView {
                     
                        HStack {
                            HStack {
                            Text("Выбрано \(selectedProducts.count) позиций".localized)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color("TextColor"))
                                
                            
                            // Кнопка с стрелочкой
                            Button(action: {
                                isSelectedProductsExpanded.toggle()
                            }) {
                                Image(systemName: isSelectedProductsExpanded ? "chevron.down" : "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.gray)
                                    .padding(8)
                                    .background(Circle().fill(Color.gray.opacity(0.2)))
                            }
                        }
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
                        .padding()
                        
                        if isSelectedProductsExpanded {
                           
                                SelectedProductsSection(
                                    selectedProducts: $selectedProducts,
                                    selectedProductForEditing: $selectedProductForEditing,
                                    isGramInputPresented: $isGramInputPresented
                                )
                            
                         
                        }
                    }
                    
                    ScrollView {
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
    
    var categoryGridViewHeader: some View {
        HStack {
            if isFromFoodDayView {
                CustomBackButtonView()
            }
            
            Text("category_grid_title".localized)
                .font(.system(size: 24))
                .fontWeight(.medium)
                .foregroundColor(Color("TextColor"))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                
               
            
            Spacer()
            
            HStack(spacing: 15) {
                // Кнопка "Избранные продукты"
                NavigationLink(destination: FavoritesView(
                    selectedProducts: $selectedProducts,
                    isFromFoodDayView: isFromFoodDayView
                )) {
                    HStack(spacing: 3) {
                        Text("Любимые продукты")
                            .font(.system(size: 10))
                            .foregroundColor(Color("TextColor"))
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)

                        Image(systemName: "heart")
                            .font(.system(size: 17))
                            .foregroundColor(Color("TextColor"))
                    }
                }

                // Кнопка "Добавить категорию"
                NavigationLink(destination: CategoryFormView(
                    productViewModel: productViewModel
                )) {
                    HStack(spacing: 3) {
                        Text("Добавить категорию")
                            .font(.system(size: 10))
                            .foregroundColor(Color("TextColor"))
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 17))
                            .foregroundColor(Color("TextColor"))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.top)
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
        
        // Создаем мок-категории
        let fruitCategory = Category(name: "Фрукты", categoryImage: "fruit")
        let meatCategory = Category(name: "Мясо", categoryImage: "meat")
        
        // Создаем мок-продукты
        let apple = Product(
            id: UUID(), // Уникальный идентификатор
            name: "Яблоко",
            category: fruitCategory, // Передаем объект Category
            proteins: 0.3,
            fats: 0.2,
            carbohydrates: 14,
            calories: 52
        )
        
        let chickenBreast = Product(
            id: UUID(), // Уникальный идентификатор
            name: "Куриная грудка",
            category: meatCategory, // Передаем объект Category
            proteins: 31,
            fats: 3.6,
            carbohydrates: 0,
            calories: 165
        )
        
        // Создаем массив выбранных продуктов
        let selectedProducts: [SelectedProductModel] = [
            SelectedProductModel(product: apple),
            SelectedProductModel(product: chickenBreast)
        ]
        
        // Возвращаем CategoryGridView с мок-данными
        CategoryGridView(
            selectedProducts: .constant(selectedProducts), // Передаем массив выбранных продуктов
            selectedCategory: .constant(nil), // Никакая категория не выбрана
            isSelectingCategory: false,
            isFromFoodDayView: true
        )
        .environmentObject(mockProductViewModel)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
