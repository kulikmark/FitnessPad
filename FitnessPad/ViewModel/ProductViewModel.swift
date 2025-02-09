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
    @Published var favoriteProducts: [ProductItem] = []
    
    private let productService: ProductService
    
    init(
        productService: ProductService
       
    ) {
        self.productService = productService
        fetchCustomCategories()
        fetchCustomProducts()
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
    
    // Добавление продукта в избранное
       func addToFavorites(_ product: ProductItem) {
           if !favoriteProducts.contains(where: { $0.id == product.id }) {
               favoriteProducts.append(product)
           }
       }
       
       // Удаление продукта из избранного
       func removeFromFavorites(_ product: ProductItem) {
           favoriteProducts.removeAll { $0.id == product.id }
       }
}
