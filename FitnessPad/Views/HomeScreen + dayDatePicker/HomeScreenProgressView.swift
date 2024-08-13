//
//  HomeScreenProgressView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.08.2024.
//

import SwiftUI

struct ProgressRingView: View {
    var progress: [ExerciseProgress] // Список прогрессов по упражнениям
    
    var body: some View {
        VStack {
            ForEach(progress, id: \.exerciseName) { progressItem in
                WorkoutProgressView(
                    exerciseName: progressItem.exerciseName,
                    progressPercentage: progressItem.progressPercentage,
                    weightGain: progressItem.weightGain
                )
            }
        }
    }
}

struct WorkoutProgressView: View {
    var exerciseName: String
    var progressPercentage: Double
    var weightGain: Double
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0.0, to: progressPercentage / 100)
                    .stroke(Color("ViewColor2"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 100, height: 100)
                
                VStack {
                    Text("\(Int(progressPercentage))%")
                        .font(.title2)
                        .foregroundColor(Color("TextColor"))
                        .fontWeight(.bold)
                    Text("\(weightGain, specifier: "%.2f") kg")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Text(exerciseName)
                .font(.caption)
                .foregroundColor(Color("TextColor"))
                .padding(.top, 7)
        }
    }
}

struct ProgressRingView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingView(progress: [
            ExerciseProgress(exerciseName: "Bench Press", progressPercentage: 25.0, weightGain: 15.0, startDate: Date(), endDate: Date()),
            ExerciseProgress(exerciseName: "Squat", progressPercentage: 40.0, weightGain: 30.0, startDate: Date(), endDate: Date()),
            ExerciseProgress(exerciseName: "Deadlift", progressPercentage: 50.0, weightGain: 40.0, startDate: Date(), endDate: Date())
        ])
    }
}
