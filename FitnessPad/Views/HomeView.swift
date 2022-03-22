//
//  HomeView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {

               
        VStack(spacing: 60) {
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("FitnessPad")
                                .font(.system(size: 43))
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.bottom, 50)
                                .padding(.leading, 21)
                            
                            Image("MainScreenImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 400, height: 478)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//                                .offset(x: -30, y: 20)
                            
                        }

                        VStack {
                            HStack(spacing: 50) {
                                    Text("Add your training day")
                                        .font(.system(size: 23)).foregroundColor(.white)
                                    Button {
                                        
                                    } label: {
                                        Image("plus")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 70, height: 70)
                                            .foregroundColor(.white)
                                    }
                                }
                            Spacer()
                        }
                    }
                .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
    
            }
        }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
