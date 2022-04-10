//
//  ChosenExerciseView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.04.2022.
//

import SwiftUI

struct ChosenExerciseView: View {
    @State private var isPresented = false
    @Binding var exercise: Exercise
    
    var body: some View {
        VStack {
        VStack {
            Text("\(exercise.exerciseName)")
                .font(.system(size: 27))
                .fontWeight(.regular)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .leading)
                .padding(.leading, 20)
                .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
                
        }
        .cornerRadius(15, corners: .allCorners)
        .padding(.horizontal, 10)
        
            ForEach ($exercise.exerciseSets) { $item in
                        HStack(spacing: 30) {
                            Text("Set \(item.count)")
                                .font(.system(size: 27))
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                            
                            TextField("Weight", text: $item.weight)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .frame(minWidth: 90, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                                .font(.system(size: 23))
                                .background()
                                .cornerRadius(15, corners: .allCorners)
                            
                            TextField("Reps", text: $item.reps)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .frame(minWidth: 90, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                                .font(.system(size: 23))
                                .background()
                                .cornerRadius(15, corners: .allCorners)
                        }
                        .padding(.horizontal, 10)
                        }
            
            HStack(spacing: 30) {
                Text("Add another set")
                    .font(.system(size: 14)).foregroundColor(.white)
                
                Button {
                    addSet()
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
    
    func addSet() {
            let count = exercise.exerciseSets.count
            exercise.exerciseSets.append(ExerciseSet(count:String(count+1), weight: "", reps: ""))
        }
}

struct ChosenExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ChosenExerciseView(exercise: .constant(Exercise(with: .pullups)))
    }
}

