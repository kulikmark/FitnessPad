//
//  DeleteHintView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.08.2024.
//

import SwiftUI

struct DeleteHintView: View {
    @Binding var showDeleteHint: Bool
    @State private var hintOffset: CGFloat = -UIScreen.main.bounds.width // Начальное значение за экраном слева
    
    var body: some View {
        if showDeleteHint {
            HStack {
                Text("Swipe left on a day to delete it")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("ViewColor"))
                    .cornerRadius(10)
                    .offset(x: hintOffset) // Применение смещения
                    .animation(.easeOut(duration: 0.5), value: hintOffset)
                
                Button(action: {
                    withAnimation {
                        // Анимация скрытия
                        hintOffset = -UIScreen.main.bounds.width
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                showDeleteHint = false
                            }
                        }
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .padding()
                }
                .offset(x: hintOffset) // Применение смещения
                .animation(.easeOut(duration: 0.5), value: hintOffset)
            }
            .onAppear {
                // Анимация появления
                withAnimation(.easeOut(duration: 0.5)) {
                    hintOffset = 0
                }
            }
            
            .padding(.horizontal, 20)
            .transition(.move(edge: .leading)) // Переход для удаления
        }
    }
        
}



//struct DeleteHintView: View {
//    @Binding var showDeleteHint: Bool
//    
//    var body: some View {
//        if showDeleteHint {
//            HStack {
//                Text("Swipe left on a day to delete it")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color("ViewColor"))
//                    .cornerRadius(10)
////                    .shadow(radius: 10)
//                Button(action: {
//                    withAnimation {
//                        showDeleteHint = false
//                    }
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.white)
//                        .padding()
//                }
//            }
//            .padding(.horizontal, 20)
//        }
//    }
//}
//
