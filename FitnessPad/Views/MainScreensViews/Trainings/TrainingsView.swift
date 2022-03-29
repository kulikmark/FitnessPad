//
//  TrainingsView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI

struct TrainingsView: View {
    @EnvironmentObject var viewModel: TrainingsViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Text("My Trainings")
                    .font(.system(size: 43))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                ForEach(1..<2) { trainingDay in
                    TrainingDay().environmentObject(viewModel)
                }
            }
        }
        .frame(height: 750)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
    }
}

struct TrainingsView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingsView()
            .environmentObject(TrainingsViewModel())
    }
}
