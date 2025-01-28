//
//  CreatedTrainingDayView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 28.03.2022.
//

//import SwiftUI
//import CoreData
//
//struct WorkoutDayDetailsView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @EnvironmentObject var viewModel: WorkoutViewModel
//
//    var body: some View {
//        ZStack {
//            Color("BackgroundColor")
//                .edgesIgnoringSafeArea(.all)
//            VStack {
//                if viewModel.workoutDay != nil {
//                    WorkoutDayDetailsViewHeaderView()
//                    exercisesListView
//                } else {
//                    EmptyWorkoutDayView(selectedDate: .constant(Date()))
//                }
//            }
//            .simultaneousGesture(TapGesture().onEnded {
//                UIApplication.shared.endEditing(true)
//                viewModel.saveContext()
//            })
//        }
//    }
//    
//    private var exercisesListView: some View {
//        ExercisesListView()
//    }
//}


//
//    // -MARK: Exercise List View
//    private var exercisesListView: some View {
//        Group {
//            if let workoutDay = workoutDay, workoutDay.exercisesArray.isEmpty {
//                VStack {
//                    Spacer()
//                    emptyExercisesScreenView
//                    Spacer()
//                }
//            } else {
//                List {
//                    ForEach(workoutDay?.exercisesArray ?? [], id: \.self) { exercise in
//                        exerciseRow(for: exercise)
//                            .listRowBackground(Color.clear)
//                    }
//                }
//                .scrollIndicators(.hidden)
//                .scrollContentBackground(.hidden)
//                .listStyle(PlainListStyle())
//                .padding(.bottom, 33)
//            }
//        }
//    }
//    
//    private var emptyExercisesScreenView: some View {
//        // Показываем экран только если exercisesArray пуст
//        VStack {
//        if let workoutDay = workoutDay, workoutDay.exercisesArray.isEmpty {
//                Text("Add an Exercise or Delete the WorkoutDay by tapping button on the upper right corner.")
//                    .font(.footnote)
//                    .foregroundColor(Color("TextColor"))
//                    .multilineTextAlignment(.center)
//            }
//        }
//        .padding()
//        .background(Color("ViewColor").opacity(0.2))
//        .cornerRadius(15)
//        .padding(.horizontal, 20)
//    }
//    
//    // -MARK: Exercise Row View
//    private func exerciseRow(for exercise: Exercise) -> some View {
//        Section {
//            HStack {
//                if let imageData = exercise.image, let uiImage = UIImage(data: imageData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 100, height: 50)
//                        .clipShape(RoundedRectangle(cornerRadius: 3))
//                } else {
//                    Image("defaultExerciseImage")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 100, height: 50)
//                        .clipShape(RoundedRectangle(cornerRadius: 3))
//                }
//                
//                Text("\(exercise.name ?? "Unknown Exercise")")
//                    .font(.system(size: 16))
//                    .foregroundColor(Color("TextColor"))
//                    .padding(.leading, 10)
//                
//                    .swipeActions {
//                        Button(action: {
//                            withAnimation {
//                                deleteExercise(exercise)
//                            }
//                        }) {
//                            Text("Delete")
//                                .foregroundColor(.white)
//                                .padding(10)
//                                .cornerRadius(5)
//                        }
//                        .tint(.red)
//                    }
//                
//                Spacer()
//                
//                Button(action: {
//                    
//                    let exerciseName = exercise.name ?? "Unknown Exercise"
//                    // Обновляем состояние раскрытия для этого упражнения
//                    expandedExercises[exerciseName] = !(expandedExercises[exerciseName] ?? false)
//                    
//                    print("Нажат expandedExercises в exerciseRow")
//                    
//                }) {
//                    Image(systemName: expandedExercises[exercise.name ?? ""] == true ? "chevron.up" : "chevron.down")
//                        .foregroundColor(.gray)
//                        .frame(width: 20, height: 20)
//                }
//            }
//            .frame(height: 60)
//            
//            // Используем List и Section для отображения подходов
//            if expandedExercises[exercise.name ?? ""] == true {
//                exerciseSetView(for: exercise)
//            }
//        }
//    }
//    
//    // -MARK: Exercise Set View
//    private func exerciseSetView(for exercise: Exercise) -> some View {
//        VStack {
//            if exercise.setsArray.isEmpty {
//                noSetsView(for: exercise)
//            } else {
//                listView(for: exercise)
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .frame(height: expandedExercises[exercise.name ?? ""] == true ? min(CGFloat(exercise.setsArray.count * 50) + 50, 500) : 0)
//    }
//    
//    // MARK: - Helper Views
//    
//    private func noSetsView(for exercise: Exercise) -> some View {
//        
//        VStack(alignment: .center) {
//            Text("No added sets")
//                .foregroundColor(Color("TextColor"))
//                .frame(maxWidth: .infinity, alignment: .center)
//            
//            addSetButton(for: exercise)
//        }
//        .frame(height: 100)
//    }
//    
//    private func listView(for exercise: Exercise) -> some View {
//        VStack {
//            List {
//                ForEach(exercise.setsArray.enumeratedArray(), id: \.element.id) { index, set in
//                    setSection(for: set, index: index, exercise: exercise)
//                }
//                .onDelete { indexSet in
//                    deleteSets(at: indexSet, from: exercise)
//                }
//            }
//            .scrollIndicators(.hidden)
//            .frame(maxWidth: .infinity)
//            .scrollContentBackground(.hidden)
//            
//            addSetButton(for: exercise)
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.top, 10)
//    }
//    
//    private func deleteSets(at indexSet: IndexSet, from exercise: Exercise) {
//        for index in indexSet {
//            let setToDelete = exercise.setsArray[index]
//            viewModel.deleteSet(setToDelete, in: exercise)
//        }
//    }
//    
//    private func setSection(for set: ExerciseSet, index: Int, exercise: Exercise) -> some View {
//        Section {
//            HStack {
//                Text("Set \(index + 1):")
//                    .foregroundColor(Color("TextColor"))
//                    .frame(width: 80, alignment: .leading) // Устанавливаем фиксированную ширину для текста
//                    .padding(.trailing, 10)
//                
//                Spacer()
//                
//                attributesFields(exercise: exercise, for: set)
//                
//            }
//            .padding(.horizontal, 0)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .listRowBackground(Color.clear)
//        }
//    }
//    
//    private func attributesFields(exercise: Exercise, for set: ExerciseSet) -> some View {
//        HStack {
//            // Пример использования нового метода
//            if exercise.attribute(for: "Weight") != nil {
//                dataInputField(
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
//                )
//            }
//            
//            if exercise.attribute(for: "Reps") != nil {
//                dataInputField(
//                    placeholder: "Reps",
//                    value: Binding(
//                        get: { set.reps > 0 ? "\(set.reps)" : "" },
//                        set: { newValue in
//                            set.reps = Int16(newValue) ?? 0
//                            viewModel.saveContext()
//                        }
//                    ),
//                    keyboardType: .numberPad
//                )
//            }
//            
//            if exercise.attribute(for: "Distance") != nil {
//                dataInputField(
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
//                )
//            }
//            
//            if exercise.attribute(for: "Time") != nil {
//                dataInputField(
//                    placeholder: "Time",
//                    value: Binding(
//                        get: { formatTime(set.time) },
//                        set: { newValue in
//                            set.time = parseTime(newValue)
//                            viewModel.saveContext()
//                        }
//                    ),
//                    keyboardType: .numbersAndPunctuation
//                )
//            }
//        }
//    }
//    
//    private func formatTime(_ time: Double) -> String {
//        let hours = Int(time) / 3600
//        let minutes = (Int(time) % 3600) / 60
//        return String(format: "%02d h : %02d m", hours, minutes)
//    }
//
//    
//    private func parseTime(_ timeString: String) -> Double {
//        let cleanedString = timeString.replacingOccurrences(of: " h", with: "")
//                                      .replacingOccurrences(of: " m", with: "")
//                                      .replacingOccurrences(of: ":", with: "")
//        let components = cleanedString.split(separator: " ")
//        guard components.count == 2,
//              let hours = Double(components[0]),
//              let minutes = Double(components[1]) else {
//            return 0
//        }
//        return hours * 3600 + minutes * 60
//    }
//
//    
//    
//    // MARK: - Reusable Input Field
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
//    
//    
//    // -MARK: Add Set Button
//    private func addSetButton(for exercise: Exercise) -> some View {
//        Button(action: {
//            print("Нажат addSetButton")
//            viewModel.addSet(to: exercise)
//        }) {
//            HStack {
//                Image(systemName: "plus")
//                    .font(.system(size: 14))
//                    .foregroundColor(Color("TextColor"))
//                Text("Add Set")
//                    .font(.system(size: 14))
//                    .foregroundColor(Color("TextColor"))
//            }
//            .padding(10)
//            .background(Color("ButtonColor"))
//            .cornerRadius(5)
//        }
//        .buttonStyle(PlainButtonStyle()) // Убирает стандартное поведение кнопки в списке
//    }
//    
//    func deleteExercise(_ exercise: Exercise) {
//        viewModel.deleteExerciseFromWorkoutDay(exercise)
//    }
//    
//    func deleteSet(_ set: ExerciseSet, exercise: Exercise) {
//        viewModel.deleteSet(set, in: exercise)
//    }
//    
//    func hideKeyboard() {
//        UIApplication.shared.endEditing(true)
//    }
//    
//}
//
//
//struct WorkoutDayDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.shared.container.viewContext
//        
//        // Создаем пример тренировочного дня
//        let workoutDay = WorkoutDay(context: context)
//        workoutDay.date = Date()
//        
//        // Создаем пример упражнения
//        let exercise = Exercise(context: context)
//        exercise.name = "Push-ups"
//        exercise.id = UUID() // Убедитесь, что id уникален
//        if let image = UIImage(named: "Push-Ups") {
//            exercise.image = image.pngData()
//        }
//        
//        // Создаем атрибуты для упражнения
//        let weightAttribute = ExerciseAttribute(context: context)
//        weightAttribute.name = "Weight"
//        weightAttribute.isAdded = true // Атрибут добавлен
//        
//        let repsAttribute = ExerciseAttribute(context: context)
//        repsAttribute.name = "Reps"
//        repsAttribute.isAdded = true // Атрибут добавлен
//        
//        // Добавляем атрибуты к упражнению
//        exercise.addToAttributes(weightAttribute)
//        exercise.addToAttributes(repsAttribute)
//        
//        // Создаем второе упражнение
//        let exercise1 = Exercise(context: context)
//        exercise1.name = "Running"
//        exercise1.id = UUID() // Убедитесь, что id уникален
//        if let image = UIImage(named: "defaultExerciseImage") {
//            exercise1.image = image.pngData()
//        }
//        
//        // Создаем атрибуты для второго упражнения
//        let distanceAttribute = ExerciseAttribute(context: context)
//        distanceAttribute.name = "Distance"
//        distanceAttribute.isAdded = true // Атрибут добавлен
//        
//        let timeAttribute = ExerciseAttribute(context: context)
//        timeAttribute.name = "Time"
//        timeAttribute.isAdded = false // Атрибут не добавлен (для примера)
//        
//        // Добавляем атрибуты ко второму упражнению
//        exercise1.addToAttributes(distanceAttribute)
//        exercise1.addToAttributes(timeAttribute)
//        
//        // Добавляем упражнения к тренировочному дню
//        workoutDay.addToExercises(exercise)
//        workoutDay.addToExercises(exercise1)
//        
//        // Создаем пример подходов для первого упражнения
//        let set1 = ExerciseSet(context: context)
//        set1.weight = 20
//        set1.reps = 15
//        set1.distance = 0
//        set1.time = 0
//        set1.count = 1
//        set1.exercise = exercise
//        
//        let set2 = ExerciseSet(context: context)
//        set2.weight = 25
//        set2.reps = 12
//        set2.distance = 0
//        set2.time = 0
//        set2.count = 2
//        set2.exercise = exercise
//        
//        // Создаем пример подходов для второго упражнения
//        let set3 = ExerciseSet(context: context)
//        set3.weight = 0
//        set3.reps = 0
//        set3.distance = 5
//        set3.time = 1800 // 30 минут в секундах
//        set3.count = 1
//        set3.exercise = exercise1
//        
//        let set4 = ExerciseSet(context: context)
//        set4.weight = 0
//        set4.reps = 0
//        set4.distance = 10
//        set4.time = 3600 // 1 час в секундах
//        set4.count = 2
//        set4.exercise = exercise1
//        
//        // Возвращаем `WorkoutDayDetailsView` с переданными данными
//        return WorkoutDayDetailsView(
//            viewModel: WorkoutViewModel(),
//            workoutDay: .constant(workoutDay)
//        )
//        .environment(\.managedObjectContext, context)  // Используем mock контекст
//    }
//}


//struct WorkoutDayDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.shared.container.viewContext
//        
//        // Очищаем Core Data перед созданием mock-данных
//        PersistenceController.shared.reset()
//        
//        // Создаем mock-данные
//        let workoutDay = WorkoutDay(context: context)
//        workoutDay.date = Date()
//        
//        // Возвращаем View с mock-данными
//        return WorkoutDayDetailsView(
//            viewModel: WorkoutViewModel(),
//            workoutDay: .constant(workoutDay)
//        )
//        .environment(\.managedObjectContext, context)
//    }
//}
