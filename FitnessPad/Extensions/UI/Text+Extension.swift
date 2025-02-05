//
//  Text+Extension.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

// MARK: - Расширения для текста
extension Text {
    func grayText() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(.gray)
    }
    
    func whiteText() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(Color("TextColor"))
    }
}
