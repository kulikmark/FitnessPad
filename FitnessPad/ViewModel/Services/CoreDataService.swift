//
//  CoreDataService.swift
//  FitnessPad
//
//  Created by Марк Кулик on 04.02.2025.
//

import Foundation
import CoreData

class CoreDataService: ObservableObject {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Save Context
    func saveContext() {
        do {
            try context.save()
            print("Context saved successfully.")
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
