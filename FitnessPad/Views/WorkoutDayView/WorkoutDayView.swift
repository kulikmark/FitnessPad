//
//  TrainingsListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.04.2022.
//

import SwiftUI
import CoreData

struct WorkoutDayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: WorkoutViewModel
    
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
            //                .padding(.bottom, 50)
            //                .frame(maxHeight: .infinity)
            .simultaneousGesture(TapGesture().onEnded {
                UIApplication.shared.endEditing(true)
                viewModel.saveContext()
            })
            
            // ✅ WorkoutdayMiniView
            VStack {
                Spacer()
                DaysMiniView(selectedDate: $selectedDate, selectedIndex: $selectedIndex)
                    .padding(.bottom, 30)
                    .background(Color("ViewColor"))
                    .onTapGesture {
                        isCalendarPresented.toggle()
                    }
                    .sheet(isPresented: $isCalendarPresented) {
                        CalendarView(selectedDate: $selectedDate, selectedIndex: $selectedIndex)
                            .environmentObject(viewModel)
                    }
            }
            
            
        }
        .onAppear {
            selectedDate = Calendar.current.startOfDay(for: Date())
        }
        .onChange(of: selectedDate) { _, newDate in
            viewModel.fetchWorkoutDays() // Обновляем данные при изменении даты
        }
    
 
    }
    
    private var exercisesListView: some View {
        ExercisesListView(selectedDate: $selectedDate)
    }
    
    
    struct DaysMiniView: View {
        @EnvironmentObject var viewModel: WorkoutViewModel
        @Binding var selectedDate: Date
        @Binding var selectedIndex: Int
        
        var body: some View {
            VStack {
                if viewModel.workoutDay(for: selectedDate) != nil {
                    TabView(selection: $selectedIndex) {
                        ForEach(viewModel.sortedWorkoutDays.indices, id: \.self) { index in
                            dayMiniViewItem(for: viewModel.sortedWorkoutDays[index])
                                .padding(.horizontal, 20)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: selectedIndex)
                } else {
                    emptyTabView()
                }
            }
            .background(Color("ViewColor"))
            .frame(height: 65)
            .cornerRadius(15, corners: [.topLeft, .topRight])
            .onAppear {
                updateSelectedIndexForCurrentDate()
            }
            .onChange(of: selectedIndex) { oldIndex, newIndex in
                let newWorkoutDay = viewModel.sortedWorkoutDays[newIndex]
                selectedDate = newWorkoutDay.date ?? Date()
            }
            .onChange(of: selectedDate) { _, newDate in
                updateSelectedIndexForDate(newDate)
            }
        }
        
        private func updateSelectedIndexForCurrentDate() {
            
            if let todayWorkoutDay = viewModel.workoutDay(for: Date()) {
                updateSelectedIndexForDate(todayWorkoutDay.date ?? Date())
            }
        }
        
        
        private func updateSelectedIndexForDate(_ date: Date) {
            if let index = viewModel.sortedWorkoutDays.firstIndex(where: { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }) {
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
                    // Отображаем дату
                    Text(workoutDay.date?.formattedDate() ?? "Unknown Date")
                        .font(.system(size: 16))
                        .foregroundColor(Color("ButtonTextColor"))
                    
                    // Отображаем день недели (например, "WED")
                    Text(workoutDay.date?.formattedDayOfWeek() ?? "N/A")
                        .font(.system(size: 16))
                        .foregroundColor(Color("ButtonTextColor"))
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color("ButtonColor"))
            .cornerRadius(10)
        }
        
        func emptyTabView() -> some View {
            HStack {
                Text("Tap to open Calendar")
                    .font(.system(size: 16))
                    .foregroundColor(.text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
            }
            .frame(maxWidth: .infinity)
            .background(Color("ViewColor"))
            .frame(height: 60)
            .cornerRadius(15, corners: [.topLeft, .topRight])
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
