//
//  TabBarView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct TabBarView: View {
    @State private var isPressed = false
    @State var selectedTab: Tab = .home
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .trainings:
                    TrainingsView()
                case .exercises:
                    ExercisesView()
                case .progress:
                    ProgressView()
                }
            }
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            
            HStack {
                ForEach(tabItems) {item in
                    Button {
                        selectedTab = item.tabItem
                    } label: {
                        VStack {
                            Image(item.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30, alignment: .center)
                                .frame(maxWidth: .infinity)
                            Text(item.text)
                                .foregroundColor(.white)
                                .font(.caption2)
                                .fontWeight(.medium)
                        }
                    }
                    .scaleEffect(
                        withAnimation(Animation.easeInOut(duration: 1)) {
                            selectedTab == item.tabItem ? 1.3 : 1.0
                        })
                }
            }
            .frame(height: 120)
            .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
            .cornerRadius(20, corners: [.topLeft, .topRight])
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
