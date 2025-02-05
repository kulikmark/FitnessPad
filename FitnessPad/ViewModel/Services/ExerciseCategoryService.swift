//
//  ExerciseCategoryService.swift
//  FitnessPad
//
//  Created by Марк Кулик on 03.02.2025.
//

import Foundation
import CoreData

class ExerciseCategoryService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Load Categories
    func loadCategories() -> [ExerciseCategory] {
        let request: NSFetchRequest<ExerciseCategory> = ExerciseCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch categories: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Add New Category
    func addNewCategory(_ category: String) {
        let newCategory = ExerciseCategory(context: context)
        newCategory.name = category
        newCategory.isDefault = false

        do {
            try context.save()
            print("Category \(category) added successfully.")
        } catch {
            print("Failed to save category: \(error.localizedDescription)")
        }
    }

    // MARK: - Delete Category
    func deleteCategory(_ category: ExerciseCategory) {
        context.delete(category)
        do {
            try context.save()
            print("Category deleted successfully.")
        } catch {
            print("Failed to delete category: \(error.localizedDescription)")
        }
    }
}
