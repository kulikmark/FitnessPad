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
    TabItem(text: "Workout days", image: "workoutDays", tabItem: .workoutDays),
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
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5)) {
                            selectedTab = item.tabItem
                        }
                    } label: {
                        VStack {
                            Image(item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 23, height: 23)
                            
                            Text(item.text)
                                .foregroundColor(Color("TextColor"))
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                        }
                        .padding()
                        .background(
                            selectedTab == item.tabItem ?
                            RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.2)) : nil
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .scaleEffect(selectedTab == item.tabItem ? 1.1 : 1.0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 70)
            .padding(.top, 10)
            .padding(.bottom, 25)
            .background(
                (Color("ViewColor"))
            )
            .clipShape(CustomRoundedRectangle(cornerRadius: 30, corners: [.topLeft, .topRight]))
            .shadow(radius: 10)
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
