//
//  ProgressView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

//import SwiftUI
//
//struct ProgressView: View {
//    
//    var body: some View {
//        
//        
//        VStack(alignment: .leading) {
//            
//            Text("Progress")
//                .font(.system(size: 43))
//                .fontWeight(.medium)
//                .foregroundColor(Color("TextColor"))
//                .padding(.leading, 20)
//                .padding(.top, 20)
//                .padding(.bottom, 20)
//            VStack {
//            Image("progressImage")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 360)
//                .padding(.vertical, 40)
//                .padding(.horizontal, 10)
//            
//            VStack {
//                HStack(spacing:25) {
//                    VStack {
//                        Text("Weights")
//                            .font(.system(size: 43))
//                            .fontWeight(.medium)
//                            .foregroundColor(Color("TextColor"))
//
//                        Text("increased by")
//                            .font(.system(size: 27))
//                            .fontWeight(.medium)
//                            .foregroundColor(Color("TextColor"))
//                    }
//
//                        Text("5,9%")
//                            .font(.system(size: 60))
//                            
//                            .fontWeight(.bold)
//                            .foregroundColor(Color("TextColor"))
//                            .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 130)
//                            .background(Color("ViewColor2"))
//                            .cornerRadius(25, corners: .allCorners)
//                            .padding(.trailing, 5)
//                }
//            }
//            .padding(.horizontal, 10)
//            .padding(.bottom, 100)
//        }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color("BackgroundColor")
//            .edgesIgnoringSafeArea(.all)
//        )
//    }
//}
//
//struct ProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgressView()
//    }
//}


import SwiftUI
import CoreData

struct ProgressView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Progress Overview")
                .font(.system(size: 43))
                .fontWeight(.medium)
                .foregroundColor(Color("TextColor"))
                .padding(.leading, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            let workoutCount = ProgressUtils.calculateProgress(in: viewContext)
            let weightChange = ProgressUtils.calculateWeightChange(in: viewContext)
            let userGoal = ProgressUtils.getUserGoal(in: viewContext)

            Spacer()
            
            VStack {
                Text("Total Workouts: \(workoutCount)")
                    .font(.system(size: 27))
                    .foregroundColor(Color("TextColor"))
                    .padding(.bottom, 10)
                
                Text("Weight Change: \(weightChange, specifier: "%.2f") kg")
                    .font(.system(size: 27))
                    .foregroundColor(Color("TextColor"))
                    .padding(.bottom, 20)
                
                if let goal = userGoal {
                    Text("Goal: \(goal.targetWeight) kg")
                        .font(.system(size: 27))
                        .foregroundColor(Color("TextColor"))
                    
                    if goal.achieved {
                        Text("Congratulations! You have achieved your goal!")
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding(.top, 10)
                    } else {
                        Text("Current Weight: \(goal.currentWeight) kg")
                            .font(.system(size: 27))
                            .foregroundColor(Color("TextColor"))
                    }
                }
                
                Spacer()
                
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
    }
}


struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext

        // Создание сущности WorkoutDay
        let workoutDay = WorkoutDay(context: context)
        workoutDay.date = Date()
        workoutDay.bodyWeight = 70.0
        workoutDay.weightUnit = "kg"  // Укажите единицу измерения

        // Создание сущности Exercise
        let exercise = Exercise(context: context)
        exercise.exerciseName = "Bench Press"
        exercise.exerciseCategory = "Strength"
        if let image = UIImage(named: "bench_press_image") {
                   exercise.exerciseImage = image.pngData()  // Преобразование изображения в Data
               }
        exercise.isDefault = true

        // Создание сущности ExerciseSet
        let set1 = ExerciseSet(context: context)
        set1.weight = 50.0
        set1.reps = 10
        set1.count = 1
        set1.weightUnit = "kg"  // Укажите единицу измерения

        let set2 = ExerciseSet(context: context)
        set2.weight = 60.0
        set2.reps = 8
        set2.count = 1
        set2.weightUnit = "kg"  // Укажите единицу измерения

        // Связывание сетов с упражнением
        exercise.addToSets(set1)
        exercise.addToSets(set2)

        // Связывание упражнения с днем тренировки
        workoutDay.addToExercises(exercise)

        // Создание сущности UserGoal
        let userGoal = UserGoal(context: context)
        userGoal.targetWeight = 65.0
        userGoal.currentWeight = 70.0
        userGoal.achieved = false
        userGoal.aim = "Lose weight"  // Цель пользователя

        // Сохранение контекста
        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении контекста: \(error)")
        }

        return ProgressView()
            .environment(\.managedObjectContext, context)
    }
}
