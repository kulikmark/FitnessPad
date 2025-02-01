//
//  WorkoutDay+DateFormatter.swift
//  FitnessPad
//
//  Created by Марк Кулик on 15.01.2025.
//

import Foundation

//extension Date {
//    // Форматируем день недели (например, "WED")
//    func formattedDayOfWeek() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "E" // "E" возвращает сокращенное название дня недели (например, "WED")
//        return formatter.string(from: self).uppercased() // Приводим к верхнему регистру
//    }
//    
//    // Форматируем дату (например, "21 Jan")
//    func formattedDate() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM dd, yyyy" // "d MMM" возвращает день и сокращенное название месяца
//        return formatter.string(from: self)
//    }
//}

import Foundation

extension Date {
    // Форматируем день недели (например, "ВС" или "Sun")
    func formattedDayOfWeek() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current // Используем текущую локаль устройства
        formatter.dateFormat = "E" // "E" возвращает сокращенное название дня недели
        return formatter.string(from: self).uppercased() // Приводим к верхнему регистру
    }
    
    // Форматируем дату (например, "02 Февраля 2025" или "02 February 2025")
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current // Используем текущую локаль устройства
        formatter.dateFormat = "dd MMMM yyyy" // "dd MMMM yyyy" возвращает день, месяц и год
        return formatter.string(from: self)
    }
}
