//
//  HomeView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct HomeView: View {
    @State private var isPresented = false
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading) {
                Text("FitnessPad")
                    .font(.system(size: 43))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                    .padding(.leading, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                            homeScreenImage(imageName: "MainScreenImage")
                            homeScreenImage(imageName: "MainScreenImage2")
                            homeScreenImage(imageName: "MainScreenImage3")
                            homeScreenImage(imageName: "MainScreenImage4")
                            homeScreenImage(imageName: "MainScreenImage5")
                    }
                }
            }
            
            VStack {
                HStack(spacing: 50) {
                        Text("Add your training day")
                            .font(.system(size: 23)).foregroundColor(.white)

                        Button(action: {self.isPresented.toggle()}) {
                            Image("plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(minWidth: 30, maxWidth: 60, minHeight: 30, maxHeight: 60 )
                                .foregroundColor(.white)
                        }
                        .fullScreenCover(isPresented: $isPresented, content: { NewTrainingDayView() })
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 50)
            .padding(.bottom, 120)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


struct homeScreenImage: View {
    var imageName = ""
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, minHeight: 380, maxHeight: 478)
    }
}
