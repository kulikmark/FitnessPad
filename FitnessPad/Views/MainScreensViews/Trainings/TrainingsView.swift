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
        
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("My Trainings")
                        .font(.system(size: 43))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)

                        TrainingDay().environmentObject(viewModel)
                }
            }
        }
        .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
    }
}

struct TrainingsView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingsView()
            .environmentObject(TrainingsViewModel())
    }
}
