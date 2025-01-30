//
//  CaloriesCalculator.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.01.2025.
//

import SwiftUI

struct CaloriesCalculator: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: WorkoutViewModel
    
    // States for calorie calculation
    @State private var goal = "Lose Weight"
    @State private var activityLevel = "Sedentary"
    @State private var weight = ""
    @State private var height = ""
    @State private var age = ""
    @State private var gender = "Male"
    
    @State private var bmr: Double = 0
    @State private var totalCalories: Double = 0
    @State private var protein: Double = 0
    @State private var fat: Double = 0
    @State private var carbs: Double = 0
    @State private var showingAlert = false
    
    // State for showing BMR info
    @State private var showBMRInfo = false
    
    let goals = ["Lose Weight", "Gain Muscle"]
    let activityLevels = ["Sedentary", "Lightly Active", "Moderately Active", "Very Active", "Extremely Active"]
    let genders = ["Male", "Female"]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Custom header
                Text("Calories Calculator")
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                CloseButtonCircle()
            }
            .padding()
            // Form
            Form {
                Section {
                    // Goal
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Goal")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Picker("Goal", selection: $goal) {
                            ForEach(goals, id: \.self) { Text($0) }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Activity Level
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Activity Level")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Picker("Activity Level", selection: $activityLevel) {
                            ForEach(activityLevels, id: \.self) { Text($0) }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    // Gender
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Gender")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Picker("Gender", selection: $gender) {
                            ForEach(genders, id: \.self) { Text($0) }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Weight
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Weight (kg)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        TextField("Enter weight", text: $weight)
                            .keyboardType(.decimalPad)
                    }
                    
                    // Height
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Height (cm)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        TextField("Enter height", text: $height)
                            .keyboardType(.decimalPad)
                    }
                    
                    // Age
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Age (years)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        TextField("Enter age", text: $age)
                            .keyboardType(.decimalPad)
                    }
                }
                .frame(height: 70)
            }
            .scrollContentBackground(.hidden) // Hide form background
            .background(Color("BackgroundColor")) // Set background color
            
            // Display Results
            if totalCalories > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("BMR: \(bmr, specifier: "%.2f") kcal")
                            .foregroundColor(Color("TextColor"))
                        
                        // Info button for BMR
                        Button(action: {
                            showBMRInfo = true
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Text("Total Calories: \(totalCalories, specifier: "%.2f") kcal")
                        .foregroundColor(Color("TextColor"))
                    Text("Protein: \(protein, specifier: "%.2f") g")
                        .foregroundColor(Color("TextColor"))
                    Text("Fat: \(fat, specifier: "%.2f") g")
                        .foregroundColor(Color("TextColor"))
                    Text("Carbs: \(carbs, specifier: "%.2f") g")
                        .foregroundColor(Color("TextColor"))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 10)
            }
            
            // Calculate Calories Button
            Button(action: calculateCalories) {
                Text("Calculate Calories")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("ButtonColor"))
                    .foregroundColor(Color("ButtonTextColor"))
                    .cornerRadius(10)
            }
            .padding()
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
//        .simultaneousGesture(TapGesture().onEnded {
//            UIApplication.shared.endEditing(true)
//        })
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Please enter valid data."), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showBMRInfo) {
            BMRInfoView(showBMRInfo: $showBMRInfo)
        }
    }
    
    // Function to calculate calories
    func calculateCalories() {
        guard let weight = Double(weight),
              let height = Double(height),
              let age = Double(age) else {
            showingAlert = true
            return
        }
        
        // Calculate BMR
        if gender == "Male" {
            bmr = 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age)
        } else {
            bmr = 447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * age)
        }
        
        let activityMultiplier: Double
        switch activityLevel {
        case "Sedentary":
            activityMultiplier = 1.2
        case "Lightly Active":
            activityMultiplier = 1.375
        case "Moderately Active":
            activityMultiplier = 1.55
        case "Very Active":
            activityMultiplier = 1.725
        default:
            activityMultiplier = 1.9
        }
        
        totalCalories = bmr * activityMultiplier
        
        // Calculate Macronutrients
        if goal == "Lose Weight" {
            totalCalories -= 500 // Calorie deficit for weight loss
        } else {
            totalCalories += 500 // Calorie surplus for muscle gain
        }
        
        protein = (totalCalories * 0.3) / 4 // 30% of calories from protein
        fat = (totalCalories * 0.3) / 9     // 30% of calories from fat
        carbs = (totalCalories * 0.4) / 4   // 40% of calories from carbs
    }
}

// MARK: - BMR Info View
import SwiftUI

struct BMRInfoView: View {
    @Binding var showBMRInfo: Bool
    
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

// MARK: - Preview
struct CaloriesCalculator_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock ViewModel for the preview
        let viewModel = WorkoutViewModel()
        
        // Display the CaloriesCalculator in the preview
        CaloriesCalculator()
            .environmentObject(viewModel)
            .preferredColorScheme(.dark) // Test in dark mode
    }
}
