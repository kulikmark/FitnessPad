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
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("enter_grams_label".localized)
                    .font(.title2)
                    .foregroundStyle(Color("TextColor"))
                    .bold()
                    .padding(.top, 10)
                
                TextField("grams_placeholder".localized, text: $gramsInput)
                    .padding(10)
                    .background(Color(.systemBackground))
                    .foregroundColor(.gray)
                    .cornerRadius(8)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($isTextFieldFocused)
                    .onAppear {
                        if let selectedProduct = selectedProductForEditing {
                            gramsInput = String(format: "%.0f", selectedProduct.quantity)
                        }
                        isTextFieldFocused = true
                    }
                    .frame(width: 100) // Ограничение ширины для компактности
                
                Button(action: {
                    if let selectedProduct = selectedProductForEditing,
                       let index = selectedProducts.firstIndex(where: { $0.id == selectedProduct.id }),
                       let grams = Double(gramsInput) {
                        selectedProducts[index].quantity = grams
                    }
                    isGramInputPresented = false
                }) {
                    Text("done_label".localized)
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

