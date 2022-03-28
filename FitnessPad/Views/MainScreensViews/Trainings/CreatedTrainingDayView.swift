//
//  CreatedTrainingDayView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 28.03.2022.
//

import SwiftUI

struct CreatedTrainingDayView: View {
    @EnvironmentObject var viewModel: TrainingsViewModel
    var exercises = ["Pull-Ups"]
    @State var text1 = ""
    @State var text2 = ""
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
        
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("New Training")
                    .font(.system(size: 43))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                    
                Text("\(viewModel.chosenDate, formatter: dateFormatter)")
                    .font(.system(size: 27))
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .padding(.top, -5)
                    .padding(.bottom, 20)
                    
                ForEach(exercises, id: \.self) { exercise in
                    Button {
                       
                    } label: {
                        Text(exercise)
                            .font(.system(size: 27))
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .frame(width: 380, height: 60, alignment: .leading)
                            .padding(.leading, 20)
                            .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
                    }
                    .cornerRadius(15, corners: .allCorners)
                }
            }
            
            
            VStack (spacing: 30) {
                HStack(spacing: 30) {
                        Text("Set 1")
                            .font(.system(size: 27))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                      
                    TextField("0", text: $text1)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                            .frame(width: 125, height: 70)
                            .font(.system(size: 27))
                            .background()
                            .cornerRadius(15, corners: .allCorners)
                        
                    TextField("12", text: $text2)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                            .frame(width: 125, height: 70, alignment: .leading)
                            .font(.system(size: 27))
                            .background()
                            .cornerRadius(15, corners: .allCorners)
                }
                HStack(spacing: 30) {
                        Text("Set 2")
                            .font(.system(size: 27))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                      
                    TextField("Weight", text: $text1)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                            .frame(width: 125, height: 70)
                            .font(.system(size: 27))
                            .background()
                            .cornerRadius(15, corners: .allCorners)
                        
                    TextField("Reps", text: $text2)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                            .frame(width: 125, height: 70, alignment: .leading)
                            .font(.system(size: 27))
                            .background()
                            .cornerRadius(15, corners: .allCorners)
                }
                
                HStack(spacing: 50) {
                    Text("Add another set")
                        .font(.system(size: 23)).foregroundColor(.white)
                    
                    Button {
                        
                        
                    } label: {
                        Image("plus")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                HStack(spacing: 50) {
                    
                    Button {
                        
                    } label: {
                        Text("Done")
                            .font(.system(size: 27))
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 60, alignment: .center)
                            .padding(.leading, 20)
                            .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
                    }
                    }
                    .cornerRadius(15, corners: .allCorners)
                
                .padding()
            }
            .padding(.top, 30)
            
            
        }
        .onTapGesture {
            hideKeyboard()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
        .edgesIgnoringSafeArea(.all)
    }
}

struct CreatedTrainingDayView_Previews: PreviewProvider {
    static var previews: some View {
        CreatedTrainingDayView()
            .environmentObject(TrainingsViewModel())
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
