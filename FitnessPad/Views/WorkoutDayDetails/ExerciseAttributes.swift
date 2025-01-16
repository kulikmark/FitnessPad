//
//  ExerciseAttributes.swift
//  FitnessPad
//
//  Created by Марк Кулик on 16.01.2025.
//

//import SwiftUI
//
//struct ExerciseAttributes: View {
//    @ObservedObject var viewModel: WorkoutViewModel
//    var exercise: Exercise
//    var set: ExerciseSet
//
//    var body: some View {
//        // Преобразуем NSSet в массив и сортируем его по фиксированному порядку
//        let attributesArray = exercise.addedAttributes().map { $0.name ?? "" }
//            .sorted { first, second in
//                let order: [String] = ["Weight", "Reps", "Distance", "Time"]
//                return order.firstIndex(of: first) ?? 0 < order.firstIndex(of: second) ?? 0
//            }
//
//        HStack {
//            ForEach(attributesArray, id: \.self) { attribute in
//                attributeField(for: attribute)
//            }
//        }
//    }
//
//    private func attributeField(for attribute: String) -> some View {
//        // Проверка на наличие атрибута с использованием расширения
//        switch attribute {
//        case "Weight":
//            if exercise.attribute(for: "Weight") != nil {
//                return AnyView(dataInputField(
//                    placeholder: "Weight",
//                    value: Binding(
//                        get: { set.weight > 0 ? "\(set.weight) kg" : "" },
//                        set: { newValue in
//                            let trimmedValue = newValue.replacingOccurrences(of: " kg", with: "")
//                            set.weight = Double(trimmedValue.replacingOccurrences(of: ",", with: ".")) ?? 0
//                            viewModel.saveContext()
//                        }
//                    ),
//                    keyboardType: .decimalPad
//                ))
//            }
//        case "Reps":
//            if exercise.attribute(for: "Reps") != nil {
//                return AnyView(dataInputField(
//                    placeholder: "Reps",
//                    value: Binding(
//                        get: { set.reps > 0 ? "\(set.reps)" : "" },
//                        set: { newValue in
//                            set.reps = Int16(newValue) ?? 0
//                            viewModel.saveContext()
//                        }
//                    ),
//                    keyboardType: .numberPad
//                ))
//            }
//        case "Distance":
//            if exercise.attribute(for: "Distance") != nil {
//                return AnyView(dataInputField(
//                    placeholder: "Distance",
//                    value: Binding(
//                        get: { set.distance > 0 ? "\(set.distance) km" : "" },
//                        set: { newValue in
//                            let trimmedValue = newValue.replacingOccurrences(of: " km", with: "")
//                            set.distance = Double(trimmedValue.replacingOccurrences(of: ",", with: ".")) ?? 0
//                            viewModel.saveContext()
//                        }
//                    ),
//                    keyboardType: .decimalPad
//                ))
//            }
//        case "Time":
//            if exercise.attribute(for: "Time") != nil {
//                return AnyView(dataInputField(
//                    placeholder: "Time",
//                    value: Binding(
//                        get: { formatTime(set.time) },
//                        set: { newValue in
//                            set.time = parseTime(newValue)
//                            viewModel.saveContext()
//                        }
//                    ),
//                    keyboardType: .numbersAndPunctuation
//                ))
//            }
//        default:
//            return AnyView(EmptyView())
//        }
//        return AnyView(EmptyView())
//    }
//
//    private func formatTime(_ time: Double) -> String {
//        let hours = Int(time) / 3600
//        let minutes = (Int(time) % 3600) / 60
//        return String(format: "%02d h : %02d m", hours, minutes)
//    }
//
//    private func parseTime(_ timeString: String) -> Double {
//        let cleanedString = timeString.replacingOccurrences(of: " h", with: "")
//                                          .replacingOccurrences(of: " m", with: "")
//                                          .replacingOccurrences(of: ":", with: "")
//        let components = cleanedString.split(separator: " ")
//        guard components.count == 2,
//              let hours = Double(components[0]),
//              let minutes = Double(components[1]) else {
//            return 0
//        }
//        return hours * 3600 + minutes * 60
//    }
//
//    private func dataInputField(placeholder: String, value: Binding<String>, keyboardType: UIKeyboardType) -> some View {
//        TextField(placeholder, text: value)
//            .padding(5)
//            .background(Color(UIColor.secondarySystemBackground))
//            .foregroundColor(Color(UIColor.label))
//            .cornerRadius(5)
//            .multilineTextAlignment(.center)
//            .keyboardType(keyboardType)
//            .autocapitalization(.none)
//            .disableAutocorrection(true)
//    }
//}

