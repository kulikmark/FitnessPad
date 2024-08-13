////
////  CustomSegmentedPicker.swift
////  FitnessPad
////
////  Created by Марк Кулик on 10.08.2024.
////
//
//import SwiftUI
//
//struct CustomSegmentedPicker<T: Hashable & Identifiable & RawRepresentable>: View where T.RawValue == String {
//    @Binding var selection: T?
//    let items: [T]
//    
//    var body: some View {
//        HStack {
//            ForEach(items) { item in
//                Button(action: {
//                    selection = item
//                }) {
//                    Text(item.rawValue)
//                        .padding()
//                        .frame(height: 40)
//                        .background(
//                            selection == item ? Color("ButtonColor") : Color("ViewColor2").opacity(0.7)
//                        )
//                        .foregroundColor(
//                            selection == item ? Color(.white) : Color(.white)
//                        )
//                        .cornerRadius(10)
//                }
//            }
//        }
//        .background(Color.white.opacity(0.2))
//        .cornerRadius(10)
//    }
//}
