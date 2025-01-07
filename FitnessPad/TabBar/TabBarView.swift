//
//  TabBarView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var image: String
    var tabItem: Tab
}

var tabItems = [
    TabItem(text: "Home", image: "home", tabItem: .home),
    TabItem(text: "Workouts", image: "workoutDays", tabItem: .workoutDays),
    TabItem(text: "Exercises", image: "exercises", tabItem: .exercises),
    TabItem(text: "Progress", image: "progressIcon", tabItem: .progress)
]

enum Tab: String {
    case home
    case workoutDays
    case exercises
    case progress
}

struct TabBarView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                ForEach(tabItems) { item in
                    Button {
                        withAnimation(.interactiveSpring()) {
                            selectedTab = item.tabItem
                        }
                    } label: {
                        VStack {
                            Image(item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: selectedTab == item.tabItem ? 20 : 15, height: selectedTab == item.tabItem ? 20 : 15) // Увеличиваем размер изображения
                            
                            Text(item.text)
                                .foregroundColor(Color("TextColor"))
                                .font(.system(size: selectedTab == item.tabItem ? 12 : 10)) // Увеличиваем размер текста
                        }
                        .padding(.horizontal, 20)
                    }
                    .animation(.spring(duration: 0.3), value: selectedTab) // Добавляем анимацию
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(.top, 10)
            .padding(.bottom, 20)
            .background(
                (Color("ViewColor"))
            )
            .clipShape(CustomRoundedRectangle(cornerRadius: 5, corners: [.topLeft, .topRight]))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.bottom) // Игнорируем безопасную зону внизу
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

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
