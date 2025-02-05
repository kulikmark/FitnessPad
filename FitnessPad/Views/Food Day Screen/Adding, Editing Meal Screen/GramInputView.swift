//
//  GramPickerView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

struct GramInputView: View {
    @Binding var selectedProducts: [SelectedProductModel]
    @Binding var selectedProductForEditing: SelectedProductModel?
    @Binding var isGramInputPresented: Bool
    
    @State private var gramsInput: String = ""
    @FocusState private var isTextFieldFocused: Bool // Состояние фокуса
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("enter_grams_label".localized) // Локализованный текст
                    .font(.title2)
                    .foregroundStyle(Color("TextColor"))
                    .bold()
                    .padding(.top, 10)
                
                // Текстовое поле для ввода граммовки
                TextField("grams_placeholder".localized, text: $gramsInput)
                    .keyboardType(.numberPad) // Клавиатура для ввода чисел
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .focused($isTextFieldFocused) // Привязка фокуса
                    .onAppear {
                        // Устанавливаем начальное значение при открытии
                        if let selectedProduct = selectedProductForEditing {
                            gramsInput = String(format: "%.0f", selectedProduct.quantity)
                        }
                        // Устанавливаем фокус
                        isTextFieldFocused = true
                    }
                
                // Кнопка для подтверждения выбора
                Button(action: {
                    if let selectedProduct = selectedProductForEditing,
                       let index = selectedProducts.firstIndex(where: { $0.id == selectedProduct.id }),
                       let grams = Double(gramsInput) {
                        selectedProducts[index].quantity = grams
                    }
                    isGramInputPresented = false
                }) {
                    Text("done_label".localized) // Локализованный текст
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
    }
}
