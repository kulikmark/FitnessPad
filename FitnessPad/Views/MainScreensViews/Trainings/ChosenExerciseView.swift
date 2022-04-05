//
//  ChosenExerciseView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.04.2022.
//

import SwiftUI

struct ChosenExerciseView: View {
    @EnvironmentObject var viewModel: TrainingsViewModel
    @State var exerciseName: String
    
    var body: some View {
        VStack {
            Text("\(self.exerciseName)")
                .font(.system(size: 27))
                .fontWeight(.regular)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .leading)
                .padding(.leading, 20)
                .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
                
        }
        .cornerRadius(15, corners: .allCorners)
        .padding(.horizontal, 10)
    }
}

struct ChosenExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ChosenExerciseView(exerciseName: "")
            .environmentObject(TrainingsViewModel())
    }
}
