//
//  TrainingsListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.04.2022.
//

import SwiftUI
import CoreData

import Combine

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(Publishers.keyboardHeight) { height in
                self.keyboardHeight = height
            }
            .animation(.easeOut(duration: 0.16), value: keyboardHeight)
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
            }
        
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

struct WorkoutDaysList: View {
    
    @StateObject var viewModel: WorkoutViewModel
    @Binding var workoutDay: WorkoutDay?
    
    @State var selectedDate: Date = .now
    @State private var selectedIndex: Int = 0
    @State private var isCalendarPresented: Bool = false

    var body: some View {
        ZStack {
            // Фон
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                if let workoutDay = viewModel.workoutDay(for: selectedDate) {
                    WorkoutDayDetailsView(viewModel: viewModel, workoutDay: Binding.constant(workoutDay))
                        .padding(.bottom, 50)
                        .frame(maxHeight: .infinity)
                } else {
                    EmptyWorkoutDayView(selectedDate: $selectedDate)
                        .frame(maxHeight: .infinity)
                }
                
                Spacer()
            }
            .onAppear {
                selectedDate = Calendar.current.startOfDay(for: Date())
            }
            
            // ✅ WorkoutdayMiniView фиксирован внизу
            VStack {
                Spacer()
                WorkoutdayMiniView(viewModel: viewModel, selectedDate: $selectedDate, selectedIndex: $selectedIndex)
                    .padding(.bottom, 30)
                    .background(Color("ViewColor"))
                    .onTapGesture {
                        isCalendarPresented.toggle()
                    }
                    .sheet(isPresented: $isCalendarPresented) {
                        CalendarView(viewModel: viewModel, workoutDay: $workoutDay, selectedDate: $selectedDate, selectedIndex: $selectedIndex)
                    }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom) // ⬅️ Игнорируем клавиатуру
        }
    }

    
    
    struct WorkoutdayMiniView: View {
        @ObservedObject var viewModel: WorkoutViewModel
        @Binding var selectedDate: Date
        @Binding var selectedIndex: Int
        
        var body: some View {
            VStack {
                // Проверка, есть ли тренировка для выбранной даты
                if viewModel.workoutDay(for: selectedDate) != nil, !viewModel.sortedWorkoutDays.isEmpty {
                    TabView(selection: $selectedIndex) {
                        ForEach(viewModel.sortedWorkoutDays.indices, id: \.self) { index in
                            miniViewItem(for: viewModel.sortedWorkoutDays[index])
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
            // Обновляем дату при изменении индекса
            .onChange(of: selectedIndex) { oldIndex, newIndex in
                let newWorkoutDay = viewModel.sortedWorkoutDays[newIndex]
                selectedDate = newWorkoutDay.date ?? Date()
            }
            // Обновляем индекс при изменении даты
            .onChange(of: selectedDate) { _, newDate in
                updateSelectedIndexForDate(newDate)
            }
        }
        
        private func updateSelectedIndexForCurrentDate() {
            // Загружаем тренировку на текущую дату
            if let todayWorkoutDay = viewModel.workoutDay(for: Date()) {
                updateSelectedIndexForDate(todayWorkoutDay.date ?? Date())
            }
        }
        
        private func updateSelectedIndexForDate(_ date: Date) {
            if let index = viewModel.sortedWorkoutDays.firstIndex(where: { Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date) }) {
                selectedIndex = index
            }
        }
        
        // MARK: - Элемент miniViewItem
        func miniViewItem(for workoutDay: WorkoutDay) -> some View {
            HStack {
                Image("miniView") // Картинка слева
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipped()
                    .padding(.leading, 10)
                
                Spacer()
                
                // Дата тренировки
                Text(workoutDay.date?.formattedDate() ?? "Unknown Date")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color("ViewColor2").opacity(0.9))
            .cornerRadius(10)
        }
        
        func emptyTabView() -> some View {
            HStack {
                Text("Tap to create your workout")
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



// Нет тренировки
struct WorkoutDaysList_Previews: PreviewProvider {
    @State static var workoutDay: WorkoutDay? = nil
    static var previews: some View {
        WorkoutDaysList(viewModel: WorkoutViewModel(), workoutDay: $workoutDay)
    }
}

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
