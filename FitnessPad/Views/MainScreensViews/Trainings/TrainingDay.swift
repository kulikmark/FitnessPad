//
//  TrainingDay.swift
//  FitnessPad
//
//  Created by Марк Кулик on 25.03.2022.
//

import SwiftUI

struct TrainingDay: View {
    @ObservedObject var viewModel: TrainingsViewModel
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("\(viewModel.chosenDate, formatter: dateFormatter)")
                .font(.system(size: 43))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.leading)
            
            Text("")
                .font(.system(size: 27))
                .fontWeight(.regular)
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.leading)
            
        }
        .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 160)
        .background(Color(red: 0, green: 0.32, blue: 0.575, opacity: 1))
        .cornerRadius(15, corners: .allCorners)
        .padding(.horizontal , 20)
    }
}

struct TrainingDay_Previews: PreviewProvider {
   
    static var previews: some View {
        TrainingDay(viewModel: TrainingsViewModel())
    }
}
