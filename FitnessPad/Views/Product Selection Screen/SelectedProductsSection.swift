//
//  selectedProductsSection.swift
//  FitnessPad
//
//  Created by Марк Кулик on 12.02.2025.
//

import SwiftUI

struct SelectedProductsSection: View {
    @Binding var selectedProducts: [SelectedProductModel]
    @Binding var selectedProductForEditing: SelectedProductModel?
    @Binding var isGramInputPresented: Bool
    
    var body: some View {
        if !selectedProducts.isEmpty {
            List {
                Section {
                    ForEach($selectedProducts) { $selectedProduct in
                        HStack {
                            Text(selectedProduct.product.name)
                                .font(.system(size: 14))
                            Spacer()
                            
                            GramTextView(grams: selectedProduct.quantity) {
                                selectedProductForEditing = selectedProduct
                                isGramInputPresented = true
                            }
                        }
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                if let index = selectedProducts.firstIndex(where: { $0.id == selectedProduct.id }) {
                                    selectedProducts.remove(at: index)
                                }
                            } label: {
                                Label("Удалить", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: CGFloat(selectedProducts.count) * 50)
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .listStyle(PlainListStyle())
            .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $isGramInputPresented) {
                GramInputView(
                    selectedProducts: $selectedProducts,
                    selectedProductForEditing: $selectedProductForEditing,
                    isGramInputPresented: $isGramInputPresented
                )
            }
        }
    }
}
