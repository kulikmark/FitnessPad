//
//  TrainingsListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.04.2022.
//

import SwiftUI
import CoreData

struct WorkoutDaysList: View {
    
    @StateObject var viewModel: WorkoutViewModel
    @Binding var workoutDay: WorkoutDay?
    
    @State var selectedMonth: Date = .currentMonth
    @State var selectedDate: Date = .now
    //        var safeArea: EdgeInsets
    
    var safeArea: EdgeInsets = EdgeInsets()
    
    var body: some View {
        
        let maxHeight = calendarHeight - (calendarTitleViewHeight + weekDayLabelHeight + safeArea.top + 50  + topPadding + bottomPadding - 50)
        
        ZStack {
            // Фон под всеми вью
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            // Содержание
            ScrollView (.vertical) {
                ZStack {
                    VStack(spacing: 20) {
                        CalendarView()
                        //                               WorkoutDayDetailsView(viewModel: viewModel, workoutDay: $workoutDay)
                        //                                   .frame(height: 650)
                        
                        if workoutDay == nil {
                            emptyWorkoutDayView
                        } else {
                            WorkoutDayDetailsView(viewModel: viewModel, workoutDay: $workoutDay)
                                .frame(height: 650)
                        }
                    }
                }
            }
            .onAppear {
                
                // Добавляем проверку для выбранной даты
                    if let existingWorkoutDay = viewModel.workoutDay(for: selectedDate) {
                        workoutDay = existingWorkoutDay
                    } else {
                        workoutDay = nil
                    }
                
            }
        }
        
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(CustomScrollBehaviour(maxHeight: maxHeight))
        
    }
    
    var emptyWorkoutDayView: some View {
        VStack(spacing: 0) {
            Image("emptyWorkoutDay")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: 150)
            
            Text("No workout days created yet.")
                .foregroundColor(.white)
                .padding()
            
            Button(action: {
                createWorkoutDay()
            }) {
                Text("Create Workout")
                    .font(.title2)
                    .foregroundColor(Color("TextColor"))
                    .padding(15)
                    .background(Color("ButtonColor"))
                    .cornerRadius(10)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //           .frame(height: 700)
        .background(Color("BackgroundColor"))
    }
    
    func createWorkoutDay() {
        // Создаем новый объект WorkoutDay
        let newWorkoutDay = WorkoutDay(context: viewModel.viewContext)
        newWorkoutDay.date = selectedDate
        
        // Сохраняем в CoreData
        viewModel.saveContext()
        
        // Обновляем workoutDay, чтобы отобразить экран деталей
        workoutDay = newWorkoutDay
    }
    
    
    @ViewBuilder
    func CalendarView() -> some View {
        GeometryReader {
            let size = $0.size
            let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
            
            let maxHeight = size.height - (calendarTitleViewHeight + weekDayLabelHeight + safeArea.top + 50  + topPadding + bottomPadding - 50)
            let progress = max(min((-minY / maxHeight), 1), 0)
            
            VStack (alignment: .leading,spacing: 0, content: {
                Text(currentMonth)
                    .font(.system(size: 35 - (10 * progress)))
                    .offset(y: -50 * progress)
                    .frame(maxHeight: .infinity, alignment: .bottom )
                    .overlay(alignment: .topLeading, content: {
                        GeometryReader {
                            let size = $0.size
                            
                            Text(currentYear)
                                .font(.system(size: 25 - (10 * progress)))
                                .offset(x: (size.width + 5) * progress, y: progress * 3)
                        }
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .topTrailing, content: {
                        HStack(spacing: 15) {
                            Button("", systemImage: "arrow.trianglehead.counterclockwise.rotate.90") {
                                resetToCurrentDate()
                            }
                            .contentShape(.rect)
                            Button("", systemImage: "chevron.left") {
                                /// Update to prev month
                                monthUpdate(false)
                            }
                            .contentShape(.rect)
                            Button("", systemImage: "chevron.right") {
                                /// Update to next month
                                monthUpdate(true)
                            }
                            .contentShape(.rect)
                        }
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .offset(x: progress * 150)
                    })
                    .frame(height: calendarTitleViewHeight)
                
                VStack(spacing: 0) {
                    /// Weekdays
                    HStack(spacing:0) {
                        ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { symbol in
                            Text(symbol.prefix(3))
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(height: weekDayLabelHeight, alignment: .bottom)
                    
                    
                    /// Calendar Grid View
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0, content: {
                        ForEach(selectedMonthDates) { day in
                            Text(day.shortSymbol)
                                .foregroundStyle(day.ignored ? .secondary : .primary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .overlay {
                                    if Calendar.current.isDate(day.date, inSameDayAs: selectedDate) {
                                        // Выделенная дата - обводка
                                        Circle()
                                            .strokeBorder(Color.white, lineWidth: 1)
                                            .frame(width: 40, height: 40)
                                            .offset(y: progress * -1)
                                    } else if viewModel.workoutDay(for: day.date) != nil {
                                        // Даты с тренировками - круг
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 5, height: 5)
                                            .padding(.top, 30)
                                            .offset(y: progress * -1)
                                    }
                                }
                                .contentShape(.rect)
                                .onTapGesture {
                                    selectedDate = day.date
                                    
                                    if let existingWorkoutDay = viewModel.workoutDay(for: day.date) {
                                        workoutDay = existingWorkoutDay
                                    } else {
                                        workoutDay = nil
                                    }
                                }
                        }
                    })

                    .frame(height: calendarGridHeight - ((calendarGridHeight - 50) * progress), alignment: .top)
                    .offset(y: (monthProgress * -50) * progress)
                    .contentShape(.rect)
                    .clipped()
                }
                .offset(y: progress * -50)
                
            })
            .foregroundStyle(.white)
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.top, safeArea.top)
            .padding(.bottom, bottomPadding)
            .frame(maxHeight: .infinity)
            .frame(height: size.height - (maxHeight * progress), alignment: .top)
            //            .background(.red.gradient)
            .background(Color("ViewColor"))
            .cornerRadius(10)
            
            .clipped()
            .contentShape(.rect)
            .offset(y: -minY)
            
        }
        .frame(height: calendarHeight)
        .zIndex(1000)
    }
    
    func resetToCurrentDate() {
        let today = Date()
        selectedDate = today
        selectedMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: today)) ?? today
    }
    
