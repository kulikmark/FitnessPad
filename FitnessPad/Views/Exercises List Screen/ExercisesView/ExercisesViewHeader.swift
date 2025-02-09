//
//  exercisesViewTitle.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.02.2025.
//

import SwiftUI

struct ExercisesViewHeader: View {
    @Binding var isSearchBarVisible: Bool
    
    var body: some View {
        HStack {
            Text("exercises_list_title".localized)
                .font(.system(size: 24))
                .fontWeight(.medium)
                .foregroundColor(Color("TextColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Button(action: {
                withAnimation {
                    isSearchBarVisible.toggle()
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(Color("TextColor"))
            }
        }
        .padding(.horizontal)
    }
}
