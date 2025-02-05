//
//  ExerciseAttributes.swift
//  FitnessPad
//
//  Created by Марк Кулик on 16.01.2025.
//

import SwiftUI

struct ExerciseAttributes: View {
    @EnvironmentObject var viewModel: WorkoutDayViewModel
    @EnvironmentObject var exerciseService: ExerciseService
    var exercise: Exercise
    var set: ExerciseSet
    
    @FocusState private var isInputFocused: Bool
    @State private var showTimePicker = false
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 0

    var body: some View {
        let attributesArray = exercise.addedAttributes().map { $0.name ?? "" }
            .sorted { first, second in
                let order: [String] = [
                    NSLocalizedString("attribute_weight", comment: ""),
                    NSLocalizedString("attribute_reps", comment: ""),
                    NSLocalizedString("attribute_distance", comment: ""),
                    NSLocalizedString("attribute_time", comment: "")
                ]
                return order.firstIndex(of: first) ?? 0 < order.firstIndex(of: second) ?? 0
            }

        HStack {
            ForEach(attributesArray, id: \.self) { attribute in
                attributeField(for: attribute)
            }
        }
        .sheet(isPresented: $showTimePicker) {
            timePickerView()
        }
        .background(Color("BackgroundColor"))
    }

    // Функция для отображения TimePicker
    private func timePickerView() -> some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text(NSLocalizedString("select_time", comment: ""))
                    .font(.title2)
                    .foregroundStyle(Color("TextColor"))
                    .bold()
                    .padding(.top, 10)

                HStack(alignment: .center, spacing: 20) {
                    VStack {
                        Text(NSLocalizedString("hours", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Picker("Hours", selection: $selectedHours) {
                            ForEach(0..<24, id: \.self) { hour in
                                Text("\(hour)").tag(hour)
                                    .foregroundStyle(Color("TextColor"))
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 150)
                        .clipped()
                    }

                    VStack {
                        Text(NSLocalizedString("minutes", comment: ""))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(0..<60, id: \.self) { minute in
                                Text("\(minute)").tag(minute)
                                    .foregroundStyle(Color("TextColor"))
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 150)
                        .clipped()
                    }
                }
                .padding(.horizontal, 20)

                Button(action: {
                    showTimePicker = false
                    set.time = Double(selectedHours * 3600 + selectedMinutes * 60)
//                    viewModel.saveContext()
                    exerciseService.saveContext()
                }) {
                    Text(NSLocalizedString("done", comment: ""))
                        .font(.headline)
                        .foregroundColor(Color("ButtonTextColor"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
            .frame(maxWidth: .infinity)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .onAppear {
            selectedHours = Int(set.time) / 3600
            selectedMinutes = (Int(set.time) % 3600) / 60
        }
    }

    private func attributeField(for attribute: String) -> some View {
        switch attribute {
        case NSLocalizedString("attribute_weight", comment: ""):
            if exercise.attribute(for: NSLocalizedString("attribute_weight", comment: "")) != nil {
                return AnyView(
                    HStack {
                        dataInputField(
                            placeholder: NSLocalizedString("attribute_weight", comment: ""),
                            value: Binding(
                                get: {
                                    if set.weight == 0.0 {
                                        return ""
                                    } else {
                                        return isInputFocused ? "\(set.weight)" : "\(set.weight) kg"
                                    }
                                },
                                set: { newValue in
                                    let cleanedValue = newValue.replacingOccurrences(of: ",", with: ".")
                                    set.weight = Double(cleanedValue) ?? set.weight
                                }
                            ),
                            keyboardType: .decimalPad
                        )
                        .focused($isInputFocused)
                        .onSubmit {
                            isInputFocused = false
                            exerciseService.saveContext()
                        }
                        .submitLabel(.done)
                    }
                )
            }
        case NSLocalizedString("attribute_distance", comment: ""):
            if exercise.attribute(for: NSLocalizedString("attribute_distance", comment: "")) != nil {
                return AnyView(
                    HStack {
                        dataInputField(
                            placeholder: NSLocalizedString("attribute_distance", comment: ""),
                            value: Binding(
                                get: {
                                    if set.distance == 0.0 {
                                        return ""
                                    } else {
                                        return isInputFocused ? "\(set.distance)" : "\(set.distance) km"
                                    }
                                },
                                set: { newValue in
                                    let cleanedValue = newValue.replacingOccurrences(of: ",", with: ".")
                                    set.distance = Double(cleanedValue) ?? set.distance
                                }
                            ),
                            keyboardType: .decimalPad
                        )
                        .focused($isInputFocused)
                        .onSubmit {
                            isInputFocused = false
                            exerciseService.saveContext()
                        }
                        .submitLabel(.done)
                    }
                )
            }
        case NSLocalizedString("attribute_reps", comment: ""):
            if exercise.attribute(for: NSLocalizedString("attribute_reps", comment: "")) != nil {
                return AnyView(
                    HStack {
                        dataInputField(
                            placeholder: NSLocalizedString("attribute_reps", comment: ""),
                            value: Binding(
                                get: {
                                    if set.reps == 0 {
                                        return ""
                                    } else {
                                        return isInputFocused ? "\(set.reps)" : "\(set.reps)"
                                    }
                                },
                                set: { newValue in
                                    set.reps = Int16(newValue) ?? set.reps
                                }
                            ),
                            keyboardType: .numberPad
                        )
                        .focused($isInputFocused)
                        .onSubmit {
                            isInputFocused = false
                            exerciseService.saveContext()
                        }
                        .submitLabel(.done)
                    }
                )
            }
        case NSLocalizedString("attribute_time", comment: ""):
            if exercise.attribute(for: NSLocalizedString("attribute_time", comment: "")) != nil {
                return AnyView(
                    HStack {
                        TextField(NSLocalizedString("attribute_time", comment: ""), text: .constant(set.time == 0.0 ? "" : formatTime(set.time)))
                            .padding(10)
                            .background(Color(.systemBackground))
                            .foregroundColor(Color(.label))
                            .cornerRadius(8)
                            .multilineTextAlignment(.center)
                            .disabled(true)
                            .onTapGesture {
                                showTimePicker = true
                            }
                    }
                )
            }
        default:
            return AnyView(EmptyView())
        }
        return AnyView(EmptyView())
    }

    // Форматирование времени в формат "00h 00m"
    private func formatTime(_ time: Double) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        return String(format: "%02dh %02dm", hours, minutes)
    }

    private func dataInputField(placeholder: String, value: Binding<String>, keyboardType: UIKeyboardType) -> some View {
        TextField(placeholder, text: value)
            .padding(10)
            .background(Color(.systemBackground))
            .foregroundColor(.gray)
            .cornerRadius(8)
            .multilineTextAlignment(.center)
            .keyboardType(keyboardType)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}
