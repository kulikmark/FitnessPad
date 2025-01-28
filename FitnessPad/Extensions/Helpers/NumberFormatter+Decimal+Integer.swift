//
//  NumberFormatter+Decimal+Integer.swift
//  FitnessPad
//
//  Created by Марк Кулик on 13.01.2025.
//

import Foundation

extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    static var integer: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
}
