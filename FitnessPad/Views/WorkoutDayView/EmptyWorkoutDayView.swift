//
//  EmptyWorkoutDayView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.01.2025.
//

import SwiftUI

struct EmptyWorkoutDayView: View {

    @Binding var selectedDate: Date
    
    var body: some View {
        VStack (spacing: 30) {
            Spacer()
            Image("emptyWorkoutDay")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: 150)
            
            Text("No workout found for \(selectedDate.formattedDate()). Create one and add exercises in the calendar.")
                .font(.footnote)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("ViewColor").opacity(0.2))
                .cornerRadius(15)
                .padding(.horizontal, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundColor"))
    }
}


#Preview {
    EmptyWorkoutDayView(selectedDate: .constant(Date()))
}
