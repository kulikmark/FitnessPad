//
//  ExerciseSetView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 16.01.2025.
//

import SwiftUI

struct ExerciseSetView: View {
    @EnvironmentObject var viewModel: WorkoutDayViewModel
    @EnvironmentObject var coreDataService: CoreDataService
    var exercise: Exercise
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    // Заголовок с названием упражнения
                    Text(exercise.name ?? "Unknown Exercise")
                        .font(.system(size: 24))
                        .fontWeight(.medium)
                        .foregroundColor(Color("TextColor"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    CloseButtonCircle()
                }
                listView(for: exercise)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("BackgroundColor"))
            .onAppear {
                if exercise.setsArray.isEmpty {
                    viewModel.addSet(to: exercise)
                }
            }
        }
        .simultaneousGesture(TapGesture().onEnded {
            UIApplication.shared.endEditing(true)
            coreDataService.saveContext()
        })
    }

    // Остальной код остается без изменений
    private func listView(for exercise: Exercise) -> some View {
        VStack {
            List {
                ForEach(exercise.setsArray.enumeratedArray(), id: \.element.id) { index, set in
                    setSection(for: set, index: index, exercise: exercise)
                }
                .onDelete { indexSet in
                    deleteSets(at: indexSet, from: exercise)
                }
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.immediately)
            
            addSetButton(for: exercise)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
    }

    private func deleteSets(at indexSet: IndexSet, from exercise: Exercise) {
        for index in indexSet {
            let setToDelete = exercise.setsArray[index]
            viewModel.deleteSet(setToDelete, from: exercise)
        }
    }

    private func setSection(for set: ExerciseSet, index: Int, exercise: Exercise) -> some View {
        Section {
            HStack {
                Text("\(index + 1):")
                    .foregroundColor(Color.gray)
                    .frame(width: 20, alignment: .leading)
                
                Spacer()
                
                ExerciseAttributes(exercise: exercise, set: set)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
        }
    }

    private func addSetButton(for exercise: Exercise) -> some View {
        Button(action: {
            viewModel.addSet(to: exercise)
        }) {
            HStack {
                Image(systemName: "plus")
                    .font(.system(size: 16))
                    .foregroundColor(Color("ButtonTextColor"))
                Text("Add Set")
                    .font(.system(size: 14))
                    .foregroundColor(Color("ButtonTextColor"))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("ButtonColor"))
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
    }
}

struct ExerciseSetView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        
        // Создаем пример упражнения
        let exercise = Exercise(context: context)
        exercise.name = "Push-ups"
        exercise.id = UUID()
        
        // Создаем атрибуты для упражнения
        let weightAttribute = ExerciseAttribute(context: context)
        weightAttribute.name = "Weight"
        weightAttribute.isAdded = true
        
        let repsAttribute = ExerciseAttribute(context: context)
        repsAttribute.name = "Reps"
        repsAttribute.isAdded = false
        
        let distanceAttribute = ExerciseAttribute(context: context)
        distanceAttribute.name = "Distance"
        distanceAttribute.isAdded = false
        
        let timeAttribute = ExerciseAttribute(context: context)
        timeAttribute.name = "Time"
        timeAttribute.isAdded = true
        
        // Добавляем атрибуты к упражнению
        exercise.addToAttributes(weightAttribute)
        exercise.addToAttributes(repsAttribute)
        exercise.addToAttributes(distanceAttribute)
        exercise.addToAttributes(timeAttribute)
        
        // Создаем пример подходов
        let set1 = ExerciseSet(context: context)
        set1.weight = 20
        set1.reps = 15
        set1.distance = 20
        set1.time = 180
        set1.count = 1
        set1.exercise = exercise
        
        let set2 = ExerciseSet(context: context)
        set2.weight = 25
        set2.reps = 12
        set2.distance = 25
        set2.time = 240
        set2.count = 2
        set2.exercise = exercise
        
        // Добавляем подходы к упражнению
        exercise.addToSets(set1)
        exercise.addToSets(set2)
        
        // Возвращаем ExerciseSetView с мок-данными
        return ExerciseSetView(exercise: exercise)
            .environment(\.managedObjectContext, context) // Используем mock контекст
    }
}
