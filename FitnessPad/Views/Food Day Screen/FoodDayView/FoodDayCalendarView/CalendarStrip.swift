//
//  CalendarStrip.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

// MARK: - Календарная лента для одного месяца
struct CalendarStrip: View {
    @Binding var selectedDate: Date
    var currentWeek: Date
    @EnvironmentObject var viewModel: WorkoutDayViewModel
    @State private var days: [Date] = []

    var body: some View {
        HStack {
            ForEach(days, id: \.self) { date in
                CalendarDayView(date: date, isSelected: isSameDay(date1: date, date2: selectedDate))
                    .environmentObject(viewModel)
                    .onTapGesture {
                        selectedDate = date
                    }
            }
        }
        .onAppear {
            loadDays(for: currentWeek)
        }
    }

    private func loadDays(for weekStart: Date) {
        let calendar = Calendar.current
        days = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: weekStart)
        }
    }

    private func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}
