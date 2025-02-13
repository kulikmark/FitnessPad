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
    @ObservedObject var productViewModel: ProductViewModel
    @State private var mealName: String
    @State var selectedProducts: [SelectedProductModel] = []
    @State private var isProductSelectionPresented: Bool = false
    @State private var isGramInputPresented: Bool = false
    @State private var selectedProductForEditing: SelectedProductModel? = nil
    
    let isFromFoodDayView: Bool
    
    var isSaveButtonDisabled: Bool {
        mealName.isEmpty || selectedProducts.isEmpty
    }
    
    var meal: Meal?
    var selectedDate: Date
    
    init(meal: Meal? = nil, selectedDate: Date, foodDayViewModel: FoodDayViewModel, productViewModel: ProductViewModel, isFromFoodDayView: Bool) {
        self.meal = meal
        self.selectedDate = selectedDate
        self.foodDayViewModel = foodDayViewModel
        self.productViewModel = productViewModel
        _mealName = State(initialValue: meal?.name ?? "")
        self.isFromFoodDayView = isFromFoodDayView
        
        if let productString = meal?.products {
            let productEntries = productString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            var products: [SelectedProductModel] = []
            for entry in productEntries {
                let components = entry.split(separator: ":")
                if components.count == 2, let quantity = Double(components[1]) {
                    let productName = String(components[0])
                    
                    // Search for the product in `productsByCategory` (ProductItem)
                    if let productItem = productsByCategory.values.flatMap({ $0 }).first(where: { $0.name == productName }) {
                        let product = Product(from: productItem) // Convert ProductItem to Product
                        products.append(SelectedProductModel(product: product, quantity: quantity))
                    }
                    // Search for the product in `productViewModel.customProducts` (CustomProduct)
                    else if let customProduct = productViewModel.customProducts.first(where: { $0.name == productName }) {
                        let product = Product(from: customProduct) // Convert CustomProduct to Product
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
                Text(meal == nil ? "add_meal_label".localized : "edit_meal_label".localized)
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
                    TextField("meal_name_placeholder".localized, text: $mealName)
                }
               
                    Section {
                        if !selectedProducts.isEmpty {
                        SelectedProductsSection(
                            selectedProducts: $selectedProducts,
                            selectedProductForEditing: $selectedProductForEditing,
                            isGramInputPresented: $isGramInputPresented
                        )
                    } else {
                        Text("Продукты еще не добавлены")
                            .multilineTextAlignment(.center)
                            .padding(40)
                    }
                    
                    // Add Product Button
                    Button(action: {
                        isProductSelectionPresented = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("add_product_label".localized)
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
            
            Button("save_changes_label".localized) {
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
            CategoryGridView(
                selectedProducts: $selectedProducts,
                selectedCategory: .constant(nil),
                isSelectingCategory: false, isFromFoodDayView: true
                )
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
