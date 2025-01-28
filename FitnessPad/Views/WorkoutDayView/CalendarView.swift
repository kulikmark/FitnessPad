//
//  CalendarView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 09.01.2025.
//
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var viewModel: WorkoutViewModel
    //    @Binding var workoutDay: WorkoutDay?
    @State var selectedMonth: Date = .currentMonth
    @Binding var selectedDate: Date
    @Binding var selectedIndex: Int
    
    @State private var isShowingExercisesView = false
    
    @Environment(\.presentationMode) var presentationMode
   

    // Месяц и год
    private var currentMonth: String {
        return format("MMMM")
    }
    
    private var currentYear: String {
        return format("YYYY")
    }
    
    private var calendarHeight: CGFloat {
        return calendarTitleViewHeight + weekDayLabelHeight + calendarGridHeight
    }
    
    private var calendarTitleViewHeight: CGFloat { 40 }
    private var weekDayLabelHeight: CGFloat { 30 }
    private var calendarGridHeight: CGFloat {
        return CGFloat(selectedMonthDates.count / 7) * 50
    }
    private var horizontalPadding: CGFloat { 15 }
    private var circleSize: CGFloat { 33 }
    
    private var selectedMonthDates: [Day] {
        return extractDates(selectedMonth)
    }
    
    // Содержимое календаря
    var body: some View {
            ZStack {
                Color("ViewColor")
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 0) {
                    headerView
                    
                    VStack(spacing: 0) {
                        weekdayLabelsView
                        calendarGridView
                    }
                    
                    HStack {
                        // Кнопка добавления упражнений или создания тренировки
                        Button(action: {
                            isShowingExercisesView = true
                        }) {
                            Text(viewModel.workoutDay(for: selectedDate) == nil ? "Create workout and add exercises" : "Add exercises")
                                .font(.system(size: 16))
                                .foregroundColor(Color("ButtonTextColor"))
                                .frame(maxWidth: .infinity)
                                .padding(15)
                                .background(Color("ButtonColor"))
                                .cornerRadius(10)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, horizontalPadding)
                .frame(maxHeight: .infinity)
                .background(Color("ViewColor"))
                .cornerRadius(10)
                .clipped()
                .contentShape(.rect)
                .frame(height: calendarHeight)
                .zIndex(1000)
                .gesture(dragGesture)
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $isShowingExercisesView, onDismiss: {
                presentationMode.wrappedValue.dismiss()
            }) {
                ExercisesView(isFromWokroutDayView: true, selectedDate: selectedDate) // Передаем selectedDate
                    .environmentObject(viewModel)
            }
        }
    
    
    // Заголовок календаря
    private var headerView: some View {
        HStack {
            // Месяц и год
            HStack(spacing: 4) {
                Text(currentMonth)
                    .foregroundStyle(Color("TextColor"))
                    .font(.system(size: 25))
                
                Text(currentYear)
                    .foregroundStyle(Color("TextColor"))
                    .font(.system(size: 25))
            }
        }
        .frame(height: calendarTitleViewHeight)
        .padding(.top, 10)
    }
    
    // Дни недели
    private var weekdayLabelsView: some View {
        HStack(spacing: 0) {
            ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { symbol in
                Text(symbol.prefix(3))
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color("TextColor"))
            }
        }
        .frame(height: weekDayLabelHeight, alignment: .bottom)
    }
    
    // Сетка календаря
    private var calendarGridView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
            ForEach(selectedMonthDates) { day in
                Text(day.shortSymbol)
                    .foregroundStyle(day.ignored ? .secondary : Color("TextColor"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay(calendarDateOverlay(for: day))
                    .contentShape(.rect)
                    .onTapGesture {
                        selectedDate = day.date
                    }
            }
        }
    }
    
    private func calendarDateOverlay(for day: Day) -> some View {
        Group {
            // Кружок для выбранной даты
            if Calendar.current.isDate(day.date, inSameDayAs: selectedDate) {
                Circle()
                    .strokeBorder(Color("TextColor"), lineWidth: 2)
                    .frame(width: circleSize, height: circleSize)
            }
            
            let hasWorkoutDay = viewModel.workoutDay(for: day.date) != nil
            
            HStack(spacing: 2) {
                if hasWorkoutDay {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 5, height: 5)
                }
            }
            .padding(.top, 50)
            
            
            // Кружок для текущей даты (если она не выбрана)
            if Calendar.current.isDate(day.date, inSameDayAs: Date()) && day.date != selectedDate {
                Circle()
                    .fill(Color("TextColor").opacity(0.1))
                    .frame(width: circleSize, height: circleSize)
            }
        }
        }
    
    // Обработчик свайпа для изменения месяца
    private var dragGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                if value.translation.width < 0 {
                    monthUpdate(true) // Следующий месяц
                } else if value.translation.width > 0 {
                    monthUpdate(false) // Предыдущий месяц
                }
            }
    }
    
    // Обновление месяца
    private func monthUpdate(_ increment: Bool = true) {
        let calendar = Calendar.current
        guard let month = calendar.date(byAdding: .month, value: increment ? 1 : -1, to: selectedMonth),
              let date = calendar.date(byAdding: .month, value: increment ? 1 : -1, to: selectedDate) else { return }
        selectedMonth = month
        selectedDate = date
    }
    
    // Сброс к текущей дате
    func resetToCurrentDate() {
        let today = Date()
        selectedDate = today
        selectedMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: today)) ?? today
    }
    
    // Форматирование даты
    private func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: selectedMonth)
    }
    
    // Экстракция дней месяца
    func extractDates(_ month: Date) -> [Day] {
        var days: [Day] = []
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        guard let range = calendar.range(of: .day, in: .month, for: month)?.compactMap({ value -> Date? in
            return calendar.date(byAdding: .day, value: value - 1, to: month)
        }) else { return days }
        
        let firstWeekDay = calendar.component(.weekday, from: range.first!)
        
        for index in Array(0..<firstWeekDay - 1).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -index - 1, to: range.first!) else { return days }
            let shortSymbol = formatter.string(from: date)
            days.append(.init(shortSymbol: shortSymbol, date: date, ignored: true))
        }
        
        range.forEach { date in
            let shortSymbol = formatter.string(from: date)
            days.append(.init(shortSymbol: shortSymbol, date: date))
        }
        
        let lastWeekDay = 7 - calendar.component(.weekday, from: range.last!)
        if lastWeekDay > 0 {
            for index in 0..<lastWeekDay {
                guard let date = calendar.date(byAdding: .day, value: index + 1, to: range.last!) else { return days }
                let shortSymbol = formatter.string(from: date)
                days.append(.init(shortSymbol: shortSymbol, date: date, ignored: true))
            }
        }
        return days
    }
}

struct Day: Identifiable {
    var id: UUID = .init()
    var shortSymbol: String
    var date: Date
    var ignored: Bool = false
}

extension Date {
    static var currentMonth: Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(from: Calendar.current.dateComponents([.month, .year], from: .now)) else {
            return .now
        }
        return currentMonth
    }
    
}


//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Пример данных для viewModel
//        let viewModel = WorkoutViewModel()
//
//        let selectedDate = Date()
//
//        // Пример данных для workoutDay (здесь используем пустое значение, можно заменить на тестовое)
//        let workoutDay = WorkoutDay(context: viewModel.viewContext)
//        workoutDay.date = Date()
//
//        return CalendarView(viewModel: viewModel, workoutDay: .constant(workoutDay), selectedDate: $selectedDate)
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
