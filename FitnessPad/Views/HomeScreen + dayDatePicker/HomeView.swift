//
//  HomeView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//


//    // Пример данных для предварительного просмотра прогресса
//    private func sampleProgress() -> [ExerciseProgress] {
//        return [
//            ExerciseProgress(exerciseName: "Bench Press", progressPercentage: 25.0, weightGain: 15.0, startDate: Date(), endDate: Date()),
//            ExerciseProgress(exerciseName: "Squat", progressPercentage: 40.0, weightGain: 30.0, startDate: Date(), endDate: Date()),
//            ExerciseProgress(exerciseName: "Deadlift", progressPercentage: 50.0, weightGain: 40.0, startDate: Date(), endDate: Date())
//        ]
//    }


import SwiftUI
import CoreData

enum FitnessGoal: String, CaseIterable, Identifiable {
    case muscleGain = "Muscle Gain"
    case weightLoss = "Weight Loss"
    case strength = "Strength"
    
    var id: String { self.rawValue }
    
    // Возвращаем системные иконки для каждой цели
    var iconName: String {
        switch self {
        case .muscleGain:
            return "figure.strengthtraining.traditional"
        case .weightLoss:
            return "figure.walk"
        case .strength:
            return "bolt"
        }
    }
}


struct HomeView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Binding var workoutDay: WorkoutDay?
    @Binding var selectedTab: Tab
    @Binding var selectedDate: Date
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isShowingGoalSheet = false
    
    @FetchRequest(
        entity: UserGoal.entity(),
        sortDescriptors: []
    ) private var userGoals: FetchedResults<UserGoal>
    
    // URL и заголовки статей
    private let articles: [String: (url: String, title: String)] = [
        "MainScreenImage": ("https://www.menshealth.com/uk/workouts/a61773856/total-body-dumbbell-ladder-workout/", "Total Body Dumbbell Ladder Workout"),
        "MainScreenImage2": ("https://www.menshealth.com/uk/workouts/a61762258/dumbbell-only-shoulder-and-back-workout/", "Dumbbell-Only Shoulder and Back Workout"),
        "MainScreenImage3": ("https://www.menshealth.com/uk/workouts/a41063074/bigger-legs-squat-deadlift-ladder-workout/", "Bigger Legs Squat and Deadlift Workout"),
        "MainScreenImage4": ("https://www.menshealth.com/uk/workouts/a61739581/full-body-dumbbell-training-plan-week-fifty-five/", "Full Body Dumbbell Training Plan"),
        "MainScreenImage5": ("https://www.menshealth.com/uk/workouts/a61735586/ultimate-bodyweight-workout/", "Ultimate Bodyweight Workout")
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    VStack {
                        Text("Choose Your Training Aim")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("TextColor"))
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        HStack {
                            if let goal = viewModel.selectedGoal {
                                Image(systemName: goal.iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                
                                Text("My aim: \(goal.rawValue)")
                            } else {
                                Image(systemName: "questionmark.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                
                                Text("Choose your training aim")
                            }
                        }
                        .font(.title2)
                        .foregroundColor(Color("TextColor"))
                        .padding()
                        .background(Color("ViewColor"))
                        .cornerRadius(20)
                        .onTapGesture {
                            isShowingGoalSheet = true
                        }
                        .padding(.top, 30)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    
                    Spacer(minLength: 40)
                    
                    // Секция со статьями
                    VStack(alignment: .leading) {
                        ZStack {
                            Color("ViewColor").opacity(0.7)
                                .cornerRadius(20, corners: [.topLeft, .bottomLeft])
                            
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Discover Useful Articles")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("TextColor"))
                                        .padding(.horizontal, 20)
                                    
                                    Text("Tap on an image to read the full article.")
                                        .font(.subheadline)
                                        .foregroundColor(Color("TextColor").opacity(0.8))
                                        .padding(.horizontal, 20)
                                }
                                .padding(.top, 10)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(Array(articles.keys), id: \.self) { imageName in
                                            homeScreenImage(imageName: imageName, article: articles[imageName]!)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 20)
                                    .padding(.bottom, 20)
                                }
                            }
                        }
                    }
                    .padding(.leading, 20)
                    
                    Spacer(minLength: 40)
                    
                    
                    // Секция с добавлением тренировочного дня
                    
                    AddTrainingDayView(viewModel: viewModel, selectedDate: $selectedDate, workoutDay: $workoutDay, selectedTab: $selectedTab)
                    
                    // Секция со статистикой прогресса упражнений
                    VStack(alignment: .leading) {
                        Text("Your Workout Progress")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("TextColor"))
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        let progressData = ProgressUtils.calculateProgress(in: viewContext)
                        
                        if progressData.isEmpty {
                            Text("No progress data available. Start adding workout days to see your progress!")
                                .font(.subheadline)
                                .foregroundColor(Color("TextColor"))
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                .padding(.bottom, 20)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(progressData, id: \.exerciseName) { progress in
                                        WorkoutProgressView(exerciseName: progress.exerciseName, progressPercentage: progress.progressPercentage, weightGain: progress.weightGain)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 20)
                                .padding(.bottom, 20)
                            }
                        }
                    }
                    .background(Color("ViewColor").opacity(0.7))
                    .cornerRadius(20)
                    .padding(.horizontal, 10)
                    
                    Spacer(minLength: 90)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            )
            .overlay(
                Group {
                    if isShowingGoalSheet {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .transition(.opacity)
                    }
                }
            )
            .sheet(isPresented: $isShowingGoalSheet) {
                           GoalSelectionSheet(
                               selectedGoal: $viewModel.selectedGoal,  // Обновлено
                               onSave: {
                                   if let goal = viewModel.selectedGoal {
                                       viewModel.saveGoal(goal)  // Обновлено
                                       isShowingGoalSheet = false
                                   }
                               },
                               onCancel: {
                                   isShowingGoalSheet = false
                               }
                           )
                           .presentationDetents([.height(350)])
                       }
                   }
        
        .onAppear {
            viewModel.fetchUserGoal()
        }
    }
}

// Структура для хранения прогресса упражнения
struct ExerciseProgress {
    let exerciseName: String
    let progressPercentage: Double
    let weightGain: Double
    let startDate: Date
    let endDate: Date
}

// Ваше текущее представление для отображения изображений статей
struct homeScreenImage: View {
    var imageName: String
    var article: (url: String, title: String)
    
    @State private var isTapped = false
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
                .cornerRadius(15)
                .shadow(radius: 10)
                .scaleEffect(isTapped ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isTapped)
                .onTapGesture {
                    if let url = URL(string: article.url) {
                        UIApplication.shared.open(url)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {
                    isTapped.toggle()
                })
            
            Text(article.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color("TextColor"))
                .padding(.top, 5)
                .padding(.horizontal, 10)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let viewModel = WorkoutViewModel()
        @State var selectedTab: Tab = .workoutDays
        @State var selectedDate = Date()
        
        return HomeView(
            viewModel: viewModel, workoutDay: .constant(nil),
            selectedTab: $selectedTab, selectedDate: $selectedDate
        )
        .environment(\.managedObjectContext, context)
    }
}
