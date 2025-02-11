//
//  TrainingsListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.04.2022.
//

import SwiftUI
import CoreData

import SwiftUI

struct WorkoutDayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: WorkoutDayViewModel
    
    @State var selectedDate: Date = .now
    @State private var selectedIndex: Int = 0
    @State private var isCalendarPresented: Bool = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                if viewModel.workoutDay(for: selectedDate) != nil {
                    WorkoutDayViewHeaderView(selectedDate: $selectedDate)
                    exercisesListView
                } else {
                    EmptyWorkoutDayView(selectedDate: $selectedDate)
                }
            }

            VStack {
                Spacer()
                DaysMiniView(selectedDate: $selectedDate, selectedIndex: $selectedIndex)
                    .padding(.bottom, 50)
                    .onTapGesture {
                        isCalendarPresented.toggle()
                    }
                    .sheet(isPresented: $isCalendarPresented) {
                        CalendarView(selectedDate: $selectedDate, selectedIndex: $selectedIndex)
                            .environmentObject(viewModel)
                            .onChange(of: selectedDate) { _, newDate in
                                        // Когда выбранная дата изменяется, обновляем selectedIndex
                                        if let index = viewModel.sortedWorkoutDays.firstIndex(where: { $0.date == newDate }) {
                                            selectedIndex = index
                                        }
                                    }
                    }
            }
        }
        .onAppear {
            selectedDate = Calendar.current.startOfDay(for: Date())
            updateSelectedIndex(for: selectedDate) // Инициализация индекса при старте
        }
        .onChange(of: selectedDate) { _, newDate in
            if let index = viewModel.sortedWorkoutDays.firstIndex(where: { $0.date == newDate }) {
                selectedIndex = index // Обновляем индекс при изменении даты
            }
        }

        // При создании тренировки TabView отображает дату этой созданной тренировки
        .onChange(of: viewModel.sortedWorkoutDays) {
            if let workoutDay = viewModel.workoutDay(for: selectedDate),
               let index = viewModel.sortedWorkoutDays.firstIndex(where: { $0.id == workoutDay.id }) {
                selectedIndex = index
            }
        }
    }
    
    private func updateSelectedIndex(for date: Date) {
        if let workoutDay = viewModel.workoutDay(for: date),
           let index = viewModel.sortedWorkoutDays.firstIndex(where: { $0.id == workoutDay.id }) {
            selectedIndex = index
        }
    }
    
    private var exercisesListView: some View {
        ExercisesListView(selectedDate: $selectedDate)
    }
    
    struct DaysMiniView: View {
        @EnvironmentObject var viewModel: WorkoutDayViewModel
        @Binding var selectedDate: Date
        @Binding var selectedIndex: Int
        
        var body: some View {
            VStack {
                if viewModel.workoutDay(for: selectedDate) != nil {
                    TabView(selection: $selectedIndex) {
                        ForEach(viewModel.sortedWorkoutDays.indices, id: \.self) { index in
                            dayMiniViewItem(for: viewModel.sortedWorkoutDays[index])
                               
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: selectedIndex)
                    .onChange(of: selectedIndex) { _, newIndex in
                        if newIndex < viewModel.sortedWorkoutDays.count {
                            let selectedWorkoutDay = viewModel.sortedWorkoutDays[newIndex]
                            selectedDate = selectedWorkoutDay.date ?? Date()
                        }
                    }

                } else {
                    emptyTabView()
                }
            }
            .frame(height: 60)
        }
        
        private func updateSelectedIndex(for date: Date) {
            if let workoutDay = viewModel.workoutDay(for: date),
               let index = viewModel.sortedWorkoutDays.firstIndex(where: { $0.id == workoutDay.id }) {
                selectedIndex = index
            }
        }
        
        func dayMiniViewItem(for workoutDay: WorkoutDay) -> some View {
            HStack {
                Image("miniView")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipped()
                    .padding(.leading, 10)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 4) {
                    Text("Тренировка:")
                        .font(.system(size: 14))
                        .foregroundColor(Color("ButtonTextColor"))
                    Text(workoutDay.date?.formattedDate() ?? NSLocalizedString("unknown_date", comment: ""))
                        .font(.system(size: 14))
                        .foregroundColor(Color("ButtonTextColor"))
                    Text(workoutDay.date?.formattedDayOfWeek() ?? "N/A")
                        .font(.system(size: 14))
                        .foregroundColor(Color("ButtonTextColor"))
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color("ButtonColor"))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        
        func emptyTabView() -> some View {
            HStack {
                Text(NSLocalizedString("tap_to_open_calendar", comment: ""))
                    .font(.system(size: 16))
                    .foregroundColor(Color("ButtonTextColor"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("ButtonColor"))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
    }
}



//// Нет тренировки
//struct WorkoutDaysList_Previews: PreviewProvider {
//    @State static var workoutDay: WorkoutDay? = nil
//    static var previews: some View {
//        WorkoutDaysList(viewModel: WorkoutViewModel(), workoutDay: $workoutDay)
//    }
//}

//// Есть тренировки
//struct WorkoutDaysList_Previews: PreviewProvider {
//    @State static var workoutDay: WorkoutDay? = {
//        // Создаем объект WorkoutDay для примера
//        let context = PersistenceController.shared.container.viewContext
//        let workoutDay = WorkoutDay(context: context)
//        workoutDay.date = Date() // Устанавливаем текущую дату для примера
//        // Сохраняем в Core Data (для работы с Preview)
//        try? context.save()
//        return workoutDay
//    }()
//
//    @State static var viewModel = WorkoutViewModel()
//
//    static var previews: some View {
//        WorkoutDaysList(viewModel: viewModel, workoutDay: $workoutDay)
//            .onAppear {
//                // Сымитировать загрузку тренировочных дней
//                viewModel.cacheWorkoutDays(from: [workoutDay!])
//            }
//            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//    }
//}
