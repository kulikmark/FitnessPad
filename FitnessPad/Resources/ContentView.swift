//
//  ContentView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 19.03.2022.
//

//import SwiftUI
//import CoreData
//
//struct ContentView: View {
//    @State var selectedTab: Tab = .workoutDays
//    @StateObject private var viewModel: WorkoutDayViewModel
//    @StateObject private var foodService: FoodService
//    @State private var isShowingExercisesView: Bool = true
//    @State private var selectedDate: Date = Date()
//
//    // Инициализатор для создания ViewModel с зависимостями
//    init() {
//        let context = PersistenceController.shared.container.viewContext
//        let workoutDayService = WorkoutDayService(context: context)
//        let foodService = FoodService(context: context) // Создаём экземпляр
//        let bodyWeightService = BodyWeightService(context: context)
//        let exerciseService = ExerciseService(context: context)
//        let exerciseCategoryService = ExerciseCategoryService(context: context)
//        
//        // Создаем ViewModel с зависимостями
//        _viewModel = StateObject(
//            wrappedValue: WorkoutDayViewModel(
//                workoutDayService: workoutDayService,
//                foodService: foodService,
//                bodyWeightService: bodyWeightService,
//                exerciseService: exerciseService,
//                exerciseCategoryService: exerciseCategoryService
//            )
//        )
//        
//        // Инициализируем foodService
//        _foodService = StateObject(wrappedValue: foodService)
//    }
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                switch selectedTab {
//                case .workoutDays:
//                    WorkoutDayView()
//                case .foodDays:
//                    FoodDayView()
//                case .exercises:
//                    if isShowingExercisesView {
//                        ExercisesView()
//                    }
//                case .progress:
//                    ProgressView()
//                case .settings:
//                    SettingsView()
//                }
//
//                TabBarView(selectedTab: $selectedTab)
//            }
//        }
//        .environmentObject(viewModel)
//        .environmentObject(foodService)
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//    }
//}

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var workoutDayViewModel: WorkoutDayViewModel
    @EnvironmentObject private var foodDayViewModel: FoodDayViewModel
    @EnvironmentObject private var bodyWeightViewModel: BodyWeightViewModel
    @EnvironmentObject private var exerciseViewModel: ExerciseViewModel
    
    @EnvironmentObject var foodService: FoodService
    @EnvironmentObject var coreDataService: CoreDataService

    @State private var selectedTab: Tab = .workoutDays

    var body: some View {
        NavigationStack {
            ZStack {
                switch selectedTab {
                case .workoutDays:
                    WorkoutDayView()
                        .environmentObject(workoutDayViewModel)
                case .foodDays:
                    FoodDayView()
                        .environmentObject(foodDayViewModel)
                        .environmentObject(foodService)
                case .exercises:
                    ExercisesView()
                        .environmentObject(exerciseViewModel)
                        .environmentObject(coreDataService)
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
