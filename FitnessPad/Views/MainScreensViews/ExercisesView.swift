//
//  ExercisesView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct ExercisesView: View {
    @EnvironmentObject var viewModel: TrainingsViewModel
    @State var isPresented = false
    var exercises = ["Pull-Ups", "Push-Ups", "Pike Push-Ups", "Squat", "Pistol Squats", "Bench Press", "Shoulder Press", "Bicep Curls"]
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Exercises")
                    .font(.system(size: 43))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                    
                ForEach(exercises, id: \.self) { exercise in
                    Button {
                        self.isPresented.toggle()
                    } label: {
                        Text(exercise)
                            .font(.system(size: 27))
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .frame(width: 380, height: 60, alignment: .leading)
                            .padding(.leading, 20)
                            .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
                    }
                    .fullScreenCover(isPresented: $isPresented, content: { CreatedTrainingDayView() })
                    .cornerRadius(15, corners: .allCorners)
                    
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
        .edgesIgnoringSafeArea(.all)
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView()
    }
}
