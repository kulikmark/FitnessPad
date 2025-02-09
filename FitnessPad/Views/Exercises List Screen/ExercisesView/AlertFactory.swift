//
//  AlertFactory.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.02.2025.
//

import SwiftUI

struct AlertFactory {
    static func alertForExerciseManipulations(type: AlertType?, deleteAction: @escaping () -> Void) -> Alert {
        guard let alertType = type else {
            return Alert(
                title: Text("error_title".localized),
                message: Text("error_message".localized),
                dismissButton: .default(Text("OK"))
            )
        }
        
        switch alertType {
        case .delete(let exercise):
            return Alert(
                title: Text("delete_exercise_warning_title".localized),
                message: Text("delete_exercise_warning_message".localized),
                primaryButton: .destructive(Text("delete_button".localized)) {
                    deleteAction()
                },
                secondaryButton: .cancel(Text("cancel_button".localized))
            )
        // другие типы алертов
        default:
            return Alert(
                title: Text("error_title".localized),
                message: Text("error_message".localized),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
