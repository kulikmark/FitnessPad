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
//            .padding(.horizontal)

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




//struct CalendarTabs: View {
//    @Binding var selectedDate: Date
//    @Binding var currentMonth: Date
//    @Binding var currentMonthIndex: Int // Индекс текущего месяца
//
//    var body: some View {
//        TabView(selection: $currentMonthIndex) {
//            ForEach(getMonths(), id: \.self) { month in
//                CalendarStrip(selectedDate: $selectedDate, currentMonth: month)
//                    .tag(getMonths().firstIndex(of: month) ?? 0) // Присваиваем индекс месяца
//            }
//        }
//        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//        .background(Color("BackgroundColor"))
//        .onAppear {
//            // Прокручиваем к текущему месяцу при загрузке
//            let today = Date()
//            let months = getMonths()
//            if let index = months.firstIndex(where: { Calendar.current.isDate($0, equalTo: today, toGranularity: .month) }) {
//                currentMonthIndex = index
//            }
//        }
//        .onChange(of: currentMonthIndex) { _, newIndex in
//            currentMonth = getMonths()[newIndex]
//        }
//    }
//
//    // Генерируем список месяцев
//    private func getMonths() -> [Date] {
//        let calendar = Calendar.current
//        var months: [Date] = []
//        let startDate = calendar.date(from: DateComponents(year: 2025, month: 1, day: 1))!
//        
//        // Добавляем 120 месяцев (10 лет) для примера
//        for i in 0..<120 {
//            if let month = calendar.date(byAdding: .month, value: i, to: startDate) {
//                months.append(month)
//            }
//        }
//        return months
//    }
//}
