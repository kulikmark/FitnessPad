//
//  BodyWeightInputView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 06.08.2024.
//

import SwiftUI

struct BodyWeightInputView: View {
    @Binding var bodyWeightInput: String
    @Binding var weightUnit: WeightUnit
    var onSave: (String, WeightUnit) -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Body Weight")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.top, 30)
            
            TextField("Weight", text: $bodyWeightInput)
                .keyboardType(.decimalPad)
                .textFieldStyle(WhiteTextFieldStyle())
                .padding(.horizontal, 30)
            
            CustomSegmentedPicker(
                selection: $weightUnit,
                items: WeightUnit.allCases
            )
            .padding(.horizontal)
            
            Spacer()
            
            HStack {
                Button(action: {
                    onCancel()
                }) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("ViewColor2").opacity(0.7))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button(action: {
                    onSave(bodyWeightInput, weightUnit)
                }) {
                    Text("OK")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)

        }
        .background(
            Color("ViewColor")
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    hideKeyboard()
                }
        )
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct BodyWeightInputView_Previews: PreviewProvider {
    static var previews: some View {
        BodyWeightInputView(
            bodyWeightInput: .constant(""),
            weightUnit: .constant(.kg),
            onSave: { _, _ in },
            onCancel: {}
        )
        .previewLayout(.sizeThatFits)
    }
}


