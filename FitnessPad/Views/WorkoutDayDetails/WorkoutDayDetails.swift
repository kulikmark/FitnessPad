//
//  CreatedTrainingDayView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 28.03.2022.
//

import SwiftUI
import CoreData

// MARK: - Extensions for WorkoutDay and Exercise

extension WorkoutDay {
    // Converts NSSet of exercises to a sorted array
    var exercisesArray: [Exercise] {
        let nsSet = exercises ?? NSSet()
        let exerciseArray = nsSet.allObjects.compactMap { $0 as? Exercise }
        return exerciseArray.sorted { (exercise1: Exercise, exercise2: Exercise) in
            (exercise1.exerciseName ?? "") < (exercise2.exerciseName ?? "")
        }
    }
}

extension Exercise {
    // Converts NSSet of sets to a sorted array
    var setsArray: [ExerciseSet] {
        let nsSet = sets ?? NSSet()
        let setArray = nsSet.allObjects.compactMap { $0 as? ExerciseSet }
        return setArray.sorted { (set1: ExerciseSet, set2: ExerciseSet) in
            set1.weight < set2.weight
        }
    }
}

// MARK: - Enum for Weight Unit

enum WeightUnit: String, CaseIterable, Identifiable {
    case kg = "kg"
    case lbs = "lbs"
    
    var id: String { self.rawValue }
}

// MARK: - Main View: WorkoutDayDetails

