//
//  WorkoutDayDetailsSetsView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 30.12.2024.
//

import SwiftUI
import CoreData

struct WorkoutDayDetailsSetsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: WorkoutViewModel
    var exercise: Exercise

    var body: some View {
        VStack(alignment: .leading) {
            exerciseSetView(for: exercise)
        }
        .background(Color("BackgroundColor"))
    }

    func exerciseSetView(for exercise: Exercise) -> some View {
        VStack(alignment: .leading) {
            ForEach(sets(for: exercise), id: \.self) { set in
                Button(action: {
                    // Действие при нажатии на сет
                }) {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Set \(set.count):")
                                .foregroundColor(Color("TextColor"))
                                .fontWeight(.bold)
                        }
                        
                        Text("Weight: \(set.weight, specifier: "%.1f") Reps: \(set.reps)")
                            .foregroundColor(Color("TextColor"))
                    }
                    .padding(10)
                    .padding(.horizontal, 20)
                }
            }
        }
       
    }

    func sets(for exercise: Exercise) -> [ExerciseSet] {
        let nsSet = exercise.sets ?? NSSet()
        return nsSet.allObjects.compactMap { $0 as? ExerciseSet }.sorted { $0.count < $1.count }
    }

    func hideKeyboard() {
        UIApplication.shared.endEditing()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
