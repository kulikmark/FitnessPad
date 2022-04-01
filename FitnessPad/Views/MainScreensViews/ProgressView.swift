//
//  ProgressView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct ProgressView: View {
    
    var body: some View {
        
        
        VStack(alignment: .leading) {
            
            Text("Progress")
                .font(.system(size: 43))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.leading, 20)
                .padding(.bottom, 20)
            VStack {
            Image("progressImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 360)
                .padding(.vertical, 40)
                .padding(.horizontal, 10)
            
            VStack {
                HStack(spacing:25) {
                    VStack {
                        Text("Weights")
                            .font(.system(size: 43))
                            .fontWeight(.medium)
                            .foregroundColor(.white)

                        Text("increased by")
                            .font(.system(size: 27))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }

                        Text("5,9%")
                            .font(.system(size: 60))
                            
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 130)
                            .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
                            .cornerRadius(25, corners: .allCorners)
                            .padding(.trailing, 5)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 100)
        }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
