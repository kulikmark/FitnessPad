//
//  LocalisedString.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