    func format (_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: selectedMonth)
    }
    
    /// Month increment / decrement
    func monthUpdate(_ increment: Bool = true) {
        let calendar = Calendar.current
        guard let month = calendar.date(byAdding: .month, value: increment ? 1 : -1, to: selectedMonth) else { return }
        guard let date = calendar.date(byAdding: .month, value: increment ? 1 : -1, to: selectedDate) else { return }
        selectedMonth = month
        selectedDate = date
    }
    
    /// Selected Month Dates
    var selectedMonthDates: [Day] {
        return extractDates(selectedMonth)
    }
    
    var currentMonth: String {
        return format("MMMM")
    }
    
    var currentYear: String {
        return format("YYYY")
    }
    
    var monthProgress: CGFloat {
        let calendar = Calendar.current
        if let index = selectedMonthDates.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: selectedDate) }) {
            
            return CGFloat(index / 7).rounded()
        }
        return 1
    }
    
    var calendarHeight: CGFloat {
        return calendarTitleViewHeight + weekDayLabelHeight + calendarGridHeight + safeArea.top + topPadding + bottomPadding
    }
    
    var calendarTitleViewHeight: CGFloat {
        return 75
    }
    
    var weekDayLabelHeight: CGFloat {
        return 30
    }
    
    var calendarGridHeight: CGFloat {
        return CGFloat(selectedMonthDates.count / 7) * 50
    }
    
    var horizontalPadding: CGFloat {
        return 15
    }
    
    var topPadding: CGFloat {
        return 15
    }
    
    var bottomPadding: CGFloat {
        return 5
    }
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

extension View {
    
    /// Extracting Dates
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
            guard let date = calendar.date(byAdding: .day, value: -index - 1, to: range.first!) else {return days}
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
                guard let date = calendar.date(byAdding: .day, value: index + 1, to: range.last!) else {return days}
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

struct CustomScrollBehaviour: ScrollTargetBehavior {
    var maxHeight: CGFloat
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < maxHeight {
            target.rect = .zero
        }
    }
}


