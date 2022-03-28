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
    TabItem(text: "Home", image: "home", tabItem: .home),
    TabItem(text: "Trainings", image: "trainings", tabItem: .trainings),
    TabItem(text: "Exercises", image: "exercises", tabItem: .exercises),
    TabItem(text: "Progress", image: "progress", tabItem: .progress)
]


enum Tab: String {
    case home
    case trainings
    case exercises
    case progress
}
