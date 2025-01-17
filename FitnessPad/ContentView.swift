//
//  ContentView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 19.03.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var selectedTab: Tab = .home
//    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = WorkoutViewModel()
    @State private var workoutDay: WorkoutDay? = nil
    @State private var isShowingExercisesView: Bool = true
    @State private var selectedDate: Date = Date()

    var body: some View {
            NavigationStack {
                ZStack {
                    switch selectedTab {
                    case .home:
                        HomeView(viewModel: viewModel, workoutDay: $workoutDay, selectedTab: $selectedTab, selectedDate: $selectedDate)
                    case .workoutDays:
                        WorkoutDaysList(viewModel: viewModel, workoutDay: $workoutDay)
                    case .exercises:
                        if isShowingExercisesView {
                            ExercisesView(viewModel: viewModel, workoutDay: $workoutDay)
                        }
                    case .progress:
                        ProgressView()
                        
                    case .settings:
                        SettingsView()
                    }
                    
                    TabBarView(selectedTab: $selectedTab)
                }
            }
//            .onAppear {
//                viewModel.fetchWorkoutDays()
//            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}



//struct ContentView: View {
// 
//    @Environment(\.managedObjectContext) private var viewContext
//    @StateObject var viewModel = WorkoutViewModel()
//    @State private var workoutDay: WorkoutDay? = nil
//
//    var body: some View {
//        GeometryReader {
//            let safeArea = $0.safeAreaInsets
//            NavigationStack {
//                ZStack {
//                        WorkoutDaysList(viewModel: viewModel, workoutDay: $workoutDay, safeArea: safeArea)
//                            .ignoresSafeArea(.container, edges: .top)
//                }
//            }
//            .onAppear {
//                viewModel.fetchWorkoutDays() // Загружаем тренировочные дни при старте
//                viewModel.fetchUserGoal()    // Загружаем цель пользователя
//            }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//    }
//}
//
