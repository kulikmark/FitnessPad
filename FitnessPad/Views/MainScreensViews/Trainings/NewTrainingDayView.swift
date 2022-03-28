//
//  NewTrainingDayView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 23.03.2022.
//

import SwiftUI

struct NewTrainingDayView: View {
    @EnvironmentObject var viewModel: TrainingsViewModel
    @State var isPresented = false
    var body: some View {
        
        let dateRange: ClosedRange<Date> = {
            let calendar = Calendar.current
            let startComponents = DateComponents(year: 2022, month: 1, day: 1)
            let endComponents = DateComponents(year: 2100, month: 12, day: 31, hour: 23, minute: 59, second: 59)
            return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
        }()
        
        ScrollView(showsIndicators: false) {
            ZStack {
                VStack(spacing:45) {
                    Text("Choose your training date")
                        .font(.system(size: 33))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    Group {
                        DatePicker("", selection: $viewModel.chosenDate, in: dateRange, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .colorInvert()
                            .accentColor(.black)
                            .frame(width: 380, height: 380)
                            .padding()
                    }
                    .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1), in: RoundedRectangle(cornerRadius: 20))
                    
                    //                    VStack {
                    //                        Text("\(viewModel.chosenDate)")
                    //                            .font(.system(size: 33))
                    //                            .fontWeight(.medium)
                    //                            .foregroundColor(.white)
                    //                    }
                    
                    HStack(spacing: 50) {
                        Text("Choose your exercise")
                            .font(.system(size: 23)).foregroundColor(.white)
                        
                        Button {
                            self.isPresented.toggle()
                            
                        } label: {
                            Image("plus")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .foregroundColor(.white)
                        }
                        .fullScreenCover(isPresented: $isPresented, content: { ExercisesView() })
                    }
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
        
    }
}

struct NewTrainingDayView_Previews: PreviewProvider {
    static var previews: some View {
        NewTrainingDayView()
            .environmentObject(TrainingsViewModel())
    }
}
