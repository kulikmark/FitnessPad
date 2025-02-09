//
//  CalendarTabs.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

// MARK: - Календарь с вкладками месяцев
struct CalendarTabs: View {
    @Binding var selectedDate: Date
    @Binding var currentWeek: Date
    @Binding var currentWeekIndex: Int

    var body: some View {
        VStack {
            // Заголовок с фиксированными днями недели
            HStack {
                ForEach(["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"], id: \.self) { day in
                    Text(day)
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                       
                }
            }

            TabView(selection: $currentWeekIndex) {
                ForEach(0..<120, id: \.self) { index in
                    let weekStart = getStartOfWeek(from: "2025-01-01", byAdding: index)
                    CalendarStrip(selectedDate: $selectedDate, currentWeek: weekStart)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .background(Color("BackgroundColor"))
            .onAppear {
                scrollToCurrentWeek()
            }
            .onChange(of: currentWeekIndex) { _, newIndex in
                currentWeek = getStartOfWeek(from: "2025-01-01", byAdding: newIndex)
            }
        }
        
    }

    // Возвращает начальную дату недели с базовой даты
    private func getStartOfWeek(from baseDateString: String, byAdding weeks: Int) -> Date {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let baseDate = formatter.date(from: baseDateString)!

        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: baseDate))!
        return calendar.date(byAdding: .weekOfYear, value: weeks, to: startOfWeek)!
    }

    private func scrollToCurrentWeek() {
        let calendar = Calendar.current
        let today = Date()
        let startOfCurrentWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let weeks = (0..<120).map { getStartOfWeek(from: "2025-01-01", byAdding: $0) }
        if let index = weeks.firstIndex(where: { calendar.isDate($0, equalTo: startOfCurrentWeek, toGranularity: .weekOfYear) }) {
            currentWeekIndex = index
        }
    }
}
