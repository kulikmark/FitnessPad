//
//  AddMealView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 21.01.2025.
//

import SwiftUI
import SwiftUI

struct MealFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var mealName: String
    @State private var selectedProducts: [SelectedProduct] = []
    @State private var isProductSelectionPresented: Bool = false
    @State private var isGramPickerPresented: Bool = false
    @State private var selectedProductForEditing: SelectedProduct? = nil
    @State private var selectedGrams: Int = 0 // Состояние для выбора граммовки

    var isSaveButtonDisabled: Bool {
        mealName.isEmpty || selectedProducts.isEmpty
    }

    var meal: Meal?
    var selectedDate: Date

    init(meal: Meal? = nil, selectedDate: Date, viewModel: WorkoutViewModel) {
        self.meal = meal
        self.selectedDate = selectedDate
        self.viewModel = viewModel
        _mealName = State(initialValue: meal?.name ?? "")
        
        if let productString = meal?.products {
            let productEntries = productString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            var products: [SelectedProduct] = []
            for entry in productEntries {
                let components = entry.split(separator: ":")
                if components.count == 2, let quantity = Double(components[1]) {
                    let productName = String(components[0])
                    if let product = productsByCategory.values.flatMap({ $0 }).first(where: { $0.name == productName }) {
                        products.append(SelectedProduct(product: product, quantity: quantity))
                    }
                }
            }
            self._selectedProducts = State(initialValue: products)
        } else {
            self._selectedProducts = State(initialValue: [])
        }
    }
    
    var totalProteins: Double {
        selectedProducts.reduce(0) { $0 + $1.totalProteins }
    }

    var totalFats: Double {
        selectedProducts.reduce(0) { $0 + $1.totalFats }
    }

    var totalCarbohydrates: Double {
        selectedProducts.reduce(0) { $0 + $1.totalCarbohydrates }
    }

    var totalCalories: Double {
        selectedProducts.reduce(0) { $0 + $1.totalCalories }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(meal == nil ? "Add Meal" : "Edit Meal")
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                HStack(spacing: 20) {
                    addProductButton
                    CloseButtonCircle()
                }
                .padding(.trailing, 20)
            }
            
            Form {
                Section {
                    TextField("Meal Name", text: $mealName)
                }

                Section(header: Text("Selected Products")) {
                    ForEach($selectedProducts) { $selectedProduct in
                        HStack {
                            Text(selectedProduct.product.name)
                            Spacer()

                            // Текстовое поле для выбора граммовки
                            Text(formatGrams(selectedProduct.quantity))
                                .frame(minWidth: 40, maxWidth: 60)
                                .onTapGesture {
                                    selectedProductForEditing = selectedProduct
                                    selectedGrams = Int(selectedProduct.quantity)
                                    isGramPickerPresented = true
                                }
                        }
                        .contentShape(Rectangle())
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

            Button("Save Changes") {
                saveMeal()
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(Color("ButtonTextColor"))
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSaveButtonDisabled ? Color.gray : Color("ButtonColor"))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .disabled(isSaveButtonDisabled)
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: $isProductSelectionPresented) {
            ProductSelectionView(selectedProducts: Binding<[Product]>(
                get: { selectedProducts.map { $0.product } },
                set: { newProducts in
                    selectedProducts = newProducts.map { SelectedProduct(product: $0) }
                }
            ))
        }
        .sheet(isPresented: $isGramPickerPresented) {
            gramPickerView() // Вызываем функцию для отображения пикера граммовки
        }
    }

    // Функция для отображения пикера граммовки
    private func gramPickerView() -> some View {
        ZStack {
            // Фон для всего sheet
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Заголовок
                Text("Select Grams")
                    .font(.title2)
                    .foregroundStyle(Color("TextColor"))
                    .bold()
                    .padding(.top, 10)

                // Пикер для выбора граммовки
                Picker("Grams", selection: $selectedGrams) {
                    ForEach(Array(stride(from: 0, through: 5000, by: 10)), id: \.self) { grams in
                        Text("\(grams) g")
                            .tag(grams)
                            .foregroundStyle(Color("TextColor"))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
                .clipped()
                .padding(.horizontal, 20)

                // Кнопка для подтверждения выбора
                Button(action: {
                    if let selectedProduct = selectedProductForEditing,
                       let index = selectedProducts.firstIndex(where: { $0.id == selectedProduct.id }) {
                        selectedProducts[index].quantity = Double(selectedGrams)
                    }
                    isGramPickerPresented = false
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(Color("ButtonTextColor"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
            .frame(maxWidth: .infinity)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .onAppear {
            // Инициализируем selectedGrams при открытии пикера
            if let selectedProduct = selectedProductForEditing {
                selectedGrams = Int(selectedProduct.quantity)
            }
        }
    }

    private var addProductButton: some View {
        HStack(spacing: 5) {
            Text("Add\nProduct")
                .font(.system(size: 8))
                .foregroundColor(Color("TextColor"))
            Button(action: {
                isProductSelectionPresented = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 17))
                    .foregroundColor(Color("TextColor"))
            }
        }
    }

    private func saveMeal() {
        let productEntries = selectedProducts.map { "\($0.product.name):\($0.quantity)" }.joined(separator: ", ")
        
        if let meal = meal {
            viewModel.updateMeal(
                meal: meal,
                name: mealName,
                products: productEntries,
                calories: totalCalories,
                proteins: totalProteins,
                fats: totalFats,
                carbohydrates: totalCarbohydrates
            )
        } else {
            viewModel.addMeal(
                name: mealName,
                products: productEntries,
                proteins: totalProteins,
                fats: totalFats,
                carbohydrates: totalCarbohydrates,
                calories: totalCalories,
                date: selectedDate
            )
        }
    }
    
    private func formatGrams(_ grams: Double) -> String {
        if grams >= 1000 {
            let kilograms = grams / 1000
            return String(format: "%.2f kg", kilograms) // Используем два знака после запятой
        } else {
            return String(format: "%.0f g", grams)
        }
    }
}

struct SelectedProduct: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Double = 100

    var totalProteins: Double {
        (product.proteins * quantity) / 100
    }

    var totalFats: Double {
        (product.fats * quantity) / 100
    }

    var totalCarbohydrates: Double {
        (product.carbohydrates * quantity) / 100
    }

    var totalCalories: Double {
        (product.calories * quantity) / 100
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
