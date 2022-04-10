//
//  ChosenExerciseView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.04.2022.
//

import SwiftUI

struct ChosenExerciseView: View {
    @EnvironmentObject var viewModel: TrainingsViewModel
    @State private var isPresented = false
    @State var exerciseName: String
    @State var set = 1
    @State var weight: String = ""
    @State var reps: String = ""
    @State var setCounter: Int = 0
    
    var body: some View {
        VStack {
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
        
            HStack(spacing: 30) {
                Text("Set \(self.set)")
                    .font(.system(size: 27))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                
                TextField("Weight", text: self.$weight)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 90, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                    .font(.system(size: 23))
                    .background()
                    .cornerRadius(15, corners: .allCorners)
                
                TextField("Reps", text: self.$reps)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: 90, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                    .font(.system(size: 23))
                    .background()
                    .cornerRadius(15, corners: .allCorners)
            }
            .padding(.horizontal, 10)
            
            HStack(spacing: 30) {
                Text("Add another set")
                    .font(.system(size: 14)).foregroundColor(.white)
                
                Button {

                } label: {
                    Image("plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 10, maxWidth: 30, minHeight: 10, maxHeight: 30 )
                        .foregroundColor(.white)
                }
                
            }
            .padding()
        }
    }
}

struct ChosenExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ChosenExerciseView(exerciseName: "")
            .environmentObject(TrainingsViewModel())
    }
}

