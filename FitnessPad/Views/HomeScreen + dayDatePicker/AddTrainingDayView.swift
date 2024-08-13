//
//  AddTrainingDayView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.08.2024.
//

import SwiftUI
import CoreData

struct AddTrainingDayView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: WorkoutViewModel

    @Binding var selectedDate: Date
    @Binding var workoutDay: WorkoutDay?
    @Binding var selectedTab: Tab
    
    @State private var isCalendarExpanded = false
    @State private var isNavigationActive = false

    // Проверка, есть ли тренировка на выбранную дату
    private func hasWorkoutOnSelectedDate() -> Bool {
        return viewModel.workoutDays.contains { workoutDay in
            if let date = workoutDay.date {
                return Calendar.current.isDate(date, inSameDayAs: selectedDate)
            }
            return false
        }
    }

    private var buttonText: String {
        hasWorkoutOnSelectedDate() ? "View Workout Day" : "Create Workout Day"
    }

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Text("Add Your Training Day")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(Color("TextColor"))

                Button(action: {
                    isCalendarExpanded.toggle()
                }) {
                    Image(systemName: isCalendarExpanded ? "chevron.up" : "chevron.right")
                        .font(.system(size: 30, weight: .regular))
                        .foregroundColor(.black)
                        .padding(15)
                        .background(Circle().fill(Color("ButtonColor")))
                }
                .frame(width: 50, height: 50)
            }
            .padding(.top, 20)

            CustomDatePicker(selectedDate: $selectedDate, isExpanded: isCalendarExpanded)
               
                .background(Color("BackgroundColor").opacity(0.3))
                .cornerRadius(20)
                .padding(.horizontal, 10)
                .padding(.top, 10)

            Button(action: {
                if hasWorkoutOnSelectedDate() {
                    // Переход к деталям тренировки, если тренировка уже существует
                    if let existingWorkoutDay = viewModel.workoutDays.first(where: { workoutDay in
                        if let date = workoutDay.date {
                            return Calendar.current.isDate(date, inSameDayAs: selectedDate)
                        }
                        return false
                    }) {
                        workoutDay = existingWorkoutDay
                    }
                    isNavigationActive = true
                } else {
                    // Создание нового WorkoutDay, если тренировка отсутствует
                    saveWorkoutDay(date: selectedDate)
                    isNavigationActive = true
                }
                print("Date passed to next step: \(selectedDate)")
            }) {
                Text(buttonText)
                    .font(.system(size: 25))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .frame(minWidth: 200, maxWidth: 250, minHeight: 70, maxHeight: 70)
                    .background(Color("ButtonColor"))
                    .cornerRadius(15)
                    
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
            .navigationDestination(isPresented: $isNavigationActive) {
                // Передаем Binding<WorkoutDay?>
                WorkoutDayDetails(viewModel: viewModel, workoutDay: $workoutDay, selectedTab: $selectedTab)
            }
        }
        .background(Color("ViewColor"))
        .cornerRadius(20)
        .padding(.horizontal, 10)
        .padding(.bottom, 40)
        .onAppear {
            viewModel.fetchWorkoutDays() // Обновляем данные при появлении представления
        }
    }

    private func saveWorkoutDay(date: Date) {
        let newWorkoutDay = WorkoutDay(context: viewContext)
        newWorkoutDay.date = date
        workoutDay = newWorkoutDay
        do {
            try viewContext.save()
        } catch {
            print("Failed to save workout day: \(error.localizedDescription)")
        }
    }
}