import SwiftUI

struct ExerciseAttributes: View {
    @ObservedObject var viewModel: WorkoutViewModel
    var exercise: Exercise
    var set: ExerciseSet

    var body: some View {
        let attributesArray = exercise.addedAttributes().map { $0.name ?? "" }
            .sorted { first, second in
                let order: [String] = ["Weight", "Reps", "Distance", "Time"]
                return order.firstIndex(of: first) ?? 0 < order.firstIndex(of: second) ?? 0
            }

        HStack {
            ForEach(attributesArray, id: \.self) { attribute in
                attributeField(for: attribute)
            }
        }
        .padding(.vertical, 10) // Увеличиваем вертикальный отступ
    }

    private func attributeField(for attribute: String) -> some View {
        switch attribute {
        case "Weight":
            if exercise.attribute(for: "Weight") != nil {
                return AnyView(dataInputField(
                    placeholder: "Weight",
                    value: Binding(
                        get: { set.weight > 0 ? "\(set.weight) kg" : "" },
                        set: { newValue in
                            let trimmedValue = newValue.replacingOccurrences(of: " kg", with: "")
                            set.weight = Double(trimmedValue.replacingOccurrences(of: ",", with: ".")) ?? 0
                            viewModel.saveContext()
                        }
                    ),
                    keyboardType: .decimalPad
                ))
            }
        case "Reps":
            if exercise.attribute(for: "Reps") != nil {
                return AnyView(dataInputField(
                    placeholder: "Reps",
                    value: Binding(
                        get: { set.reps > 0 ? "\(set.reps)" : "" },
                        set: { newValue in
                            set.reps = Int16(newValue) ?? 0
                            viewModel.saveContext()
                        }
                    ),
                    keyboardType: .numberPad
                ))
            }
        case "Distance":
            if exercise.attribute(for: "Distance") != nil {
                return AnyView(dataInputField(
                    placeholder: "Distance",
                    value: Binding(
                        get: { set.distance > 0 ? "\(set.distance) km" : "" },
                        set: { newValue in
                            let trimmedValue = newValue.replacingOccurrences(of: " km", with: "")
                            set.distance = Double(trimmedValue.replacingOccurrences(of: ",", with: ".")) ?? 0
                            viewModel.saveContext()
                        }
                    ),
                    keyboardType: .decimalPad
                ))
            }
        case "Time":
            if exercise.attribute(for: "Time") != nil {
                return AnyView(dataInputField(
                    placeholder: "Time",
                    value: Binding(
                        get: { formatTime(set.time) },
                        set: { newValue in
                            set.time = parseTime(newValue)
                            viewModel.saveContext()
                        }
                    ),
                    keyboardType: .numbersAndPunctuation
                ))
            }
        default:
            return AnyView(EmptyView())
        }
        return AnyView(EmptyView())
    }

    private func formatTime(_ time: Double) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        return String(format: "%02d h : %02d m", hours, minutes)
    }

    private func parseTime(_ timeString: String) -> Double {
        let cleanedString = timeString.replacingOccurrences(of: " h", with: "")
                                          .replacingOccurrences(of: " m", with: "")
                                          .replacingOccurrences(of: ":", with: "")
        let components = cleanedString.split(separator: " ")
        guard components.count == 2,
              let hours = Double(components[0]),
              let minutes = Double(components[1]) else {
            return 0
        }
        return hours * 3600 + minutes * 60
    }

    private func dataInputField(placeholder: String, value: Binding<String>, keyboardType: UIKeyboardType) -> some View {
        TextField(placeholder, text: value)
            .padding(10) // Увеличиваем отступы
            .background(Color(UIColor.secondarySystemBackground))
            .foregroundColor(Color(UIColor.label))
            .cornerRadius(8) // Увеличиваем радиус скругления
            .multilineTextAlignment(.center)
            .keyboardType(keyboardType)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}
