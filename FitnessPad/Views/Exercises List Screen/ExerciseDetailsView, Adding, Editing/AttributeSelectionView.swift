//
//  AttributeSelectionView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.02.2025.
//

import SwiftUI

import SwiftUI

struct AttributeSelectionView: View {
    let attributes: [String]
    @Binding var selectedAttributes: Set<String>
    @Binding var isAttributesValid: Bool
    @Binding var showAttributeLimitAlert: Bool
    
    var body: some View {
        VStack {
            Text(isAttributesValid ? "Select Attributes for Exercise" : "Please select at least one attribute")
                .font(.system(size: 18))
                .foregroundColor(isAttributesValid ? .gray : .red)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            List {
                Section {
                    ForEach(attributes, id: \.self) { attribute in
                        HStack {
                            Text(attribute)
                                .foregroundColor(selectedAttributes.contains(attribute) ? .blue : Color("TextColor"))
                                .font(.system(size: 18))
                                .padding(.leading, 10)
                            Spacer()
                            if selectedAttributes.contains(attribute) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .padding(.trailing, 10)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedAttributes.contains(attribute) {
                                selectedAttributes.remove(attribute)
                            } else {
                                if selectedAttributes.count < 2 {
                                    selectedAttributes.insert(attribute)
                                    isAttributesValid = true
                                } else {
                                    showAttributeLimitAlert = true
                                }
                            }
                        }
                    }
                }
            }
            .background(Color("ViewColor").opacity(0.2))
            .cornerRadius(8)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listStyle(PlainListStyle())
            .scrollIndicators(.hidden)
            .frame(minHeight: CGFloat(attributes.count) * 45)
        }
        .padding(.horizontal)
        .alert(isPresented: $showAttributeLimitAlert) {
            Alert(
                title: Text("Limit Reached"),
                message: Text("You can select a maximum of 2 attributes."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
