//
//  TabBarView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Tab
    @State private var animatingTab: Tab? = nil  // Отслеживание анимации

    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                ForEach(tabItems) { item in
                    Button {
                        selectedTab = item.tabItem
                        animatingTab = item.tabItem  // Запускаем анимацию
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            animatingTab = nil  // Отключаем анимацию после завершения
                        }
                    } label: {
                        VStack {
                            Image(systemName: item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .foregroundStyle(selectedTab == item.tabItem ? Color("TextColor") : Color.gray)
                                .scaleEffect(animatingTab == item.tabItem ? 1.2 : 1.0)  // Увеличиваем только выбранный таб
                                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animatingTab == item.tabItem)
                            
                            Text(item.text)
                                .foregroundStyle(selectedTab == item.tabItem ? Color("TextColor") : Color.gray)
                                .font(.system(size: 12))
                        }
                        .padding(.horizontal, 5)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(.top, 10)
            .padding(.bottom, 20)
            .background(Color("ViewColor"))
            .clipShape(CustomRoundedRectangle(cornerRadius: 10, corners: [.topLeft, .topRight]))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct CustomRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}

//struct TabBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBarView()
//    }
//}
