//
//  CreatedTrainingDayView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 28.03.2022.
//

import SwiftUI

struct CreatedTrainingDayView: View {
    @ObservedObject var viewModel: TrainingsViewModel
    @State private var isPresented = false
    var chosenExerciseType: ExerciseType
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                Text("New Training")
                    .font(.system(size: 43))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text("\(viewModel.chosenDate, formatter: dateFormatter)")
                    .font(.system(size: 27))
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            //MARK: Adding exercise here
            VStack {
                ForEach ($viewModel.exercisesArray) { $item in ChosenExerciseView(exercise: $item)
                }
            }
            
            
            VStack (spacing: 30) {
                
                HStack(spacing: 30) {
                    Text("Add another exercise")
                        .font(.system(size: 23)).foregroundColor(.white)
                    Button {
                        self.isPresented.toggle()
                        
                    } label: {
                        Image("plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(minWidth: 30, maxWidth: 60, minHeight: 30, maxHeight: 60)
                    }
                    .fullScreenCover(isPresented: $isPresented, content: {
                        ExercisesView(viewModel: ExercisesViewModel(), trainingsViewModel: viewModel)
                    })
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Button {
                        
                    } label: {
                        Text("Done")
                            .font(.system(size: 27))
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                            .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
                    }
                }
                .cornerRadius(15, corners: .allCorners)
                .padding(.horizontal, 50)
                
            }
            .padding(.top, 30)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
    }
}

struct CreatedTrainingDayView_Previews: PreviewProvider {
    static var previews: some View {
        CreatedTrainingDayView(viewModel: TrainingsViewModel(), chosenExerciseType: .pullups)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
