//
//  TrainingsListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.04.2022.
//

import SwiftUI

struct TrainingsListView: View {
    @ObservedObject var viewModel: TrainingsViewModel
    
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

                    TrainingDay(viewModel: viewModel)
                }
            }
        }
        .background(Color(red: 0, green: 0.397, blue: 0.712, opacity: 1))
    }
}

struct TrainingsListView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingsListView(viewModel: TrainingsViewModel())
            .environmentObject(TrainingsViewModel())
    }
}
