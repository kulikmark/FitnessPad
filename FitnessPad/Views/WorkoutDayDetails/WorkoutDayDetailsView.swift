//
//  CreatedTrainingDayView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 28.03.2022.
//

import SwiftUI
import CoreData

struct WorkoutDayDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var viewModel: WorkoutViewModel
    @Binding var workoutDay: WorkoutDay?
    
    @State private var bodyWeight: Double = 0.0
    @State private var isShowingExercisesView = false
    
    @State private var expandedExercises: [String: Bool] = [:]
    
    @State private var weightString: String = ""
    @State private var repsString: String = ""
    
    @State private var isPanelVisible: Bool = false
    @State private var panelOffset: CGFloat = 0
    
    @State private var isBodyWeightViewVisible: Bool = false
    @State private var isEditingBodyWeight: Bool = false
    
    // Объявляем переменную для хранения атрибутов упражнения
       @State private var attributes: [ExerciseAttribute] = []
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    hideKeyboard() // Скрыть клавиатуру при нажатии на любое место
                }
            VStack {
                bodyWeightView
                exercisesListView
                emptyExercisesScreenView
                    .offset(x: isPanelVisible ? -UIScreen.main.bounds.width : 0)
                
            }
            .padding(.top, 20)
            
        }
        .overlay(
            swipeablePanel,
            alignment: .bottomTrailing
            
        )
        .sheet(isPresented: $isShowingExercisesView) {
            ExercisesView(viewModel: viewModel, workoutDay: $workoutDay)
                .background(Color("BackgroundColor"))
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
        }
        .toolbar {
            ToolbarItemGroup (placement: .keyboard) {
                Spacer()
                Button ("Done") {
                    isTextFieldFocused = false
                    // Проверяем значение веса
                    if bodyWeight == 0.0 {
                        isEditingBodyWeight = false
                    } else {
                        // Сохраняем значение веса, если оно введено
                        saveBodyWeight()
                        isEditingBodyWeight = false
                    }
                    hideKeyboard()
                }
                
            }
        }
    }

    private var emptyExercisesScreenView: some View {
        // Показываем экран только если exercisesArray пуст
        if let workoutDay = workoutDay, workoutDay.exercisesArray.isEmpty {
            return AnyView(
                VStack {
                    Text("Add an Exercise or Delete the WorkoutDay by swiping the panel on the right.")
                        .font(.footnote)
                        .foregroundColor(Color("TextColor"))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("ViewColor"))
                        )
                        .padding(.horizontal, 30)
                        .multilineTextAlignment(.center)
                }
                    .frame(maxWidth: 350, maxHeight: 100)
                    .padding(.bottom, 50)
            )
        } else {
            return AnyView(EmptyView()) // Возвращаем пустой view, если упражнения есть
        }
    }
    
    
    // -MARK: Swipeable Panel
    private var swipeablePanel: some View {
        HStack {
            
            // Нажатие на Rectangle для открытия панели
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 15, height: 90)
                .cornerRadius(45)
                .gesture(DragGesture()
                    .onChanged { value in
                        self.panelOffset = min(value.translation.width, 0)
                    }
                    .onEnded { value in
                        withAnimation(.bouncy) {
                            if self.panelOffset < -50 {
                                self.isPanelVisible = true
                            } else {
                                self.isPanelVisible = false
                            }
                            self.panelOffset = 0
                        }
                    }
                )
                .onTapGesture {
                    withAnimation(.bouncy) {
                        self.isPanelVisible.toggle() // Переключаем видимость панели при нажатии на Rectangle
                    }
                }
            
            if isPanelVisible {
                swipeablePanelStack
                    .transition(.move(edge: .trailing))
            }
        }
        .padding(.bottom, 60)
    }
    
    
    // -MARK: Swipeable Panel Stack
    private var swipeablePanelStack: some View {
        
        VStack {
            deleteButton
            addExerciseButton
        }
        .frame(maxWidth: 80)
    }
    
    private var bodyWeightView: some View {
        VStack {
            let workoutday = workoutDay
            if workoutday?.bodyWeight == 0.0 && !isEditingBodyWeight {
                Text("Tap to enter body weight")
                    .font(.system(size: 18))
                    .foregroundColor(Color("TextColor"))
                    .padding()
                    .background(Color("ViewColor"))
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation {
                            isEditingBodyWeight = true
                        }
                    }
            } else if isEditingBodyWeight {
                TextField("Enter your body weight", text: $weightString)
                    .font(.title3)
                    .foregroundColor(Color("TextColor"))
                    .padding()
                    .background(Color("ViewColor"))
                    .cornerRadius(10)
                    .padding(.horizontal, 50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .environment(\.locale, Locale(identifier: "en_US"))
                    .focused($isTextFieldFocused) // Привязка фокуса
                    .onAppear {
                        isTextFieldFocused = true // Устанавливаем фокус при появлении
                    }
                    .onChange(of: weightString) { oldValue, newValue in
                        // Заменяем запятую на точку
                        let formattedValue = newValue.replacingOccurrences(of: ",", with: ".")
                        
                        if let weight = Double(formattedValue), weight > 0.0 {
                            let workoutday = workoutDay
                            
                            workoutday?.bodyWeight = weight
                            saveBodyWeight() // Сохраняем значение веса
                        } else {
                            workoutday?.bodyWeight = 0.0
                            saveBodyWeight() // Сохраняем нулевое значение
                        }
                    }
            } else {
                if let workoutDay = workoutDay {
                    Text("My weight today: \(workoutDay.bodyWeight, specifier: "%.2f")")
                        .font(.title3)
                        .foregroundColor(Color("TextColor"))
                        .padding()
                        .background(Color("ViewColor"))
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation {
                                isEditingBodyWeight = true
                            }
                        }
                } else {
                    Text("No workout data available")
                        .font(.title3)
                        .foregroundColor(Color.gray)
                }
            }
        }
        .padding(.bottom, 20)
        
        .onTapGesture {
            validateBodyWeight()
        }
        .onAppear {
            if let workoutDay = workoutDay {
                weightString = workoutDay.bodyWeight == 0.0 ? "" : "\(workoutDay.bodyWeight)"
            }
        }
    }
    
    private func validateBodyWeight() {
        if weightString.isEmpty { // Поле уже пустое
            bodyWeight = 0.0
            saveBodyWeight() // Сохраняем нулевое значение
            isEditingBodyWeight = false
        } else {
            saveBodyWeight() // Сохраняем текущее значение, если оно валидное
            isEditingBodyWeight = false
        }
    }
    
    private func saveBodyWeight() {
        if let workoutDay = workoutDay, workoutDay.bodyWeight != 0.0 {
            // Отладочное сообщение, чтобы вывести информацию о сохранении
            print("Saving body weight: \(bodyWeight) for workout day: \(workoutDay.date ?? Date())")
            
            // Сохраняем вес
            viewModel.updateBodyWeight(for: workoutDay, newWeight: workoutDay.bodyWeight)
            
            // Еще одно отладочное сообщение, чтобы подтвердить успешное сохранение
            print("Body weight \(workoutDay.bodyWeight) saved successfully for workout day: \(workoutDay.date ?? Date())")
        } else if let workoutDay = workoutDay, workoutDay.bodyWeight == 0.0 {
            viewModel.updateBodyWeight(for: workoutDay, newWeight: workoutDay.bodyWeight)
            // Сообщение о том, что вес не был сохранен, если тело пустое
            print("Body weight \(workoutDay.bodyWeight) saved successfully for workout day: \(workoutDay.date ?? Date())")
        }
    }
    
    // -MARK: Exercise List View
    private var exercisesListView: some View {
        List {
            if let workoutDay = workoutDay, !workoutDay.exercisesArray.isEmpty {
                ForEach(workoutDay.exercisesArray, id: \.self) { exercise in
                    
                    exerciseRow(for: exercise)
                        .listRowBackground(Color.clear)
                    
                }
            }
        }
       
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listStyle(PlainListStyle())
        .padding(.bottom, 33)
    }
    
    // -MARK: Exercise Row View
    private func exerciseRow(for exercise: Exercise) -> some View {
        Section {
            HStack {
                if let imageData = exercise.image, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                } else {
                    Image("defaultExerciseImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                }
                
                Text("\(exercise.name ?? "Unknown Exercise")")
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                    .padding(.leading, 10)
                
                    .swipeActions {
                        Button(action: {
                            withAnimation {
                                deleteExercise(exercise)
                            }
                        }) {
                            Text("Delete")
                                .foregroundColor(.white)
                                .padding(10)
                                .cornerRadius(5)
                        }
                        .tint(.red)
                    }
                
                Spacer()
                
                Button(action: {
                  
                        let exerciseName = exercise.name ?? "Unknown Exercise"
                        // Обновляем состояние раскрытия для этого упражнения
                        expandedExercises[exerciseName] = !(expandedExercises[exerciseName] ?? false)
                        
                        print("Нажат expandedExercises в exerciseRow")
                    
                }) {
                    Image(systemName: expandedExercises[exercise.name ?? ""] == true ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .frame(width: 20, height: 20)
                }
            }
            .frame(height: 50)
            
            // Используем List и Section для отображения подходов
            if expandedExercises[exercise.name ?? ""] == true {
                exerciseSetView(for: exercise)
            }
        }
    }
    
    // -MARK: Exercise Set View
    private func exerciseSetView(for exercise: Exercise) -> some View {
        VStack {
            if exercise.setsArray.isEmpty {
                noSetsView(for: exercise)
            } else {
                listView(for: exercise)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: expandedExercises[exercise.name ?? ""] == true ? min(CGFloat(exercise.setsArray.count * 50) + 50, 500) : 0)
    }
    
    // MARK: - Helper Views
    
    private func noSetsView(for exercise: Exercise) -> some View {
        
        VStack(alignment: .center) {
            Text("No added sets")
                .foregroundColor(Color("TextColor"))
                .frame(maxWidth: .infinity, alignment: .center)
            
            addSetButton(for: exercise)
        }
        .frame(height: 100)
    }

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
            
            addSetButton(for: exercise)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
    }

    private func deleteSets(at indexSet: IndexSet, from exercise: Exercise) {
        for index in indexSet {
            let setToDelete = exercise.setsArray[index]
            viewModel.deleteSet(setToDelete, in: exercise)
        }
    }
    
    private func setSection(for set: ExerciseSet, index: Int, exercise: Exercise) -> some View {
        Section {
            HStack {
                Text("Set \(index + 1):")
                    .foregroundColor(Color("TextColor"))
                    .frame(width: 80, alignment: .leading) // Устанавливаем фиксированную ширину для текста
                    .padding(.trailing, 10)
                
                Spacer()
                
                attributesFields(exercise: exercise, for: set)
          
            }
            .padding(.horizontal, 0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowBackground(Color.clear)
        }
    }
    
    private func attributesFields(exercise: Exercise, for set: ExerciseSet) -> some View {
        HStack {
            // Пример использования нового метода
            if exercise.attribute(for: "Weight") != nil {
                dataInputField(
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
                )
            }

            if exercise.attribute(for: "Reps") != nil {
                dataInputField(
                    placeholder: "Reps",
                    value: Binding(
                        get: { set.reps > 0 ? "\(set.reps)" : "" },
                        set: { newValue in
                            set.reps = Int16(newValue) ?? 0
                            viewModel.saveContext()
                        }
                    ),
                    keyboardType: .numberPad
                )
            }

            if exercise.attribute(for: "Distance") != nil {
                dataInputField(
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
                )
            }

            if exercise.attribute(for: "Time") != nil {
                dataInputField(
                    placeholder: "Time",
                    value: Binding(
                        get: { formatTime(set.time) },
                        set: { newValue in
                            set.time = parseTime(newValue)
                            viewModel.saveContext()
                        }
                    ),
                    keyboardType: .numbersAndPunctuation
                )
            }
        }
    }

    private func formatTime(_ time: Double) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    private func parseTime(_ timeString: String) -> Double {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hours = Double(components[0]),
              let minutes = Double(components[1]) else {
            return 0
        }
        return hours * 3600 + minutes * 60
    }
    
    
    // MARK: - Reusable Input Field
    
    private func dataInputField(placeholder: String, value: Binding<String>, keyboardType: UIKeyboardType) -> some View {
        TextField(placeholder, text: value)
            .padding(5)
            .background(Color(UIColor.secondarySystemBackground))
            .foregroundColor(Color(UIColor.label))
            .cornerRadius(5)
            .multilineTextAlignment(.center)
            .keyboardType(keyboardType)
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
    
    
    // -MARK: Add Set Button
    private func addSetButton(for exercise: Exercise) -> some View {
        Button(action: {
            print("Нажат addSetButton")
            viewModel.addSet(to: exercise)
        }) {
            HStack {
                Image(systemName: "plus")
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextColor"))
                Text("Add Set")
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextColor"))
            }
            .padding(10)
            .background(Color("ButtonColor"))
            .cornerRadius(5)
        }
        .buttonStyle(PlainButtonStyle()) // Убирает стандартное поведение кнопки в списке
    }

    
    private var deleteButton: some View {
        Button(action: {
            if let workoutDay = workoutDay {
                viewModel.deleteWorkoutDay(workoutDay)
                
            }
        }) {
            Image(systemName: "trash.fill")
                .font(.system(size: 18))
                .foregroundColor(Color("TextColor"))
                .padding(15)
                .background(Circle().fill(Color.red))
        }
    }
    
    private var addExerciseButton: some View {
        Button(action: {
            isShowingExercisesView = true
        }) {
            HStack {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                    .padding(15)
                    .background(Circle().fill(Color("ButtonColor")))
            }
        }
    }
    
    func deleteExercise(_ exercise: Exercise) {
        viewModel.deleteExerciseFromWorkoutDay(exercise)
    }
    
    func deleteSet(_ set: ExerciseSet, exercise: Exercise) {
        viewModel.deleteSet(set, in: exercise)
    }
    
    func hideKeyboard() {
        UIApplication.shared.endEditing(true)
    }
    
}



extension UIApplication {
    func endEditing(_ force: Bool) {
        guard let windowScene = connectedScenes.first as? UIWindowScene else { return }
        windowScene.windows.first?.endEditing(force)
    }
}



struct WorkoutDayDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        
        // Создаем пример тренировочного дня
        let workoutDay = WorkoutDay(context: context)
        workoutDay.date = Date()
        
                // Создаем пример упражнения
                let exercise = Exercise(context: context)
                exercise.name = "Push-ups"
                if let image = UIImage(named: "Push-Ups") {
                    exercise.image = image.pngData()  // Сохраняем изображение в формате PNG
                }
        
                // Создаем пример упражнения
                let exercise1 = Exercise(context: context)
                exercise1.name = "New Exercise"
                if let image = UIImage(named: "defaultExerciseImage") {
                    exercise1.image = image.pngData()  // Сохраняем изображение в формате PNG
                }
        
                workoutDay.addToExercises(exercise)
                workoutDay.addToExercises(exercise1)
        
                // Добавляем пример подходов к упражнению
                let set1 = ExerciseSet(context: context)
                set1.weight = 20
                set1.reps = 15
                set1.count = 1
        
                set1.exercise = exercise
        
                let set2 = ExerciseSet(context: context)
                set2.weight = 25
                set2.reps = 12
                set2.count = 2
        
                set2.exercise = exercise
        
                let set3 = ExerciseSet(context: context)
                set3.weight = 30
                set3.reps = 12
                set3.count = 3
        
                set3.exercise = exercise
        
                let set4 = ExerciseSet(context: context)
                set4.weight = 35
                set4.reps = 12
                set4.count = 4
        
                set4.exercise = exercise
        
        // Возвращаем `WorkoutDayDetailsView` с переданными данными
        return WorkoutDayDetailsView(
            viewModel: WorkoutViewModel(),
            workoutDay: .constant(workoutDay)
        )
        .environment(\.managedObjectContext, context)  // Используем mock контекст
    }
}
