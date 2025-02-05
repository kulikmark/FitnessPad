//
//  BodyWeightService.swift
//  FitnessPad
//
//  Created by Марк Кулик on 03.02.2025.
//

import Foundation
import CoreData


class BodyWeightService {
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

    // MARK: - Save Body Weight
    func saveBodyWeight(for date: Date, weight: Double) {
        let bodyWeight = BodyWeight(context: context)
        bodyWeight.date = date
        bodyWeight.weight = weight

        saveContext()
    }
    
    // MARK: - Update Body Weight
      func updateBodyWeight(for date: Date, newWeight: Double) {
          if let bodyWeight = fetchBodyWeight(for: date) {
              bodyWeight.weight = newWeight
          } else {
              saveBodyWeight(for: date, weight: newWeight)
          }
          saveContext()
      }

    // MARK: - Fetch Body Weight
    func fetchBodyWeight(for date: Date) -> BodyWeight? {
        let request: NSFetchRequest<BodyWeight> = BodyWeight.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        do {
            return try context.fetch(request).first
        } catch {
            print("Failed to fetch body weight: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Fetch All Body Weights
    func fetchBodyWeights() -> [BodyWeight] {
        let request: NSFetchRequest<BodyWeight> = BodyWeight.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \BodyWeight.date, ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch body weights: \(error.localizedDescription)")
            return []
        }
    }
}
