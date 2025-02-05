//
//  FoodDay.swift
//  FitnessPad
//
//  Created by Марк Кулик on 21.01.2025.
//

import SwiftUI
import CoreData

struct FoodDayView: View {
    @EnvironmentObject var foodDayViewModel: FoodDayViewModel
    @EnvironmentObject var foodService: FoodService
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()
    @State private var currentMonthIndex: Int = 0  // Индекс текущего месяца в списке

    var body: some View {
        VStack(spacing: 0) {
            FoodDayHeaderView(currentMonth: $currentMonth)
                .environmentObject(foodDayViewModel)

            // Календарь с вкладками месяцев
            CalendarTabs(selectedDate: $selectedDate, currentWeek: $currentMonth, currentWeekIndex: $currentMonthIndex)
                .environmentObject(foodDayViewModel)
                .frame(height: 90)
                .background(Color("BackgroundColor"))
                .padding(.horizontal, 10)

            FoodDayWeightWaterView(selectedDate: $selectedDate)
                .padding(.top, 15)

            Spacer()

            // Основной контент FoodDayView
            FoodDayContentView(selectedDate: $selectedDate)
                .environmentObject(foodDayViewModel)
        }
        .background(Color("BackgroundColor"))
        .onAppear {
            // При загрузке экрана выбираем сегодняшнюю дату
            let today = Calendar.current.startOfDay(for: Date())
            selectedDate = today
            currentMonth = today
            
            // Находим индекс текущего месяца в массиве
            let months = getMonths()
            if let index = months.firstIndex(where: { Calendar.current.isDate($0, equalTo: today, toGranularity: .month) }) {
                currentMonthIndex = index
            }
        }
    }
    
    // Генерируем список месяцев
    private func getMonths() -> [Date] {
        let calendar = Calendar.current
        var months: [Date] = []
        let startDate = calendar.date(from: DateComponents(year: 2025, month: 1, day: 1))!
        
        // Добавляем 120 месяцев (10 лет) для примера
        for i in 0..<120 {
            if let month = calendar.date(byAdding: .month, value: i, to: startDate) {
                months.append(month)
            }
        }
        return months
    }
}





// MARK: - Preview
struct FoodDayView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let foodService = FoodService(context: context)
        let bodyWeightService = BodyWeightService(context: context)
        let workoutDayService = WorkoutDayService(context: context)
        let workoutDayExerciseService = WorkoutDayExerciseService(context: context)
        let workoutDayViewModel = WorkoutDayViewModel(workoutDayService: workoutDayService, bodyWeightService: bodyWeightService, workoutDayExerciseService: workoutDayExerciseService)
        let bodyWeightViewModel = BodyWeightViewModel(bodyWeightService: bodyWeightService)
        let viewModel = FoodDayViewModel(foodService: foodService)
        
        // Создаем mock FoodDay
        let foodDay = FoodDay(context: context)
        foodDay.date = Date()
        
        // Создаем mock Meal
        let meal1 = Meal(context: context)
        meal1.name = "Завтрак"
        meal1.calories = 500
        meal1.proteins = 30
        meal1.fats = 20
        meal1.carbohydrates = 50
        meal1.foodDay = foodDay
        
        let meal2 = Meal(context: context)
        meal2.name = "Обед"
        meal2.calories = 800
        meal2.proteins = 40
        meal2.fats = 30
        meal2.carbohydrates = 100
        meal2.foodDay = foodDay
        
        return FoodDayView()
            .environmentObject(viewModel)
            .environmentObject(bodyWeightViewModel)
            .environmentObject(workoutDayViewModel)
            .environmentObject(foodService)
            .preferredColorScheme(.dark) // Для тестирования темной темы
    }
}
