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
 
            Image("progressImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 396, height: 360)
                .padding(.top, 30)
                .padding(.bottom, 40)
            
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
                            .font(.system(size: 73))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 190, height: 130)
                            .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
                            .cornerRadius(25, corners: .allCorners)
                }
            }
            .padding(.leading, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
