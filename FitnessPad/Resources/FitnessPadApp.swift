//
//  FitnessPadApp.swift
//  FitnessPad
//
//  Created by Марк Кулик on 19.03.2022.
//

import SwiftUI
import CoreData
//
//@main
//struct FitnessPadApp: App {
//    let persistenceController = PersistenceController.shared
//    @State private var isLaunchScreenActive = true // Состояние для Launch Screen
//    
//    init() {
//        // Инициализация дефолтных упражнений при запуске приложения
//        persistenceController.initializeDefaultExercises()
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            if isLaunchScreenActive {
//                LaunchScreenView()
//                    .onAppear {
//                        // Задержка для отображения Launch Screen (например, 2 секунды)
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            isLaunchScreenActive = false // Переключаем на основной интерфейс
//                        }
//                    }
//            } else {
//                ContentView()
//                    .transition(.opacity) // Плавное появление
//                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            }
//        }
//    }
//}

@main
struct FitnessPadApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isLaunchScreenActive = true
    @State private var isAnimationComplete = false // Флаг завершения анимации

    init() {
        persistenceController.initializeDefaultExercises()
    }
    
    var body: some Scene {
        WindowGroup {
            if isLaunchScreenActive {
                LaunchScreenView(isAnimationComplete: $isAnimationComplete)
                    .onChange(of: isAnimationComplete) { _, newValue in
                        if newValue {
                            // Анимация завершена, переключаемся на главный экран
                            isLaunchScreenActive = false
                        }
                    }
            } else {
                // Создаем экземпляры сервисов
                let workoutDayService = WorkoutDayService(context: persistenceController.container.viewContext)
                let workoutDayExerciseService = WorkoutDayExerciseService(context: persistenceController.container.viewContext)
                let foodService = FoodService(context: persistenceController.container.viewContext)
                let productService = ProductService(context: persistenceController.container.viewContext)
                let bodyWeightService = BodyWeightService(context: persistenceController.container.viewContext)
                let exerciseService = ExerciseService(context: persistenceController.container.viewContext)
                let exerciseCategoryService = ExerciseCategoryService(context: persistenceController.container.viewContext)
                
                let coreDataService = CoreDataService(context: persistenceController.container.viewContext)

                // Создаем экземпляры ViewModel
                let workoutDayViewModel = WorkoutDayViewModel(
                    workoutDayService: workoutDayService,
                    bodyWeightService: bodyWeightService,
                    workoutDayExerciseService: workoutDayExerciseService
                )
                let foodDayViewModel = FoodDayViewModel(foodService: foodService)
                let productViewModel = ProductViewModel(productService: productService)
                let bodyWeightViewModel = BodyWeightViewModel(bodyWeightService: bodyWeightService)
                let exerciseViewModel = ExerciseViewModel(
                    defaultExerciseService: exerciseService,
                    exerciseCategoryService: exerciseCategoryService,
                    workoutDaysCache: workoutDayViewModel.workoutDaysCache
                )

                ContentView()
                    .transition(.opacity)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(workoutDayViewModel)
                    .environmentObject(foodDayViewModel)
                    .environmentObject(foodService)
                    .environmentObject(productViewModel)
                    .environmentObject(productService)
                    .environmentObject(bodyWeightViewModel)
                    .environmentObject(exerciseViewModel)
                    .environmentObject(coreDataService)
            }
        }
    }
}
