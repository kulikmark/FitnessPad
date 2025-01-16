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
    TabItem(text: "Home", image: "house", tabItem: .home),
    TabItem(text: "Workouts", image: "duffle.bag", tabItem: .workoutDays),
    TabItem(text: "Exercises", image: "figure.strengthtraining.traditional", tabItem: .exercises),
    TabItem(text: "Progress", image: "medal", tabItem: .progress),
    TabItem(text: "Settings", image: "gearshape", tabItem: .settings)
]


enum Tab: String {
    case home
    case workoutDays
    case exercises
    case progress
    case settings
}
