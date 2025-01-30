//
//  AddMealView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 21.01.2025.
//

import SwiftUI
struct MealFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var mealName: String
    @State private var selectedProducts: [SelectedProduct] = []
    @State private var isProductSelectionPresented: Bool = false
    
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
                    ForEach(selectedProducts) { selectedProduct in
                        HStack {
                            Text(selectedProduct.product.name)
                            Spacer()

                            // Кнопка уменьшения количества
                            Button(action: {
                                updateQuantity(for: selectedProduct, increment: -50)
                            }) {
                                Image(systemName: "minus")
                                    .foregroundColor(Color("ButtonTextColor"))
                                    .font(.system(size: 14))
                                    .frame(width: 30, height: 30) // Фиксированный размер для фона
                            }
                            .background(Color("ButtonColor"))
                            .clipShape(Circle())
                            .buttonStyle(PlainButtonStyle())
                            .contentShape(Rectangle())
                            .padding(.horizontal, 4)
                            
                            Text("\(selectedProduct.quantity, specifier: "%.0f") g")
                            
                            // Кнопка увеличения количества
                            Button(action: {
                                updateQuantity(for: selectedProduct, increment: 50)
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(Color("ButtonTextColor"))
                                    .font(.system(size: 14))
                                    .frame(width: 30, height: 30)
                            }
                            .background(Color("ButtonColor"))
                            .clipShape(Circle())
                            .buttonStyle(PlainButtonStyle())
                            .contentShape(Rectangle())
                            .padding(.horizontal, 4)
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

    private func updateQuantity(for selectedProduct: SelectedProduct, increment: Double) {
        guard let index = selectedProducts.firstIndex(where: { $0.id == selectedProduct.id }) else { return }
        selectedProducts[index].quantity = max(0, selectedProducts[index].quantity + increment)
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
