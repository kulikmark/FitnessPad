//
//  ProductViewModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 06.02.2025.
//

import Foundation
import CoreData

class ProductViewModel: ObservableObject {
    @Published var customCategories: [CustomCategory] = []
    @Published var customProducts: [CustomProduct] = []
    @Published var favoriteProducts: [Product] = []
    
    private let productService: ProductService
    
    init(
        productService: ProductService
       
    ) {
        self.productService = productService
        fetchCustomCategories()
        fetchCustomProducts()
        fetchFavoriteProducts()
    }
    
    // Загрузка пользовательских категорий
    func fetchCustomCategories() {
        customCategories = productService.fetchCustomCategories()
    }
    
    // Добавление новой категории
    func addCustomCategory(name: String, image: Data?) {
        productService.addCustomCategory(name: name, image: image)
        fetchCustomCategories() // Обновляем список категорий
    }
    
    func updateCustomCategory(_ category: CustomCategory, name: String, image: Data?) {
            productService.updateCustomCategory(category, name: name, image: image)
            fetchCustomCategories() // Обновляем список категорий
        }
    
    // Удаление категории
    func deleteCustomCategory(_ category: CustomCategory) {
        productService.deleteCustomCategory(category)
        fetchCustomCategories() // Обновляем список категорий
    }
    
    // Загрузка пользовательских продуктов
    func fetchCustomProducts() {
        customProducts = productService.fetchCustomProducts()
    }
    
    func addProduct(name: String, category: CustomCategory, proteins: Double, fats: Double, carbohydrates: Double, calories: Double) {
        productService.addCustomProduct(
            name: name,
            category: category,
            proteins: proteins,
            fats: fats,
            carbohydrates: carbohydrates,
            calories: calories
        )
        fetchCustomProducts()
    }

    func updateProduct(_ product: CustomProduct, name: String, category: CustomCategory, proteins: Double, fats: Double, carbohydrates: Double, calories: Double) {
        productService.updateCustomProduct(
            product,
            name: name,
            category: category,
            proteins: proteins,
            fats: fats,
            carbohydrates: carbohydrates,
            calories: calories
        )
        fetchCustomProducts()
    }
    
    // Удаление продукта
    func deleteCustomProduct(_ product: CustomProduct) {
        productService.deleteCustomProduct(product)
        fetchCustomProducts() // Обновляем список продуктов
    }
    
    // В ProductViewModel
    func addToFavorites(_ product: Product) {
        productService.addFavoriteProduct(product)
        fetchFavoriteProducts() // Обновляем список избранных
    }

    func removeFromFavorites(_ product: Product) {
        productService.removeFavoriteProduct(product)
        fetchFavoriteProducts() // Обновляем список избранных
    }

    func fetchFavoriteProducts() {
        let favoriteProductsFromCoreData = productService.fetchFavoriteProducts()
        favoriteProducts = favoriteProductsFromCoreData.map { favoriteProduct in
            Product(
                id: favoriteProduct.id ?? UUID(),
                name: favoriteProduct.name ?? "",
                category: Category(name: "", categoryImage: ""), // Укажите категорию, если нужно
                proteins: favoriteProduct.proteins,
                fats: favoriteProduct.fats,
                carbohydrates: favoriteProduct.carbohydrates,
                calories: favoriteProduct.calories
            )
        }
    }

}
