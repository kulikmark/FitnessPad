//
//  AddMealView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 21.01.2025.
//

//import SwiftUI
//
//struct MealFormView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var viewModel: WorkoutViewModel
//    @State private var mealName: String
//    @State private var calories: String
//    @State private var proteins: String
//    @State private var fats: String
//    @State private var carbohydrates: String
//    
//    var meal: Meal?
//    var selectedDate: Date
//    
//    init(meal: Meal? = nil, selectedDate: Date, viewModel: WorkoutViewModel) {
//        self.meal = meal
//        self.selectedDate = selectedDate
//        self.viewModel = viewModel
//        _mealName = State(initialValue: meal?.name ?? "")
//        _calories = State(initialValue: meal != nil ? String(meal!.calories) : "")
//        _proteins = State(initialValue: meal != nil ? String(meal!.proteins) : "")
//        _fats = State(initialValue: meal != nil ? String(meal!.fats) : "")
//        _carbohydrates = State(initialValue: meal != nil ? String(meal!.carbohydrates) : "")
//    }
//    
//    // Проверка, все ли поля заполнены
//    private var isFormValid: Bool {
//        !mealName.isEmpty &&
//        !calories.isEmpty &&
//        !proteins.isEmpty &&
//        !fats.isEmpty &&
//        !carbohydrates.isEmpty
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            // Кастомный заголовок
//            Text(meal == nil ? "Add Meal" : "Edit Meal")
//                .font(.system(size: 24))
//                .fontWeight(.medium)
//                .foregroundColor(Color("TextColor"))
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding()
//            
//            // Форма
//            Form {
//                Section {
//                    // Подпись для Meal Name
//                    VStack(alignment: .leading, spacing: 5) {
//                        Text("Meal Name")
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                        TextField("Enter meal name", text: $mealName)
//                    }
//                    
//                    // Подпись для Calories
//                    VStack(alignment: .leading, spacing: 5) {
//                        Text("Calories (kcal)")
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                        TextField("Enter calories", text: $calories)
//                            .keyboardType(.decimalPad)
//                    }
//                    
//                    // Подпись для Proteins
//                    VStack(alignment: .leading, spacing: 5) {
//                        Text("Proteins (g)")
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                        TextField("Enter proteins", text: $proteins)
//                            .keyboardType(.decimalPad)
//                    }
//                    
//                    // Подпись для Fats
//                    VStack(alignment: .leading, spacing: 5) {
//                        Text("Fats (g)")
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                        TextField("Enter fats", text: $fats)
//                            .keyboardType(.decimalPad)
//                    }
//                    
//                    // Подпись для Carbohydrates
//                    VStack(alignment: .leading, spacing: 5) {
//                        Text("Carbohydrates (g)")
//                            .font(.system(size: 14))
//                            .foregroundColor(.gray)
//                        TextField("Enter carbohydrates", text: $carbohydrates)
//                            .keyboardType(.decimalPad)
//                    }
//                }
//                .frame(height: 70)
//            }
//            .scrollContentBackground(.hidden) // Скрываем фон формы
//            .background(Color("BackgroundColor")) // Устанавливаем цвет фона
//            
//            // Кнопка "Save Meal"
//            Button(action: {
//                saveMeal()
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                Text("Save Meal")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(isFormValid ? Color("ButtonColor") : Color.gray) // Изменяем цвет кнопки
//                    .foregroundColor(Color("ButtonTextColor"))
//                    .cornerRadius(10)
//            }
//            .disabled(!isFormValid) // Делаем кнопку неактивной, если форма не заполнена
//            .padding()
//        }
//        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
//        .overlay(alignment: .topTrailing) {
//            CloseButtonCircle()
//        }
////        .simultaneousGesture(TapGesture().onEnded {
////            UIApplication.shared.endEditing(true)
////        })
//    }
//    
//    private func saveMeal() {
//        guard let caloriesValue = Double(calories),
//              let proteinsValue = Double(proteins),
//              let fatsValue = Double(fats),
//              let carbohydratesValue = Double(carbohydrates) else {
//            return
//        }
//        
//        if let meal = meal {
//            // Редактируем существующий прием пищи
//            viewModel.updateMeal(
//                meal: meal,
//                name: mealName,
//                calories: caloriesValue,
//                proteins: proteinsValue,
//                fats: fatsValue,
//                carbohydrates: carbohydratesValue
//            )
//        } else {
//            // Добавляем новый прием пищи
//            viewModel.addMeal(
//                name: mealName,
//                proteins: proteinsValue,
//                fats: fatsValue,
//                carbohydrates: carbohydratesValue,
//                calories: caloriesValue,
//                date: selectedDate
//            )
//        }
//    }
//}

