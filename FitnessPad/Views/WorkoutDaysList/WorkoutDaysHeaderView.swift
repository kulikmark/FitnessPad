//
//  WorkoutDaysHeaderView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.08.2024.
//

import SwiftUI

struct WorkoutDaysHeaderView: View {
    @Binding var showSearchBar: Bool
    @Binding var searchText: String

    var body: some View {
        VStack {
            HStack {
                Text("My Workout Days")
                    .font(.system(size: 43, weight: .medium))
                    .foregroundColor(Color("TextColor"))
                    .padding(.leading, 20)
                    .padding(.top, 20)
                
//                Spacer()
                
                Button(action: {
                    withAnimation {
                        showSearchBar.toggle()
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title)
                        .foregroundColor(Color("TextColor"))
                        .padding()
                }
            }
            .padding(.top, 20)
            
            if showSearchBar {
                SearchBar(text: $searchText)
                    .padding(.horizontal, 20)
            }
        }
    }
}
