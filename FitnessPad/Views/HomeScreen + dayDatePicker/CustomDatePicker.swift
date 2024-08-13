//
//  CustomDatePicker.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.08.2024.
//

import SwiftUI

// Кастомный виджет для выбора даты с развернутым и свернутым состоянием
struct CustomDatePicker: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutDay.date, ascending: true)],
        animation: .default)
    private var workoutDays: FetchedResults<WorkoutDay>
    
    @Binding var selectedDate: Date // Привязка к выбранной дате из родительского представления
    var isExpanded: Bool // Булево значение, определяющее, развернут ли виджет
    
    @State private var currentDate = Date() // Состояние для хранения текущей даты
    @State private var showAlert = false
    @State private var transitionState: Bool = false
    
    // Определяем допустимые границы выбора дат
    private let minDate = Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 1))!
    private let maxDate = Date.distantFuture
    
    // Используем текущий календарь
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Устанавливаем первый день недели — понедельник
        return calendar
    }
    
    // Список дней недели, преобразованных в верхний регистр
    private var daysOfWeek: [String] {
        return calendar.shortWeekdaySymbols.map { $0.uppercased() }
    }
    
    // Список дат текущего месяца
    private var monthDates: [Date] {
        // Проверка диапазона дней в текущем месяце
        guard let range = calendar.range(of: .day, in: .month, for: currentDate) else { return [] }
        // Возвращаем даты для каждого дня месяца
        return range.map { calendar.date(byAdding: .day, value: $0 - 1, to: startOfMonth)! }
    }
    
    // Начало месяца (1-е число)
    private var startOfMonth: Date {
        return calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
    }
    
    // Начало недели для выбранной даты
    private var startOfWeek: Date {
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: selectedDate))!
    }
    
    // Текущий месяц
    private var currentMonth: Date {
        return calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
    }
    
    // Фильтрация дней тренировок для текущего месяца
    private var workoutDaysInCurrentMonth: [Date] {
        workoutDays.compactMap { workoutDay in
            if let date = workoutDay.date {
                return calendar.isDate(date, equalTo: currentMonth, toGranularity: .month) ? date : nil
            } else {
                return nil
            }
        }
    }
    
    
    private func hasWorkout(on date: Date) -> Bool {
        workoutDaysInCurrentMonth.contains { calendar.isDate($0, inSameDayAs: date) }
    }
    
    var body: some View {
        VStack {
            if isExpanded {
                expandedView // Если виджет развернут, показываем развернутый вид
            } else {
                collapsedView // Если виджет свернут, показываем свернутый вид
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Unavailable"),
                message: Text("This range is not available for selection."),
                dismissButton: .default(Text("OK"))
            )
        }
        .animation(.easeInOut(duration: 0.3), value: transitionState)
    }
    
    // Развернутый вид с полным календарем
    private var expandedView: some View {
        VStack {
            headerView // Заголовок с кнопками для перехода между месяцами
            daysOfWeekView // Отображение дней недели
            monthDaysView // Отображение дней текущего месяца
        }
    }
    
    // Свернутый вид, показывающий только текущую неделю
    private var collapsedView: some View {
        VStack {
            headerView // Заголовок с кнопками для перехода между месяцами
            daysOfWeekView // Отображение дней недели
            currentWeekView // Отображение дней текущей недели
        }
    }
    
    // Заголовок с названием месяца и кнопками для перехода между месяцами и неделями
       private var headerView: some View {
           HStack {
               if isExpanded {
                   
                   // Блок с движением по месяцу
                   
                   Button(action: { moveMonth(by: -1) }) {
                       Image(systemName: "chevron.left")
                           .font(.system(size: 20, weight: .bold))
                           .foregroundColor(Color("ButtonColor"))
                   }
                   Spacer()
                   Text(currentDate, formatter: monthFormatter)
                       .font(.system(size: 20))
                       .foregroundColor(Color("TextColor"))
                   Spacer()
                   Button(action: {
                       currentDate = Date()
                       selectedDate = Date()
                   }) {
                       Text("Today")
                           .font(.system(size: 16))
                           .foregroundColor(Color("ButtonColor"))
                       Image(systemName: "calendar")
                           .font(.title)
                           .foregroundColor(Color("ButtonColor"))
                   }
                   Spacer()
                   Button(action: { moveMonth(by: 1) }) {
                       Image(systemName: "chevron.right")
                           .font(.system(size: 20, weight: .bold))
                           .foregroundColor(Color("ButtonColor"))
                   }
                   
                // Блок с движением по неделе
               } else {
                   Button(action: { moveWeek(by: -1) }) {
                       Image(systemName: "chevron.left")
                           .font(.system(size: 20, weight: .bold))
                           .foregroundColor(Color("ButtonColor"))
                   }
                   Spacer()
                   Text(currentDate, formatter: weekFormatter)
                       .font(.system(size: 20))
                       .foregroundColor(Color("TextColor"))
                   Spacer()
                   Button(action: {
                       currentDate = Date()
                       selectedDate = Date()
                   }) {
                       Text("Today")
                           .font(.system(size: 16))
                           .foregroundColor(Color("ButtonColor"))
                       Image(systemName: "calendar")
                           .font(.title)
                           .foregroundColor(Color("ButtonColor"))
                   }
                   Spacer()
                   Button(action: { moveWeek(by: 1) }) {
                       Image(systemName: "chevron.right")
                           .font(.system(size: 20, weight: .bold))
                           .foregroundColor(Color("ButtonColor"))
                   }
               }
           }
           .padding(.bottom, 15)
       }
    
    // Отображение дней недели
    private var daysOfWeekView: some View {
        HStack {
            ForEach(shiftedDaysOfWeek, id: \.self) { day in
                Text(day)
                    .font(.system(size: 16))
                    .foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 10)
    }
    
    // Сдвигаем дни недели, чтобы понедельник был первым
    private var shiftedDaysOfWeek: [String] {
        let days = calendar.shortWeekdaySymbols
        let firstWeekday = calendar.firstWeekday
        let shiftedDays = days.dropFirst(firstWeekday - 1) + days.prefix(firstWeekday - 1)
        return shiftedDays.map { $0.uppercased() }
    }
    
    let offsetNumber: CGFloat = 27
    
    // Отображение текущей недели
    private var currentWeekView: some View {
        let start = calendar.dateInterval(of: .weekOfMonth, for: selectedDate)!.start
        let dates = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }

        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(dates, id: \.self) { date in
                let day = "\(calendar.component(.day, from: date))"
                ZStack { // Используем ZStack для наложения точки на число
                    Text(day)
                        .font(.system(size: 20))
                        .fontWeight(date == selectedDate ? .bold : .regular)
                        .foregroundColor(Color("TextColor"))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(
                            Group {
                                if day == "\(calendar.component(.day, from: Date()))" {
                                    Circle().stroke(Color("ButtonColor"), lineWidth: 2).frame(width: 40, height: 40)
                                }
                                if day == "\(calendar.component(.day, from: selectedDate))" {
                                    Circle().fill(Color("ButtonColor")).frame(width: 40, height: 40)
                                }
                            }
                        )
                    
                    // Точка показывающая существование трен дня в дате
                    if hasWorkout(on: date) {
                        Circle()
                      
                            .fill(Color("ViewColor2"))
                            .frame(width: 6, height: 6)
                            .offset(y: offsetNumber) // Сдвиг точки вниз
                    }
                }
                .padding(.bottom, 10)
                .onTapGesture {
                    selectedDate = date
                    print("Selected date: \(selectedDate)")
                }
            }
        }
    }

    private var monthDaysView: some View {
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!
        let firstWeekday = (calendar.component(.weekday, from: startOfMonth) - calendar.firstWeekday + 7) % 7
        let days = (0..<firstWeekday).map { _ in "" } + daysInMonth.map { "\($0)" }
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 33) {
            ForEach(days, id: \.self) { day in
                ZStack {
                    Text(day)
                        .font(.system(size: 20))
                        .fontWeight(day == "\(calendar.component(.day, from: selectedDate))" ? .bold : .regular)
                        .foregroundColor(Color("TextColor"))
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(
                            Group {
                                if day == "\(calendar.component(.day, from: Date()))" {
                                    Circle().stroke(Color("ButtonColor"), lineWidth: 2).frame(width: 40, height: 40)
                                }
                                if day == "\(calendar.component(.day, from: selectedDate))" {
                                    Circle().fill(Color("ButtonColor")).frame(width: 40, height: 40)
                                }
                            }
                        )
                    
                    // Точка показывающая существование трен дня в дате
                    if let dayInt = Int(day), hasWorkout(on: calendar.date(bySetting: .day, value: dayInt, of: currentMonth)!) {
                        Circle()
                            .fill(Color("ViewColor2"))
                            .frame(width: 6, height: 6)
                            .offset(y: offsetNumber) // Сдвиг точки вниз
                    }
                }
                .onTapGesture {
                    if !day.isEmpty {
                        let dayInt = Int(day)!
                        selectedDate = calendar.date(bySetting: .day, value: dayInt, of: currentMonth)!
                        print("Selected date: \(selectedDate)")
                    }
                }
            }
        }
    }
    
    private func moveMonth(by value: Int) {
            if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
                if newDate >= minDate && newDate <= maxDate {
                    currentDate = newDate
                } else {
                    showAlert = true
                }
            }
        }
        
        private func moveWeek(by value: Int) {
            if let newDate = calendar.date(byAdding: .weekOfMonth, value: value, to: selectedDate) {
                selectedDate = newDate
                currentDate = calendar.date(from: calendar.dateComponents([.year, .month], from: newDate))!
            }
        }
    
    // Форматтер для отображения месяца и года
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy" // Формат отображения: Месяц Год
        return formatter
    }
    
    private var weekFormatter: DateFormatter {
          let formatter = DateFormatter()
          formatter.dateFormat = "d MMMM yyyy"
          return formatter
      }
}
