//
//  ExercisesView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct ExercisesView: View {
    
    var body: some View {
        VStack {
            
            Text("Exercises")
                .font(.system(size: 43))
                .fontWeight(.medium)
                .foregroundColor(.black)
        }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView()
    }
}
