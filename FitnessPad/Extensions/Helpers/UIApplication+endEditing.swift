//
//  UIApplication+endEditing.swift
//  FitnessPad
//
//  Created by Марк Кулик on 14.01.2025.
//

import UIKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        guard let windowScene = connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.endEditing(force)
    }
}