struct WorkoutDayDetails: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutViewModel
    
    @Binding var workoutDay: WorkoutDay?
    @Binding var selectedTab: Tab
    
    @State private var isShowingExercisesView = false
    @State private var showingBodyWeightSheet: Bool = false
    @State private var exerciseWeightInput: String = ""
    @State private var exerciseRepsInput: String = ""
    @State private var bodyWeight: String = ""
    @State private var weightInputUnit: WeightUnit = .kg
    @State private var selectedSet: ExerciseSet? = nil
    @State private var selectedExerciseItem: ExerciseItem? = nil
    @State private var tempBodyWeight: String = "" // Temporary variable for body weight input
    @State private var tempWeightUnit: WeightUnit = .kg // Temporary variable for weight unit input
    
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.exerciseName, ascending: true)]
    )
    private var exercises: FetchedResults<Exercise>
    
    @FetchRequest(
        entity: ExerciseSet.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseSet.count, ascending: true)],
        animation: .default
    ) private var exerciseSets: FetchedResults<ExerciseSet>
    
    @State private var showingWeightRepsSheet: Bool = false // New state variable

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack(alignment: .center, spacing: 15) {
                        // MARK: - Display Workout Day Date
                        Text("Workout \(workoutDay?.date ?? Date(), formatter: dateFormatter)")
                            .font(.system(size: 33, weight: .medium))
                            .foregroundColor(Color("TextColor"))
                            .padding(.top, 10)
                        
                        Spacer()
                        
                        // MARK: - Display and Input Body Weight
                        VStack {
                            Text(bodyWeight.isEmpty ? "Tap to enter body weight" : "My weight today: \(bodyWeight) \(weightInputUnit.rawValue)")
                                .font(.title)
                                .foregroundColor(Color("TextColor"))
                                .padding()
                                .background(Color("ViewColor"))
                                .cornerRadius(10)
                                .onTapGesture {
                                    tempBodyWeight = bodyWeight // Set temporary weight
                                    tempWeightUnit = weightInputUnit // Set temporary unit
                                    showingBodyWeightSheet = true
                                }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        // MARK: - Display List of Exercises
                        if let exercises = workoutDay?.exercisesArray {
                            ForEach(exercises, id: \.self) { exercise in
                                VStack(alignment: .leading) {
                                    HStack(spacing: 10) {
                                        
                                        // MARK: - Exercise Name
                                        Text("Exercise: \(exercise.exerciseName ?? "Unknown Exercise")")
                                            .font(.system(size: 27, weight: .medium))
                                            .foregroundColor(Color("TextColor"))
                                            .padding(10)
                                            .cornerRadius(10)
                                        
                                        // MARK: - Delete Exercise Button
                                        Button(action: {
                                            viewModel.deleteExercise(exercise)
                                        }) {
                                            HStack {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.white)
                                            }
                                            .padding(7)
                                            .background(Color.red)
                                            .cornerRadius(10)
                                        }
                                        .padding(.trailing, 15)
                                    }
                                    .cornerRadius(10)
                                    .padding(.horizontal, 10)
                                    
                                    exerciseSetView(for: exercise)
                                }
                            }
                        } else {
                            Text("No exercises added yet.")
                                .foregroundColor(.white)
                                .padding()
                                .padding(.leading, 20)
                        }
                        
                        Spacer()
                        
                        // MARK: - Add Exercise Button
                        HStack {
                            Text("Add Exercise")
                                .font(.title2)
                                .foregroundColor(Color("TextColor"))
                            Button(action: {
                                isShowingExercisesView = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 30, weight: .regular))
                                    .foregroundColor(Color.black)
                                    .padding(15)
                                    .background(Circle().fill(Color("ButtonColor")))
                                    .clipShape(Circle())
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        // MARK: - Done Button
                        Button(action: {
                            hideKeyboard() // Hide keyboard when done
                            viewModel.saveContext()
                            print("Context saved.")
                            selectedTab = .workoutDays
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Done")
                                .font(.system(size: 25))
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .frame(minWidth: 200, maxWidth: 200, minHeight: 70, maxHeight: 70)
                                .background(Color("ButtonColor"))
                                .cornerRadius(15)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        
                    }
                }
                .contentShape(Rectangle()) // Ensure that taps are recognized on the whole area
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .onAppear {
                if let workoutDay = workoutDay {
                    // Check if bodyWeight equals 0.0
                    if workoutDay.bodyWeight == 0.0 {
                        bodyWeight = "" // Set empty string if bodyWeight equals 0.0
                    } else {
                        bodyWeight = "\(workoutDay.bodyWeight)" // Convert Double to String
                    }
                    
                    // Get WeightUnit from string
                    weightInputUnit = WeightUnit(rawValue: workoutDay.weightUnit ?? WeightUnit.kg.rawValue) ?? .kg
                } else {
                    bodyWeight = "" // Set empty string if workoutDay equals nil
                }
            }
            
            .background(
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
            )
            
            // MARK: - Body Weight Sheet
            
            .overlay(
                Group {
                    if showingBodyWeightSheet {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .transition(.opacity)
                    }
                }
            )
            .sheet(isPresented: $showingBodyWeightSheet) {
                BodyWeightInputView(
                    bodyWeightInput: $tempBodyWeight,
                    weightUnit: $tempWeightUnit,
                    onSave: { weight, unit in
                        bodyWeight = weight
                        weightInputUnit = unit
                        
                        // Update WorkoutDay entity
                        if let workoutDay = workoutDay {
                            workoutDay.bodyWeight = Double(weight) ?? 0.0
                            workoutDay.weightUnit = unit.rawValue
                            print("Updated body weight to \(workoutDay.bodyWeight) \(weightInputUnit.rawValue)")
                            
                            // Save context
                            viewModel.saveContext()
                        } else {
                            print("No workoutDay to update.")
                        }
                        
                        hideKeyboard()
                        showingBodyWeightSheet = false
                    },
                    onCancel: {
                        hideKeyboard()
                        showingBodyWeightSheet = false
                    }
                )
                .presentationDetents([.height(300)]) // Customize the modal window height
            }
            
            // MARK: - Exercises View Transition
            
            if isShowingExercisesView {
                ExercisesView(viewModel: viewModel, workoutDay: $workoutDay, selectedExerciseItem: $selectedExerciseItem, isShowingExercisesView: $isShowingExercisesView)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(1), Color.blue.opacity(0.9), Color.clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .edgesIgnoringSafeArea(.all)
                    )
                    .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true) // Скрываем стандартную кнопку Back
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        CustomBackButtonView() // Используем кастомную кнопку
                    }
                }
        
        // MARK: - Set Weight/Reps Sheet
        
        .overlay(
            Group {
                if showingWeightRepsSheet {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                }
            }
        )
        .sheet(isPresented: $showingWeightRepsSheet) {
            WeightRepsInputView(
                weightInput: $exerciseWeightInput,
                weightInputUnit: $weightInputUnit,
                repsInput: $exerciseRepsInput,
                onSave: { weight, unit, reps in
                    exerciseWeightInput = weight
                    weightInputUnit = unit
                    if let selectedSet = selectedSet {
                        selectedSet.weight = Double(weight) ?? 0.0
                        selectedSet.weightUnit = unit.rawValue
                        selectedSet.reps = Int16(reps) ?? 0 // Update reps
                        viewModel.saveContext()
                    }
                    hideKeyboard()
                    showingWeightRepsSheet = false
                },
                onCancel: {
                    hideKeyboard()
                    showingWeightRepsSheet = false
                }
            )
            .presentationDetents([.height(330)]) // Set the sheet size to medium
        }
    }
    
    // MARK: - Date Formatter
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
    
    // MARK: - Exercise Set View
    
    private func exerciseSetView(for exercise: Exercise) -> some View {
        VStack(alignment: .leading) {
            ForEach(sets(for: exercise)) { set in
                Button(action: {
                    exerciseWeightInput = "\(set.weight)"
                    weightInputUnit = WeightUnit(rawValue: set.weightUnit ?? WeightUnit.kg.rawValue) ?? .kg
                    exerciseRepsInput = "\(set.reps)" // Add this line to set reps input
                    selectedSet = set
                    showingWeightRepsSheet = true // Present sheet
                }) {
                    HStack(spacing: 10) {
                        // MARK: - Set Info
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Set \(set.count):")
                                    .foregroundColor(Color("TextColor"))
                                    .fontWeight(.bold)
                                    .frame(width: 60, alignment: .leading)
                            }
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            HStack (spacing: 20){
                                Text("Weight: \(set.weight, specifier: "%.1f") \(set.weightUnit ?? WeightUnit.kg.rawValue)")
                                    .foregroundColor(Color("TextColor"))
                                
                                Text("Reps: \(set.reps)")
                                    .foregroundColor(Color("TextColor"))
                            }
                        }

                        Spacer()

                        // MARK: - Delete Set Button
                        Button(action: {
                            viewModel.deleteSet(set)
                        }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                                .padding(.leading, 10)
                        }
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                }
            }

            // MARK: - Add Set Button
            
            Button(action: {
                addSet(to: exercise)
            }) {
                HStack {
                    Text("Add Set")
                    Image(systemName: "plus")
                }
                .foregroundColor(Color("TextColor"))
                .padding()
                .background(Color("ViewColor2")).opacity(0.7)
                .cornerRadius(15)
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Helper Methods

    private func sets(for exercise: Exercise) -> [ExerciseSet] {
        let nsSet = exercise.sets ?? NSSet()
        let setArray = nsSet.allObjects.compactMap { $0 as? ExerciseSet }
        return setArray.sorted { $0.count < $1.count }
    }
    
    private func addSet(to exercise: Exercise) {
        // Get all sets and sort by weight
        let sortedSets = sets(for: exercise).sorted { $0.weight < $1.weight }
        
        // Create a new set
        let newSet = ExerciseSet(context: viewContext)
        
        // Use weight of the last set if available
        if let lastSet = sortedSets.last {
            newSet.weight = lastSet.weight
            newSet.weightUnit = lastSet.weightUnit
        } else {
            // Default values if no sets are present
            newSet.weight = 0
            newSet.weightUnit = WeightUnit.kg.rawValue
        }
        
        // Set count for the new set
        let maxCount = sets(for: exercise).map { $0.count }.max() ?? 0
        newSet.count = maxCount + 1
        newSet.exercise = exercise
        
        print("Adding new set: count \(newSet.count) to exercise \(exercise.exerciseName ?? "Unknown")")
        viewModel.saveContext()
    }
    
    private func hideKeyboard() {
        UIApplication.shared.endEditing()
    }
}

// MARK: - Extension to End Editing

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Preview

struct WorkoutDayDetails_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        let workoutDay = WorkoutDay(context: context)
        workoutDay.date = Date()
        
        let exercise = Exercise(context: context)
        exercise.exerciseName = "Push-Ups"
        workoutDay.addToExercises(exercise)
        
        let exerciseSet = ExerciseSet(context: context)
        exerciseSet.count = 1
        exerciseSet.weight = 50
        exerciseSet.reps = 10
        exercise.addToSets(exerciseSet)
        
        let exerciseSet2 = ExerciseSet(context: context)
        exerciseSet2.count = 2
        exerciseSet2.weight = 55.5
        exerciseSet2.reps = 10
        exercise.addToSets(exerciseSet2)
        
        @State var selectedTab: Tab = .workoutDays
        
        return WorkoutDayDetails(
            viewModel: WorkoutViewModel(),
            workoutDay: .constant(workoutDay),
            selectedTab: $selectedTab
        )
        .previewLayout(.sizeThatFits)
    }
}