import SwiftUI

struct MealFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var mealName: String
    @State private var selectedProducts: [Product] = []
    
    @State private var isProductSelectionPresented: Bool = false
    
    var meal: Meal?
    var selectedDate: Date
    
    init(meal: Meal? = nil, selectedDate: Date, viewModel: WorkoutViewModel) {
        self.meal = meal
        self.selectedDate = selectedDate
        self.viewModel = viewModel
        _mealName = State(initialValue: meal?.name ?? "")
        
        // Инициализация выбранных продуктов
        if let productString = meal?.products {
            let productNames = productString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            
            // Получаем выбранные продукты из словаря productsByCategory
            var products: [Product] = []
            for name in productNames {
                // Поиск продукта по имени в словаре
                if let product = productsByCategory.values.flatMap({ $0 }).first(where: { $0.name == name }) {
                    products.append(product)
                }
            }
            self._selectedProducts = State(initialValue: products)
        } else {
            self._selectedProducts = State(initialValue: [])
        }
    }


    
    var totalProteins: Double {
        selectedProducts.reduce(0) { $0 + $1.proteins }
    }
    
    var totalFats: Double {
        selectedProducts.reduce(0) { $0 + $1.fats }
    }
    
    var totalCarbohydrates: Double {
        selectedProducts.reduce(0) { $0 + $1.carbohydrates }
    }
    
    var totalCalories: Double {
        selectedProducts.reduce(0) { $0 + $1.calories }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(meal == nil ? "Add Meal" : "Edit Meal")
                .font(.system(size: 24))
                .fontWeight(.medium)
                .foregroundColor(Color("TextColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Form {
                Section {
                    TextField("Meal Name", text: $mealName)
                }
                
                Section(header: Text("Selected Products")) {
                    ForEach(selectedProducts) { product in
                        Text(product.name)
                    }
                    .onDelete { indices in
                        selectedProducts.remove(atOffsets: indices)
                    }
                }
                
                Section(header: Text("Nutrition Summary")) {
                    NutritionInfoRow(label: "Proteins", value: totalProteins, unit: "g")
                    NutritionInfoRow(label: "Fats", value: totalFats, unit: "g")
                    NutritionInfoRow(label: "Carbohydrates", value: totalCarbohydrates, unit: "g")
                    NutritionInfoRow(label: "Calories", value: totalCalories, unit: "kcal")
                }
            }
            
            Button("Add Product") {
                isProductSelectionPresented = true
            }
            .padding()
            .sheet(isPresented: $isProductSelectionPresented) {
                ProductSelectionView(selectedProducts: $selectedProducts)
            }
            
            Button("Save Meal") {
                saveMeal()
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
    }
    
    private func saveMeal() {
        let productNames = selectedProducts.map { $0.name }.joined(separator: ", ")
        
        viewModel.addMeal(
            name: mealName,
            products: productNames,
            proteins: totalProteins,
            fats: totalFats,
            carbohydrates: totalCarbohydrates,
            calories: totalCalories,
            date: selectedDate
        )
    }

}


struct MealFormView_Previews: PreviewProvider {
    static var previews: some View {
        // Создаем моковый ViewModel для превью
        let viewModel = WorkoutViewModel()
        
        // Создаем моковую дату
        let selectedDate = Date()
        
        // Создаем моковый объект Meal
        let meal = createMockMeal()
        
        // Отображаем MealFormView в превью
        Group {
            // Превью для добавления нового приема пищи
            MealFormView(selectedDate: selectedDate, viewModel: viewModel)
                .previewDisplayName("Add Meal")
            
            // Превью для редактирования существующего приема пищи
            MealFormView(meal: meal, selectedDate: selectedDate, viewModel: viewModel)
                .previewDisplayName("Edit Meal")
        }
    }
    
    // Метод для создания мокового объекта Meal
    static func createMockMeal() -> Meal {
        let context = PersistenceController.shared.container.viewContext
        let meal = Meal(context: context)
        meal.name = "Sample Meal"
        meal.calories = 500
        meal.proteins = 30
        meal.fats = 20
        meal.carbohydrates = 50
        
        // Сохраняем изменения в контексте
        do {
            try context.save()
        } catch {
            print("Failed to save mock meal: \(error)")
        }
        
        return meal
    }
}
