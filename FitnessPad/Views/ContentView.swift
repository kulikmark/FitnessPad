//
//  ContentView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 19.03.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var workoutDayViewModel: WorkoutDayViewModel
    @EnvironmentObject private var foodDayViewModel: FoodDayViewModel
    @EnvironmentObject private var productViewModel: ProductViewModel
    @EnvironmentObject private var bodyWeightViewModel: BodyWeightViewModel
    @EnvironmentObject private var exerciseViewModel: ExerciseViewModel
    
    @EnvironmentObject var foodService: FoodService
    @EnvironmentObject var productService: ProductService
    @EnvironmentObject var coreDataService: CoreDataService
    
    @State private var selectedProducts: [ProductItem] = []
    @State private var selectedCategory: String? = nil
    @State private var isSelectingCategory: Bool = false

    @State private var selectedTab: Tab = .workoutDays

    var body: some View {
        NavigationStack {
            ZStack {
                switch selectedTab {
                case .workoutDays:
                    WorkoutDayView()
                        .environmentObject(workoutDayViewModel)
                case .exercises:
                    ExercisesView()
                        .environmentObject(exerciseViewModel)
                        .environmentObject(coreDataService)
                case .foodDays:
                    FoodDayView()
                        .environmentObject(foodDayViewModel)
                        .environmentObject(foodService)
                        .environmentObject(productViewModel)
                case .products:
                    CategoryGridView(
                        selectedProducts: $selectedProducts,
                        selectedCategory: $selectedCategory,
                        isSelectingCategory: isSelectingCategory
                    )
                    .environmentObject(productViewModel)
                    .environmentObject(productService)
                case .progress:
                    ProgressView()
                        .environmentObject(bodyWeightViewModel)
                case .settings:
                    SettingsView()
                }

                TabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Создаем mock объекты для всех сервисов и ViewModel
        let workoutDayService = WorkoutDayService(context: PersistenceController.shared.container.viewContext)
        let workoutDayExerciseService = WorkoutDayExerciseService(context: PersistenceController.shared.container.viewContext)
        let bodyWeightService = BodyWeightService(context: PersistenceController.shared.container.viewContext)
        
        let workoutDayViewModel = WorkoutDayViewModel(
            workoutDayService: workoutDayService,
            bodyWeightService: bodyWeightService,
            workoutDayExerciseService: workoutDayExerciseService
        )
        
        let foodService = FoodService(context: PersistenceController.shared.container.viewContext)
        let foodDayViewModel = FoodDayViewModel(foodService: foodService)
        let bodyWeightViewModel = BodyWeightViewModel(bodyWeightService: bodyWeightService)
        let exerciseViewModel = ExerciseViewModel(
            defaultExerciseService: ExerciseService(context: PersistenceController.shared.container.viewContext),
            exerciseCategoryService: ExerciseCategoryService(context: PersistenceController.shared.container.viewContext),
            workoutDaysCache: workoutDayViewModel.workoutDaysCache
        )
        
        let coreDataService = CoreDataService(context: PersistenceController.shared.container.viewContext)
        
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            .environmentObject(workoutDayViewModel)
            .environmentObject(foodDayViewModel)
            .environmentObject(foodService)
            .environmentObject(bodyWeightViewModel)
            .environmentObject(exerciseViewModel)
            .environmentObject(coreDataService)
    }
}
