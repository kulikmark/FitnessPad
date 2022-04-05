//
//  CreatedTrainingDayView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 28.03.2022.
//

import SwiftUI

struct CreatedTrainingDayView: View {
    @EnvironmentObject var viewModel: TrainingsViewModel
    @State private var isPresented = false
    @Binding var chosenExercise: String
    @State private var text1: String = ""
    @State private var text2: String = ""
    
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
            
            ForEach (viewModel.exercisesArray) { item in
                ChosenExerciseView()
               
                Text(viewModel.exercisesArray.description)
            }
            
           

            VStack (spacing: 30) {
                HStack(spacing: 30) {
                    Text("Set 1")
                        .font(.system(size: 27))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                    
                    TextField("Weight", text: $text1)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 90, maxWidth: .infinity, minHeight: 70, maxHeight: 70)
                        .font(.system(size: 23))
                        .background()
                        .cornerRadius(15, corners: .allCorners)
                    
                    TextField("Reps", text: $text2)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 90, maxWidth: .infinity, minHeight: 70, maxHeight: 70)
                        .font(.system(size: 23))
                        .background()
                        .cornerRadius(15, corners: .allCorners)
                }
                .padding(.horizontal, 10)
                
                HStack(spacing: 50) {
                    Text("Add another set")
                        .font(.system(size: 23)).foregroundColor(.white)
                    
                    Button {
                        
                    } label: {
                        Image("plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 30, maxWidth: 60, minHeight: 30, maxHeight: 60 )
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                Spacer()
                
//                //MARK: Adding exercise here
//                ForEach (viewModel.exercisesArray) { exercise in
//                    ChosenExerciseView()
//                }
                
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
                    .fullScreenCover(isPresented: $isPresented, content: { ExercisesView(exercises: Exercise.exercises) })
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
        CreatedTrainingDayView(chosenExercise: .constant(""))
            .environmentObject(TrainingsViewModel())
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
