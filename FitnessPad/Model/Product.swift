//
//  Product.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.02.2025.
//

import Foundation

struct Product: Identifiable, Equatable {
    let id: UUID
    let name: String
    let category: Category
    let proteins: Double
    let fats: Double
    let carbohydrates: Double
    let calories: Double
    
    // Инициализатор для создания Product из FavoriteProduct
        init(id: UUID, name: String, category: Category, proteins: Double, fats: Double, carbohydrates: Double, calories: Double) {
            self.id = id
            self.name = name
            self.category = category
            self.proteins = proteins
            self.fats = fats
            self.carbohydrates = carbohydrates
            self.calories = calories
        }
    
    // Инициализатор для ProductItem
    init(from productItem: ProductItem) {
        self.id = productItem.id
        self.name = productItem.name
        self.category = productItem.category
        self.proteins = productItem.proteins
        self.fats = productItem.fats
        self.carbohydrates = productItem.carbohydrates
        self.calories = productItem.calories
    }
    
    // Инициализатор для CustomProduct
    init(from customProduct: CustomProduct) {
        self.id = customProduct.id ?? UUID()
        self.name = customProduct.name ?? ""
        self.category = Category(name: customProduct.category?.name ?? "", categoryImage: "")
        self.proteins = customProduct.proteins
        self.fats = customProduct.fats
        self.carbohydrates = customProduct.carbohydrates
        self.calories = customProduct.calories
    }
}
