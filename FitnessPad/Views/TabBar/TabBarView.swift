//
//  TabBarView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct TabBarView: View {
    @AppStorage ("selectedTab") var selectedTab: Tab = .home
    
    var body: some View {
        
        ZStack {
            HStack {
                ForEach(tabItems) { item in
                    Button {
                        withAnimation(.easeOut) {
                            selectedTab = item.tabItem
                        }
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
                    .scaleEffect(selectedTab == item.tabItem ? 1.3 : 1.0)
                }
                
            }
            .frame(height: 120)
            .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
            .cornerRadius(30, corners: [.topLeft, .topRight])
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.bottom)
        
    }
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
