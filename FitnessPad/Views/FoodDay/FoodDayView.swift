//
//  FoodDay.swift
//  FitnessPad
//
//  Created by Марк Кулик on 21.01.2025.
//

import SwiftUI
import CoreData

struct FoodDayView: View {
    @EnvironmentObject var viewModel: WorkoutViewModel
    @State private var selectedDate: Date = Date()
    @State private var currentMonth: Date = Date()
   
    
    var body: some View {
        VStack(spacing: 0) {

            FoodDayHeaderView(selectedDate: $selectedDate, currentMonth: $currentMonth)
                    .environmentObject(viewModel)
            
            // Календарь с вкладками месяцев
            CalendarTabs(selectedDate: $selectedDate, currentMonth: $currentMonth)
                .environmentObject(viewModel)
                .frame(height: 75)
                .padding(.horizontal, 10)
                .background(Color("BackgroundColor"))
            
            Spacer()
            
            // Основной контент FoodDayView
            FoodDayContentView(selectedDate: $selectedDate)
                .environmentObject(viewModel)
        }
        .background(Color("BackgroundColor"))
        .onAppear {
            // При загрузке экрана выбираем сегодняшнюю дату
            selectedDate = Calendar.current.startOfDay(for: Date())
            currentMonth = Calendar.current.startOfDay(for: Date())
        }
    }
}

// MARK: - Календарь с вкладками месяцев
struct CalendarTabs: View {
    @Binding var selectedDate: Date
    @Binding var currentMonth: Date
    
    var body: some View {
        TabView(selection: $currentMonth) {
            ForEach(getMonths(), id: \.self) { month in
                // Используем GeometryReader для анимации перелистывания
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        CalendarStrip(selectedDate: $selectedDate, currentMonth: month)
                    }
                    // Анимация перелистывания
                    .offset(x: calculateOffset(for: month, in: geometry))
                }
                .tag(month)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .background(Color("BackgroundColor"))
    }
    
    // Вычисляем смещение для анимации
    private func calculateOffset(for month: Date, in geometry: GeometryProxy) -> CGFloat {
        let currentIndex = getMonths().firstIndex(of: currentMonth) ?? 0
        let monthIndex = getMonths().firstIndex(of: month) ?? 0
        let offset = CGFloat(monthIndex - currentIndex) * geometry.size.width
        return offset
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

// MARK: - Календарная лента для одного месяца
struct CalendarStrip: View {
    @Binding var selectedDate: Date
    var currentMonth: Date
    @EnvironmentObject var viewModel: WorkoutViewModel
    @State private var days: [Date] = []
    @State private var isDataLoaded: Bool = false

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(days, id: \.self) { date in
                        CalendarDayView(date: date, isSelected: isSameDay(date1: date, date2: selectedDate))
                            .environmentObject(viewModel) // Передаем viewModel
                            .onTapGesture {
                                selectedDate = date
                            }
                            .id(date)
                    }
                }
                .onAppear {
                    loadDays(for: currentMonth)
                    isDataLoaded = true
                }
                .onChange(of: isDataLoaded) {
                    if isDataLoaded {
                        proxy.scrollTo(selectedDate, anchor: .center)
                    }
                }
                .onChange(of: selectedDate) { _, newDate in
                    withAnimation {
                        proxy.scrollTo(newDate, anchor: .center)
                    }
                }
            }
        }
    }

    // Загружаем дни для текущего месяца
    private func loadDays(for month: Date) {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: month)!
        days = range.map { day -> Date in
            calendar.date(bySetting: .day, value: day, of: month)!
        }
    }

    // Проверяем, совпадают ли две даты
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

// MARK: - Отдельный день в календаре
struct CalendarDayView: View {
    var date: Date
    var isSelected: Bool
    @EnvironmentObject var viewModel: WorkoutViewModel

    var body: some View {
        VStack {
                Text(getDayOfWeek(from: date)) // День недели
                    .font(.caption)
                    .foregroundColor(isSelected ? Color("ButtonTextColor") : .gray)
                
                
                Text(getDay(from: date)) // Число
                    .font(.title2)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? Color("ButtonTextColor") : .primary)
            
            Spacer()
            
            // Отображаем точку, если есть meals для этой даты
            if hasMeals(for: date) {
                Circle()
                    .fill(isSelected ? Color("ButtonTextColor") : Color("TextColor"))
                    .frame(width: 5, height: 5)
            }
        }
        .frame(width: 30, height: 50)
        .padding(10)
        .background(isSelected ? Color("ButtonColor") : Color.clear)
        .cornerRadius(10)
    }

    // Получаем день недели (например, "Пн")
    private func getDayOfWeek(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }

    // Получаем число (например, "15")
    private func getDay(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    // Проверяем, есть ли meals для этой даты
    private func hasMeals(for date: Date) -> Bool {
        if let foodDay = viewModel.foodDay(for: date),
           let meals = foodDay.meals,
           !meals.allObjects.isEmpty {
            return true
        }
        return false
    }
}


// MARK: - Основной компонент FoodDayContentView
struct FoodDayContentView: View {
    @Binding var selectedDate: Date
    @EnvironmentObject var viewModel: WorkoutViewModel
    
