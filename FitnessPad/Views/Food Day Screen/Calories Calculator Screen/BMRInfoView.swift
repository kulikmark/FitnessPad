//
//  BMRInfoView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

struct BMRInfoView: View {
    @Binding var showBMRInfo: Bool
    
    // MARK: - BMR Info View
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("What is BMR?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                
                Spacer()
                
                // Close button
                Button(action: {
                    showBMRInfo = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
            }
            
            // BMR Explanation
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("BMR (Basal Metabolic Rate) is your basal metabolism or basal metabolic rate. It is the number of calories your body burns at complete rest to maintain vital functions such as breathing, blood circulation, organ function, and maintaining body temperature.")
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                   
                    Text("BMR is the minimum amount of energy your body needs to function at rest.")
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                    
                    Text("It does not account for physical activity, food digestion, or other additional energy expenditures.")
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                    
                    Text("BMR depends on factors such as:")
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .padding(.top, 8)
                    
                    Group {
                        Text("• **Weight**: The higher your body mass, the higher your BMR.")
                        Text("• **Height**: Taller people usually have a higher BMR.")
                        Text("• **Age**: BMR decreases with age.")
                        Text("• **Gender**: Men typically have a higher BMR than women due to greater muscle mass.")
                        Text("• **Body Composition**: Muscle mass increases BMR, while fat tissue decreases it.")
                    }
                    .font(.body)
                    .foregroundColor(Color("TextColor"))
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
    }
}

//#Preview {
//    BMRInfoView()
//}
