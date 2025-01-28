//
//  LaunchScreenView 2.swift
//  FitnessPad
//
//  Created by Марк Кулик on 17.01.2025.
//


import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    @State private var isLogoZooming = false
    @State private var isLogoVisible = true

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
                        .animation(.bouncy(), value: isAnimating)
                    
                    Image(systemName: "text.book.closed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color("TextColor"))
                        .scaleEffect(isAnimating ? 1 : 0.1) // Иконка увеличивается
                        .animation(.bouncy(), value: isAnimating)
                    
                    Text("Pad")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color("TextColor"))
                        .padding(.top, 16)
                        .offset(x: isAnimating ? 0 : UIScreen.main.bounds.width) // Вылетает справа
                        .animation(.bouncy(), value: isAnimating)
                }
                .scaleEffect(isLogoZooming ? 10 : 1) // Логотип налетает на пользователя
                .opacity(isLogoZooming ? 0 : 1) // Логотип исчезает
                .animation(.easeIn(duration: 0.5).delay(2), value: isLogoZooming)
            
        }
        .onAppear {
            isAnimating = true // Запуск анимации вылета текста
        }
    }
}

#Preview {
    LaunchScreenView()
}
