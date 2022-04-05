//
//  ExercisesView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct ExercisesView: View {
    @EnvironmentObject var viewModel: TrainingsViewModel
    @State private var isPresented = false
    var exercises: [Exercise]
    let gridForm = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
     
            VStack(alignment: .leading, spacing: 20) {
                Text("Exercises")
                    .font(.system(size: 43))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                    .padding(.bottom, 20)
                VStack {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid (columns: gridForm) {
                            ForEach(exercises, id: \.id) { item in
                                Button {
                                    self.viewModel.chosenExercise = item.exerciseName
                                    self.isPresented.toggle()
                                    viewModel.addExercise(chosenExercise: .init(exerciseName: viewModel.chosenExercise, exerciseImage: ""))
                                } label: {
                                    VStack {
                                        Image(item.exerciseImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(minHeight: 150, maxHeight: 200, alignment: .top)
                                            .cornerRadius(15, corners: .allCorners)
                        
                                        VStack {
                                            Text("\(item.exerciseName)")
                                                .font(.system(size: 23))
                                                .fontWeight(.medium)
                                                .foregroundColor(.white)
                                                .padding(.vertical, 10)
                                        }
                                    }
                                    .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
                                    
                                }
                                .fullScreenCover(isPresented: $isPresented, content: { CreatedTrainingDayView(chosenExercise: $viewModel.chosenExercise) })
                                .cornerRadius(15, corners: .allCorners)
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                }
                .padding(.bottom, 70)
            }
        .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
        
        
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView(exercises: Exercise.exercises)
            .environmentObject(TrainingsViewModel())
    }
}
