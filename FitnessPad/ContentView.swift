//
//  ContentView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 19.03.2022.
//
import SwiftUI
import CoreData

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel: WorkoutViewModel
    @State private var selectedExercise: ExerciseItem? = nil
    @State private var workoutDay: WorkoutDay? = nil
    @State private var isShowingExercisesView: Bool = true
    @State private var selectedDate: Date = Date()

    init() {
        _viewModel = StateObject(wrappedValue: WorkoutViewModel())
    }

    var body: some View {
        NavigationStack {
            ZStack {
                switch selectedTab {
                case .home:
                    HomeView(viewModel: viewModel, workoutDay: $workoutDay, selectedTab: $selectedTab, selectedDate: $selectedDate)
                case .workoutDays:
                    WorkoutDaysList(viewModel: viewModel, workoutDay: $workoutDay, selectedTab: $selectedTab, selectedDate: $selectedDate)
                case .exercises:
                    if isShowingExercisesView {
                        ExercisesView(viewModel: viewModel, workoutDay: $workoutDay, selectedExerciseItem: $selectedExercise, isShowingExercisesView: $isShowingExercisesView)
                    }
                case .progress:
                    ProgressView()
                }
                
                TabBarView(selectedTab: selectedTab)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return ContentView()
            .environment(\.managedObjectContext, context)
    }
}
