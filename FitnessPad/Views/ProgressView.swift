//
//  ProgressView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct ProgressView: View {
    
    var body: some View {
        VStack {
            
            Text("Progress")
                .font(.system(size: 43))
                .fontWeight(.medium)
                .foregroundColor(.black)
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
