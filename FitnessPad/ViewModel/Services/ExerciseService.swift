//
//  ExerciseService.swift
//  FitnessPad
//
//  Created by Марк Кулик on 03.02.2025.
//

import SwiftUI
import CoreData

class ExerciseService: ObservableObject {
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
    
    // MARK: - Load Default Exercises
    func loadDefaultExercises() -> [DefaultExercise] {
        let request: NSFetchRequest<DefaultExercise> = DefaultExercise.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch default exercises: \(error.localizedDescription)")
            return []
        }
    }
   
    // MARK: - Group Exercises by Category
    func groupDefaultExercisesByCategory(_ exercises: [DefaultExercise]) -> [(category: String, exercises: [DefaultExercise])] {
        let filteredExercises = exercises.filter { $0.categories != nil }
        let grouped = Dictionary(grouping: filteredExercises) { $0.categories?.name ?? "Uncategorized" }
        let sortedKeys = grouped.keys.sorted()
        return sortedKeys.map { key in
            (category: key, exercises: grouped[key] ?? [])
        }
    }

    func toggleFavourite(for exercise: DefaultExercise) {
        exercise.isFavourite.toggle()
        saveContext()
    }

   
    // MARK: - Exercises Core Data Management
    func addExerciseToCoreData(name: String, exerciseDescription: String, category: ExerciseCategory?, image: UIImage?, video: Data?, attributes: Set<String>, isDefault: Bool = false) {
        let newExercise = DefaultExercise(context: context)
        newExercise.id = UUID()
        newExercise.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        newExercise.exerciseDescription = exerciseDescription
        newExercise.categories = category
        newExercise.image = image?.jpegData(compressionQuality: 0.5)
        newExercise.video = video
        newExercise.isDefault = isDefault
        
        for attribute in attributes {
            let newAttribute = ExerciseAttribute(context: context)
            newAttribute.name = attribute
            newAttribute.isAdded = true
            newExercise.addToAttributes(newAttribute)
        }
        saveContext()
    }
    
    func updateExerciseInCoreData(_ exercise: DefaultExercise, name: String, exerciseDescription: String, category: ExerciseCategory?, image: UIImage?,  video: Data?, attributes: Set<String>) {
        exercise.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        exercise.exerciseDescription = exerciseDescription
        exercise.categories = category
        exercise.image = image?.jpegData(compressionQuality: 1.0)
        // Обновляем видео
        exercise.video = video
        
        let currentAttributes = exercise.attributes?.allObjects as? [ExerciseAttribute] ?? []
        for attribute in currentAttributes {
            if !attributes.contains(attribute.name ?? "") {
                context.delete(attribute)
            }
        }
        
        for attribute in attributes {
            if !currentAttributes.contains(where: { $0.name == attribute }) {
                let newAttribute = ExerciseAttribute(context: context)
                newAttribute.name = attribute
                newAttribute.isAdded = true
                exercise.addToAttributes(newAttribute)
            }
        }
        saveContext()
        // Отладочное сообщение
            if video != nil {
                print("Video data saved successfully.")
            } else {
                print("No video data to save.")
            }
    }
    
    func deleteExerciseFromCoreData(_ exercise: DefaultExercise, workoutDaysCache: [Date: WorkoutDay]) {
        guard let exerciseId = exercise.id else {
            print("Exercise ID is nil")
            return
        }
        
        // Удаление упражнения из связанных объектов
        workoutDaysCache.forEach { (_, workoutDay) in
            if let exercisesSet = workoutDay.exercises as? Set<Exercise> {
                let filteredExercises = exercisesSet.filter { $0.id != exerciseId }
                workoutDay.exercises = NSSet(set: filteredExercises)
            }
        }
        
        // Удаление самого упражнения
        context.delete(exercise)
        saveContext()
    }

}
