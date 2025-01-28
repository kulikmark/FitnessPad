//
//  ExerciseAttributes.swift
//  FitnessPad
//
//  Created by Марк Кулик on 16.01.2025.
//

import SwiftUI

struct ExerciseAttributes: View {
    @EnvironmentObject var viewModel: WorkoutViewModel
    var exercise: Exercise
    var set: ExerciseSet
    
    @FocusState private var isInputFocused: Bool
    @State private var showTimePicker = false // Состояние для отображения DatePicker
    @State private var selectedHours: Int = 0 // Часы
    @State private var selectedMinutes: Int = 0 // Минуты

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
        .sheet(isPresented: $showTimePicker) {
            timePickerView() // Вызываем функцию для отображения TimePicker
        }
        .background(Color("BackgroundColor"))
    }

    // Функция для отображения TimePicker
    private func timePickerView() -> some View {
        ZStack {
            // Фон для всего sheet
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all) // Игнорируем безопасные области

            VStack(spacing: 20) {
                // Заголовок
                Text("Select Time")
                    .font(.title2)
                    .foregroundStyle(Color("TextColor"))
                    .bold()
                    .padding(.top, 10)

                // Пикер для выбора часов и минут
                HStack(alignment: .center, spacing: 20) {
                    // Пикер для часов
                    VStack {
                        Text("Hours")
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

                    // Пикер для минут
                    VStack {
                        Text("Minutes")
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

                // Кнопка для подтверждения выбора
                Button(action: {
                    showTimePicker = false
                    // Сохраняем выбранное время в set.time (в секундах)
                    set.time = Double(selectedHours * 3600 + selectedMinutes * 60)
                    viewModel.saveContext()
                }) {
                    Text("Done")
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
        .presentationDragIndicator(.visible) // Показываем индикатор перетаскивания
        .onAppear {
            // Инициализируем selectedHours и selectedMinutes при открытии пикера
            selectedHours = Int(set.time) / 3600
            selectedMinutes = (Int(set.time) % 3600) / 60
        }
    }

    private func attributeField(for attribute: String) -> some View {
        switch attribute {
        case "Weight":
            if exercise.attribute(for: "Weight") != nil {
                return AnyView(
                    HStack {
                        // Поле ввода для веса
                        dataInputField(
                            placeholder: "Weight",
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
                            viewModel.saveContext()
                        }
                        .submitLabel(.done)
                    }
                )
            }
        case "Distance":
            if exercise.attribute(for: "Distance") != nil {
                return AnyView(
                    HStack {
                        // Поле ввода для расстояния
                        dataInputField(
                            placeholder: "Distance",
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
                            viewModel.saveContext()
                        }
                        .submitLabel(.done)
                    }
                )
            }
        case "Reps":
            if exercise.attribute(for: "Reps") != nil {
                return AnyView(
                    HStack {
                        // Поле ввода для повторений
                        dataInputField(
                            placeholder: "Reps",
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
                            viewModel.saveContext()
                        }
                        .submitLabel(.done)
                    }
                )
            }
        case "Time":
            if exercise.attribute(for: "Time") != nil {
                return AnyView(
                    HStack {
                        // Текстовое поле для отображения времени
                        TextField("Time", text: .constant(set.time == 0.0 ? "" : formatTime(set.time)))
                            .padding(10)
                            .background(Color(.systemBackground)) // Используем системный цвет фона
                                               .foregroundColor(Color(.label)) // Используем системный цвет текста
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
            .background(Color(.systemBackground)) // Используем системный цвет фона
            .foregroundColor(.gray) // Используем системный цвет текста
            .cornerRadius(8)
            .multilineTextAlignment(.center)
            .keyboardType(keyboardType)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}
