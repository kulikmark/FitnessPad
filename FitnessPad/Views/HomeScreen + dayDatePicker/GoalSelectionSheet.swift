//
//  GoalSelectionSheet.swift
//  FitnessPad
//
//  Created by Марк Кулик on 10.08.2024.
//

import SwiftUI

struct GoalSelectionSheet: View {
    @Binding var selectedGoal: FitnessGoal?
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            Text("Select Your Fitness Goal")
                .foregroundColor(.white)
                .font(.headline)
                .padding(.top, 30)

            CustomSegmentedPickerForGoalSelection(
                selection: $selectedGoal,
                items: FitnessGoal.allCases
            )
            .padding(.horizontal, 20)

            Spacer()

            HStack {
                Button(action: {
                    onCancel()
                }) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("ViewColor2").opacity(0.7))
                        .cornerRadius(10)
                }

                Spacer()

                Button(action: {
                    onSave()
                }) {
                    Text("OK")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)

        }
        .background(Color("ViewColor")
            .edgesIgnoringSafeArea(.all))
    }
}

struct CustomSegmentedPickerForGoalSelection: View {
    @Binding var selection: FitnessGoal?
    let items: [FitnessGoal]
    
    var body: some View {
        VStack {
            ForEach(items, id: \.self) { item in
                Button(action: {
                    selection = item
                    
                }){
                    Text(item.rawValue)
                        .padding(.horizontal, 20)
                        .frame(height: 50)
                        .background(
                            selection == item ? Color("ButtonColor") : Color("ViewColor2").opacity(0.7)
                        )
                        .foregroundColor(
                            selection == item ? Color(.white) : Color(.white)
                        )
                        .cornerRadius(10)
                }
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding()
//        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
    }
}
