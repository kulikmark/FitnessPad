//
//  WeightRepsInputView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 07.08.2024.
//

import SwiftUI

struct WeightRepsInputView: View {
    @Binding var weightInput: String
    @Binding var weightInputUnit: WeightUnit
    @Binding var repsInput: String
    var onSave: (String, WeightUnit, String) -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Enter Weight and Reps")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.top, 30)
            
            HStack (alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Weight")
                        .foregroundColor(.white)
                    
                    TextField("", text: $weightInput)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(WhiteTextFieldStyle()) // Apply custom style
                        .frame(height: 70)
                        .frame(width: 150)
                    
                    HStack {
                        CustomSegmentedPicker(
                            selection: $weightInputUnit,
                            items: WeightUnit.allCases
                        )
                        .frame(width: 150)
                    }
                    
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Reps")
                        .foregroundColor(.white)
                    
                    TextField("", text: $repsInput)
                        .keyboardType(.numberPad)
                        .textFieldStyle(WhiteTextFieldStyle()) // Apply custom style
                        .frame(height: 70)
                        .frame(width: 150)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 30)
            
            Spacer()
            
            HStack {
                Button(action: {
                    onCancel()
                }) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(Color("ViewColor2").opacity(0.7))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button(action: {
                    onSave(weightInput, weightInputUnit, repsInput)
                }) {
                    Text("OK")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
        }
        .background(Color("ViewColor")
            .edgesIgnoringSafeArea(.all))
        .onTapGesture {
            hideKeyboard()
        }
    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct WhiteTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
    }
}

struct CustomSegmentedPicker: View {
    @Binding var selection: WeightUnit
    let items: [WeightUnit]
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    selection = item
                    
                }) {
                    Text(item.rawValue)
                        .padding()
                        .frame(height: 40)
                        .background(
                            selection == item ? Color("ButtonColor") : Color("ViewColor2").opacity(0.7)
                        )
                        .foregroundColor(
                            selection == item ? Color(.white) : Color(.white)
                        )
                        .cornerRadius(10)
                }
            }
            
        }
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
    }
}


struct WeightRepsInputView_Previews: PreviewProvider {
    static var previews: some View {
        WeightRepsInputView(
            weightInput: .constant(""),
            weightInputUnit: .constant(.kg),
            repsInput: .constant(""),
            onSave: { _, _, _ in },
            onCancel: {}
        )
        //        .previewLayout(.sizeThatFits) // Makes preview fit the size of the content
    }
}
