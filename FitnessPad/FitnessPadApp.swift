//
//  FitnessPadApp.swift
//  FitnessPad
//
//  Created by Марк Кулик on 19.03.2022.
//

import SwiftUI

@main
struct FitnessPadApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(TrainingsViewModel())
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
