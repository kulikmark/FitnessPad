//
//  LaunchScreenView 2.swift
//  FitnessPad
//
//  Created by Марк Кулик on 17.01.2025.
//


import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    @Binding var isAnimationComplete: Bool // Принимаем флаг как Binding

    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                Text("Fitness")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color("TextColor"))
                    .padding(.top, 16)
                    .offset(x: isAnimating ? 0 : -UIScreen.main.bounds.width) // Вылетает слева
                    .animation(.bouncy(duration: 1), value: isAnimating)
                
                Image(systemName: "text.book.closed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Color("TextColor"))
                    .scaleEffect(isAnimating ? 1 : 0.1) // Иконка увеличивается
                    .animation(.bouncy(duration: 1), value: isAnimating)
                
                Text("Pad")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color("TextColor"))
                    .padding(.top, 16)
                    .offset(x: isAnimating ? 0 : UIScreen.main.bounds.width) // Вылетает справа
                    .animation(.bouncy(duration: 1), value: isAnimating)
            }
            .onAppear {
                isAnimating = true // Запуск анимации вылета текста и иконки
                
                // Устанавливаем задержку для завершения анимации
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isAnimationComplete = true // Анимация завершена
                }
            }
        }
    }
}
