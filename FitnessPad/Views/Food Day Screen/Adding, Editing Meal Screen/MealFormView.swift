//
//  AddMealView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 21.01.2025.
//

import SwiftUI

struct MealFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var foodDayViewModel: FoodDayViewModel
    @State private var mealName: String
    @State var selectedProducts: [SelectedProductModel] = []
    @State private var isProductSelectionPresented: Bool = false
    @State private var isGramInputPresented: Bool = false
    @State private var selectedProductForEditing: SelectedProductModel? = nil
    
    var isSaveButtonDisabled: Bool {
        mealName.isEmpty || selectedProducts.isEmpty
    }
    
    var meal: Meal?
    var selectedDate: Date
    
    init(meal: Meal? = nil, selectedDate: Date, foodDayViewModel: FoodDayViewModel) {
        self.meal = meal
        self.selectedDate = selectedDate
        self.foodDayViewModel = foodDayViewModel
        _mealName = State(initialValue: meal?.name ?? "")
        
        if let productString = meal?.products {
            let productEntries = productString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            var products: [SelectedProductModel] = []
            for entry in productEntries {
                let components = entry.split(separator: ":")
                if components.count == 2, let quantity = Double(components[1]) {
                    let productName = String(components[0])
                    if let product = productsByCategory.values.flatMap({ $0 }).first(where: { $0.name == productName }) {
                        products.append(SelectedProductModel(product: product, quantity: quantity))
                    }
                }
            }
            self._selectedProducts = State(initialValue: products)
        } else {
            self._selectedProducts = State(initialValue: [])
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(meal == nil ? "add_meal_label".localized : "edit_meal_label".localized) // Локализованный текст
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                CloseButtonCircle()
                    .padding(.trailing, 20)
            }
            
            Form {
                Section {
                    TextField("meal_name_placeholder".localized, text: $mealName) // Локализованный текст
                }
                
                Section(header: Text("selected_products_label".localized)) { // Локализованный текст
                    ForEach($selectedProducts) { $selectedProduct in
                        HStack {
                            Text(selectedProduct.product.name)
                            Spacer()
                            
                            // Текстовое поле для выбора граммовки
                            Text(formatGrams(selectedProduct.quantity))
                                .frame(minWidth: 40, maxWidth: 60)
                                .onTapGesture {
                                    selectedProductForEditing = selectedProduct
                                    isGramInputPresented = true
                                }
                        }
                        .contentShape(Rectangle())
                    }
                    .onDelete { indices in
                        selectedProducts.remove(atOffsets: indices)
                    }
                    
                    // Add Product Button
                    Button(action: {
                        isProductSelectionPresented = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("add_product_label".localized) // Локализованный текст
                        }
                        .foregroundColor(Color("ButtonTextColor"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                    }
                }
                
                Section(header: Text("nutrition_summary_label".localized)) {
                    NutritionInfoRow(label: "meal_proteins_label", value: totalProteins, unit: "meal_grams")
                    NutritionInfoRow(label: "meal_fats_label", value: totalFats, unit: "meal_grams")
                    NutritionInfoRow(label: "meal_carbohydrates_label", value: totalCarbohydrates, unit: "meal_grams")
                    NutritionInfoRow(label: "meal_calories_label", value: totalCalories, unit: "meal_calories")
                }
            }
            
            Button("save_changes_label".localized) { // Локализованный текст
                saveMeal()
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(Color("ButtonTextColor"))
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSaveButtonDisabled ? Color.gray : Color("ButtonColor"))
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(isSaveButtonDisabled)
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: $isProductSelectionPresented) {
            CategoryGridView(selectedProducts: Binding<[Product]>(
                get: { selectedProducts.map { $0.product } },
                set: { newProducts in
                    selectedProducts = newProducts.map { SelectedProductModel(product: $0) }
                }
            ))
        }
        .sheet(isPresented: $isGramInputPresented) {
            GramInputView(selectedProducts: $selectedProducts, selectedProductForEditing: $selectedProductForEditing, isGramInputPresented: $isGramInputPresented)
        }
    }

    private func saveMeal() {
        let productEntries = selectedProducts.map { "\($0.product.name):\($0.quantity)" }.joined(separator: ", ")
        
        if let meal = meal {
            foodDayViewModel.updateMeal(
                meal,
                name: mealName,
                products: productEntries,
                proteins: totalProteins,
                fats: totalFats,
                carbohydrates: totalCarbohydrates,
                calories: totalCalories
            )
        } else {
            foodDayViewModel.addMeal(
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
            return String(format: "%.2f kg", kilograms)
        } else {
            return String(format: "%.0f g", grams)
        }
    }
}


//struct MealFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Создаем моковый ViewModel для превью
//        let viewModel = FitnessPadViewModel()
//
//        // Создаем моковую дату
//        let selectedDate = Date()
//
//        // Создаем моковый объект Meal
//        let meal = createMockMeal()
//
//        // Отображаем MealFormView в превью
//        Group {
//            // Превью для добавления нового приема пищи
//            MealFormView(selectedDate: selectedDate, viewModel: viewModel)
//                .previewDisplayName("Add Meal")
//
//            // Превью для редактирования существующего приема пищи
//            MealFormView(meal: meal, selectedDate: selectedDate, viewModel: viewModel)
//                .previewDisplayName("Edit Meal")
//        }
//    }
//
//    // Метод для создания мокового объекта Meal
//    static func createMockMeal() -> Meal {
//        let context = PersistenceController.shared.container.viewContext
//        let meal = Meal(context: context)
//        meal.name = "Sample Meal"
//        meal.calories = 500
//        meal.proteins = 30
//        meal.fats = 20
//        meal.carbohydrates = 50
//
//        // Сохраняем изменения в контексте
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save mock meal: \(error)")
//        }
//
//        return meal
//    }
//}
