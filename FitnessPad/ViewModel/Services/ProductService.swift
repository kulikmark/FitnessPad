//
//  ProductService.swift
//  FitnessPad
//
//  Created by Марк Кулик on 06.02.2025.
//

import CoreData
import Foundation

class ProductService: ObservableObject {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchCustomCategories() -> [CustomCategory] {
        let request: NSFetchRequest<CustomCategory> = CustomCategory.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching custom categories: \(error)")
            return []
        }
    }
    
    func addCustomCategory(name: String, image: Data?) {
        let newCategory = CustomCategory(context: context)
        newCategory.id = UUID()
        newCategory.name = name
        newCategory.categoryImage = image
        saveContext()
    }
    
    func updateCustomCategory(_ category: CustomCategory, name: String, image: Data?) {
           category.name = name
           category.categoryImage = image
           saveContext()
       }
    
//    func deleteCustomCategory(_ category: CustomCategory) {
//        context.delete(category)
//        saveContext()
//    }
    
    func deleteCustomCategory(_ category: CustomCategory) {
        // Шаг 1: Находим все продукты, связанные с этой категорией
        let productsInCategory = fetchCustomProducts().filter { $0.category?.id == category.id }
        
        // Шаг 2: Удаляем эти продукты из избранного
        for product in productsInCategory {
            removeFavoriteProduct(Product(from: product))
        }
        
        // Шаг 3: Удаляем саму категорию
        context.delete(category)
        saveContext()
    }
    
    // Получение всех пользовательских продуктов
//    func fetchCustomProducts() -> [CustomProduct] {
//        let request: NSFetchRequest<CustomProduct> = CustomProduct.fetchRequest()
//        
//        do {
//            return try context.fetch(request)
//        } catch {
//            print("Error fetching custom products: \(error)")
//            return []
//        }
//    }
    
    func fetchCustomProducts(for category: CustomCategory? = nil) -> [CustomProduct] {
        let request: NSFetchRequest<CustomProduct> = CustomProduct.fetchRequest()
        
        if let category = category {
            request.predicate = NSPredicate(format: "category == %@", category)
        }
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching custom products: \(error)")
            return []
        }
    }
    
    // Добавление нового продукта
    func addCustomProduct(name: String, category: CustomCategory, proteins: Double, fats: Double, carbohydrates: Double, calories: Double) {
        let newProduct = CustomProduct(context: context)
        newProduct.id = UUID()
        newProduct.name = name
        newProduct.category = category
        newProduct.proteins = proteins
        newProduct.fats = fats
        newProduct.carbohydrates = carbohydrates
        newProduct.calories = calories
        
        saveContext()
    }

    func updateCustomProduct(_ product: CustomProduct, name: String, category: CustomCategory, proteins: Double, fats: Double, carbohydrates: Double, calories: Double) {
        product.name = name
        product.category = category
        product.proteins = proteins
        product.fats = fats
        product.carbohydrates = carbohydrates
        product.calories = calories
        
        saveContext()
    }
    
    // Удаление продукта
    func deleteCustomProduct(_ product: CustomProduct) {
        context.delete(product)
        saveContext()
    }
    
    // В ProductService
    func addFavoriteProduct(_ product: Product) {
        let favoriteProduct = FavoriteProduct(context: context)
        favoriteProduct.id = product.id
        favoriteProduct.name = product.name
        favoriteProduct.proteins = product.proteins
        favoriteProduct.fats = product.fats
        favoriteProduct.carbohydrates = product.carbohydrates
        favoriteProduct.calories = product.calories
        saveContext()
    }

    func removeFavoriteProduct(_ product: Product) {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", product.id as CVarArg)
        
        do {
            let favorites = try context.fetch(request)
            if let favorite = favorites.first {
                context.delete(favorite)
                saveContext()
            }
        } catch {
            print("Error removing favorite product: \(error)")
        }
    }

    func fetchFavoriteProducts() -> [FavoriteProduct] {
        let request: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching favorite products: \(error)")
            return []
        }
    }
    
    // Сохранение изменений в Core Data
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