struct WorkoutDaysList_Previews: PreviewProvider {
    @State static var workoutDay: WorkoutDay? = nil
    static var previews: some View {
        WorkoutDaysList(viewModel: WorkoutViewModel(), workoutDay: $workoutDay)
    }
}


// MARK: - ORIGINAL CODE

//@ViewBuilder
//func CalendarView() -> some View {
//    GeometryReader {
//        let size = $0.size
//        let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
//
//        let maxHeight = size.height - (calendarTitleViewHeight + weekDayLabelHeight + safeArea.top + 50  + topPadding + bottomPadding - 50)
//        let progress = max(min((-minY / maxHeight), 1), 0)
//
//        VStack (alignment: .leading,spacing: 0, content: {
//            Text(currentMonth)
//                .font(.system(size: 35 - (10 * progress)))
//                .offset(y: -50 * progress)
//                .frame(maxHeight: .infinity, alignment: .bottom )
//                .overlay(alignment: .topLeading, content: {
//                    GeometryReader {
//                        let size = $0.size
//
//                        Text(currentYear)
//                            .font(.system(size: 25 - (10 * progress)))
//                            .offset(x: (size.width + 5) * progress, y: progress * 3)
//                    }
//                })
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .overlay(alignment: .topTrailing, content: {
//                    HStack(spacing: 15) {
//                        Button("", systemImage: "chevron.left") {
//                            /// Update to prev month
//                            monthUpdate(false)
//                        }
//                        .contentShape(.rect)
//                        Button("", systemImage: "chevron.right") {
//                            /// Update to next month
//                            monthUpdate(true)
//                        }
//                        .contentShape(.rect)
//                    }
//                    .font(.title3)
//                    .foregroundStyle(.primary)
//                    .offset(x: progress * 150)
//                })
//                .frame(height: calendarTitleViewHeight)
//
//            VStack(spacing: 0) {
//                /// Weekdays
//                HStack(spacing:0) {
//                    ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { symbol in
//                        Text(symbol.prefix(3))
//                            .font(.caption)
//                            .frame(maxWidth: .infinity)
//                            .foregroundStyle(.secondary)
//                    }
//                }
//                .frame(height: weekDayLabelHeight, alignment: .bottom)
//
//                /// Calendar Grid View
//                LazyVGrid(columns: Array(repeating: GridItem(spacing:0), count: 7), spacing: 0, content: {
//                    ForEach(selectedMonthDates) { day in
//                        Text(day.shortSymbol)
//                            .foregroundStyle(day.ignored ? .secondary : .primary)
//                            .frame(maxWidth: . infinity)
//                            .frame(height: 50)
//                            .overlay(alignment: .bottom, content: {
//                                Circle()
//                                    .fill(.white)
//                                    .frame(width: 5, height: 5)
//                                    .opacity(Calendar.current.isDate(day.date, inSameDayAs: selectedDate) ? 1 : 0)
//                                    .offset(y: progress * -1)
//                            })
//                            .contentShape(.rect)
//                            .onTapGesture {
//                                selectedDate = day.date
//                            }
//                    }
//                })
//                .frame(height: calendarGridHeight - ((calendarGridHeight - 50) * progress), alignment: .top)
//                .offset(y: (monthProgress * -50) * progress)
//                .contentShape(.rect)
//                .clipped()
//            }
//            .offset(y: progress * -50)
//
//        })
//        .foregroundStyle(.white)
//        .padding(.horizontal, horizontalPadding)
//        .padding(.top, topPadding)
//        .padding(.top, safeArea.top)
//        .padding(.bottom, bottomPadding)
//        .frame(maxHeight: .infinity)
//        .frame(height: size.height - (maxHeight * progress), alignment: .top)
//        .background(.red.gradient)
//        .cornerRadius(10)
//
//        .clipped()
//        .contentShape(.rect)
//        .offset(y: -minY)
//
//    }
//    .frame(height: calendarHeight)
//    .zIndex(1000)
//
//
//
//}
