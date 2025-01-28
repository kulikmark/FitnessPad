//
//  Array+EnumeratedArray.swift
//  FitnessPad
//
//  Created by Марк Кулик on 13.01.2025.
//

import Foundation

extension Array {
    func enumeratedArray() -> [(offset: Int, element: Element)] {
        return self.enumerated().map { (offset: $0.offset, element: $0.element) }
    }
}
