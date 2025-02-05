//
//  MealListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

// MARK: - Компонент для списка приемов пищи
struct MealListView: View {
    var meals: [Meal]
    var onDelete: (Meal) -> Void
    var onEdit: (Meal) -> Void
    
    var body: some View {
        let sortedMeals = meals.sorted { $0.createdAt! < $1.createdAt! }

        if !sortedMeals.isEmpty {
            List {
                ForEach(sortedMeals, id: \.id) { meal in
                    MealRowView(meal: meal, onEdit: onEdit, onDelete: onDelete)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        onDelete(sortedMeals[index])
                    }
                }
            }
            .listStyle(PlainListStyle())
            .background(Color("BackgroundColor"))
            .scrollContentBackground(.hidden)
        } else {
            Spacer()
            Text("No meals added yet.".localized)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
            Spacer()
        }
    }
}
