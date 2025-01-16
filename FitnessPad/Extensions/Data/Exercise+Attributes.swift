//
//  Exercise+Attributes.swift
//  FitnessPad
//
//  Created by Марк Кулик on 13.01.2025.
//

import Foundation

extension Exercise {
    // Возвращает массив аттрибутов, соответствующих указанному имени и состоянию isAdded
    func attribute(for name: String) -> ExerciseAttribute? {
            guard let attributes = self.attributes as? Set<ExerciseAttribute> else {
                return nil
            }
            return attributes.first(where: { $0.name == name && $0.isAdded })
        }

    // Возвращает все аттрибуты, соответствующие состоянию isAdded
    func addedAttributes() -> [ExerciseAttribute] {
        guard let attributes = self.attributes as? Set<ExerciseAttribute> else {
            return []
        }
        return attributes.filter { $0.isAdded }
    }
}
