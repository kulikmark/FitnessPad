//
//  FitnessPadApp.swift
//  FitnessPad
//
//  Created by Марк Кулик on 19.03.2022.
//

import SwiftUI
import CoreData

@main
struct FitnessPadApp: App {
    let persistenceController = PersistenceController.shared
    @State private var isLaunchScreenActive = true // Состояние для Launch Screen
    
    init() {
        // Инициализация дефолтных упражнений при запуске приложения
        persistenceController.initializeDefaultExercises()
    }
    
    var body: some Scene {
        WindowGroup {
            if isLaunchScreenActive {
                LaunchScreenView()
                    .onAppear {
                        // Задержка для отображения Launch Screen (например, 2 секунды)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLaunchScreenActive = false // Переключаем на основной интерфейс
                        }
                    }
            } else {
                ContentView()
                    .transition(.opacity) // Плавное появление
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
