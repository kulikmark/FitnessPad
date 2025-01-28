//
//  ContentView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 19.03.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var selectedTab: Tab = .workoutDays
    @StateObject var viewModel = WorkoutViewModel()
//    @State private var workoutDay: WorkoutDay? = nil
    @State private var isShowingExercisesView: Bool = true
    @State private var selectedDate: Date = Date()

    var body: some View {
            NavigationStack {
                ZStack {
                    switch selectedTab {
                    case .workoutDays:
                        WorkoutDayView()
                        
                    case .foodDays:
                        FoodDayView()
                    case .exercises:
                        if isShowingExercisesView {
                            ExercisesView()
                        }
                    case .progress:
                        ProgressView()
                        
                    case .settings:
                        SettingsView()
                    }
                    
                    TabBarView(selectedTab: $selectedTab)
                }
            }
            .environmentObject(viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
