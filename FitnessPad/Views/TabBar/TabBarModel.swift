//
//  TabBarModel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var image: String
    var tabItem: Tab
}

var tabItems = [
    TabItem(text: NSLocalizedString("tab_workouts", comment: ""), image: "duffle.bag", tabItem: .workoutDays),
    TabItem(text: NSLocalizedString("tab_exercises", comment: ""), image: "figure.strengthtraining.traditional", tabItem: .exercises),
    TabItem(text: NSLocalizedString("tab_food_days", comment: ""), image: "fork.knife", tabItem: .foodDays),
    TabItem(text: NSLocalizedString("tab_products", comment: ""), image: "refrigerator", tabItem: .products),
    TabItem(text: NSLocalizedString("tab_progress", comment: ""), image: "medal", tabItem: .progress),
    TabItem(text: NSLocalizedString("tab_settings", comment: ""), image: "gearshape", tabItem: .settings)
]

enum Tab: String {
    case workoutDays
    case exercises
    case foodDays
    case products
    case progress
    case settings
}