    @State private var isAddingMeal: Bool = false
    @State private var editingMeal: Meal? = nil
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        VStack {
            // Проверяем, есть ли данные для выбранной даты
                      let foodDay = viewModel.foodDay(for: selectedDate)
                      let meals = foodDay?.meals?.allObjects as? [Meal] ?? []
                      
                      // Отображаем сводную информацию только если есть meals
                      if !meals.isEmpty {
                          DaySummaryView(
                              totalCalories: viewModel.totalCalories(for: selectedDate),
                              totalProteins: viewModel.totalProteins(for: selectedDate),
                              totalFats: viewModel.totalFats(for: selectedDate),
                              totalCarbohydrates: viewModel.totalCarbohydrates(for: selectedDate)
                          )
                      }
            
            // Список приемов пищи
            MealListView(
                meals: foodDay?.meals?.allObjects as? [Meal] ?? [],
                onDelete: deleteMeal,
                onEdit: editMeal
            )
            
            // Кнопка для добавления приема пищи
            AddMealButton(isAddingMeal: $isAddingMeal, selectedDate: selectedDate, viewModel: _viewModel)
        }
        .padding(.horizontal)
        
        // Обработка редактирования и добавления приемов пищи
        .fullScreenCover(isPresented: $isAddingMeal) {
            MealFormView(selectedDate: selectedDate, viewModel: viewModel)
        }
        .fullScreenCover(item: $editingMeal) { meal in
            MealFormView(meal: meal, selectedDate: selectedDate, viewModel: viewModel)
        }
    }
    
    // Удаление приема пищи
    private func deleteMeal(at offsets: IndexSet) {
        guard let foodDay = viewModel.foodDay(for: selectedDate) else { return }
        if let meals = foodDay.meals?.allObjects as? [Meal] {
            for index in offsets {
                let meal = meals[index]
                viewModel.deleteMeal(meal)
            }
        }
    }
    
    // Удаление конкретного приема пищи
    private func deleteMeal(_ meal: Meal) {
        viewModel.deleteMeal(meal)
    }
    
    // Редактирование приема пищи
    private func editMeal(_ meal: Meal) {
        editingMeal = meal
    }
}

// MARK: - Компонент для сводной информации
struct DaySummaryView: View {
    var totalCalories: Double
    var totalProteins: Double
    var totalFats: Double
    var totalCarbohydrates: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Total for day:")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color("TextColor"))

            NutritionInfoRow(label: "Calories", value: totalCalories, unit: "kcal")
            NutritionInfoRow(label: "Proteins", value: totalProteins, unit: "g")
            NutritionInfoRow(label: "Fats", value: totalFats, unit: "g")
            NutritionInfoRow(label: "Carbohydrates", value: totalCarbohydrates, unit: "g")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color("ViewColor").opacity(0.2))
        .cornerRadius(8)
    }
}

// MARK: - Компонент для строки с информацией о питании
struct NutritionInfoRow: View {
    var label: String
    var value: Double
    var unit: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color("TextColor"))
            Spacer()
            Text("\(value, specifier: "%.1f") \(unit)")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Компонент для списка приемов пищи
struct MealListView: View {
    var meals: [Meal]
    var onDelete: (Meal) -> Void // Изменили тип на (Meal) -> Void
    var onEdit: (Meal) -> Void
    
    var body: some View {
        if !meals.isEmpty {
            List {
                ForEach(meals, id: \.id) { meal in
                    MealRowView(meal: meal, onEdit: onEdit, onDelete: onDelete)
                }
                .onDelete { indexSet in
                    // Преобразуем IndexSet в массив Meal и вызываем onDelete для каждого
                    for index in indexSet {
                        onDelete(meals[index])
                    }
                }
            }
            .listStyle(PlainListStyle())
            .background(Color("BackgroundColor"))
            .scrollContentBackground(.hidden)
        } else {
            Spacer()
            Text("No meals added yet.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
            Spacer()
        }
      
    }
}

// MARK: - Компонент для строки с информацией о приеме пищи
struct MealRowView: View {
    var meal: Meal
    var onEdit: (Meal) -> Void
    var onDelete: (Meal) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(meal.name ?? "Unknown Meal")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("TextColor"))
            NutritionInfoRow(label: "Calories", value: meal.calories, unit: "kcal")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color("ViewColor"))
        .cornerRadius(10)
        .listRowBackground(Color("BackgroundColor"))
        .onTapGesture(perform: {
            onEdit(meal)
        })
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            // Кнопка удаления
            Button(role: .destructive) {
                onDelete(meal)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: - Компонент для кнопки добавления приема пищи
struct AddMealButton: View {
    @Binding var isAddingMeal: Bool
    var selectedDate: Date
    @EnvironmentObject var viewModel: WorkoutViewModel
    
    var body: some View {
        Button(action: {
            isAddingMeal = true
        }) {
            HStack {
                Image(systemName: "plus")
                Text("Add Meal")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("ButtonColor"))
            .foregroundColor(Color("ButtonTextColor"))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.bottom, 50)
    }
}

// MARK: - Расширения для текста
extension Text {
    func grayText() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(.gray)
    }
    
    func whiteText() -> some View {
        self
            .font(.system(size: 16))
            .foregroundColor(Color("TextColor"))
    }
}

// MARK: - Preview
struct FoodDayView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = WorkoutViewModel()
        let context = PersistenceController.shared.container.viewContext
        
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
            .preferredColorScheme(.dark) // Для тестирования темной темы
    }
}
