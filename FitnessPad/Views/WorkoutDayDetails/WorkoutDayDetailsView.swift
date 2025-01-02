//
//  CreatedTrainingDayView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 28.03.2022.
//


//import SwiftUI
//import CoreData
//
//enum WeightUnit: String, CaseIterable {
//    case kg = "kg"
//    case lb = "lb"
//}
//
//struct WorkoutDayDetailsView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @ObservedObject var viewModel: WorkoutViewModel
//    @Binding var workoutDay: WorkoutDay?
//
//    @State private var bodyWeight: String = ""
//    @State private var tempBodyWeight: String = ""
//    @State private var weightInputUnit: WeightUnit = .kg
//    @State private var tempWeightUnit: WeightUnit = .kg
//    @State private var isNavigationActive = false
//    @State private var isShowingExercisesView = false
//    @State private var showingBodyWeightSheet = false
//    @State private var showingWeightRepsSheet = false
//    @State private var selectedSet: ExerciseSet?
//    @State private var exerciseWeightInput: String = ""
//    @State private var exerciseRepsInput: String = ""
//
//    @State private var draggedOffset: CGFloat = 0
//
//    @GestureState private var slideOffset: CGSize = CGSize.zero
//    @State private var positionX: CGFloat = 0
//    @State private var deleteButtonIsHidden: Bool = true
//
//
//    var body: some View {
//        ZStack {
//            // Фон для всего экрана
//            Color("BackgroundColor")
//                .edgesIgnoringSafeArea(.all)
//            VStack {
//                ScrollView {
//                    VStack(alignment: .center, spacing: 15) {
//                        // MARK: - Display Workout Day Date
//                        VStack {
//                            Text("Workout \(workoutDay?.date ?? Date(), formatter: dateFormatter)")
//                            //                            .font(.system(size: 33, weight: .medium))
//                                .font(.system(size: UIScreen.main.bounds.width * 0.07))
//                                .foregroundColor(Color("TextColor"))
//                                .padding(.top, 20)
//                                .padding(.bottom, 20)
//                                .padding(.horizontal, 20)
//                        }
//
//                        // MARK: - Display and Input Body Weight
//                        VStack {
//                            Text(bodyWeight.isEmpty ? "Tap to enter body weight" : "My weight today: \(bodyWeight) \(weightInputUnit.rawValue)")
//                                .font(.title3)
//                                .foregroundColor(Color("TextColor"))
//                                .padding()
//                                .background(Color("ViewColor"))
//                                .cornerRadius(10)
//                                .onTapGesture {
//                                    tempBodyWeight = bodyWeight
//                                    tempWeightUnit = weightInputUnit
//                                    showingBodyWeightSheet = true
//                                }
//                        }
//                        .padding(.horizontal, 20)
//
//                        // MARK: - Display List of Exercises
//                        if let workoutDay = workoutDay, !workoutDay.exercisesArray.isEmpty {
//                            ForEach(workoutDay.exercisesArray, id: \.self) { exercise in
//                                VStack(alignment: .leading) {
//                                    HStack {
//                                        // MARK: - Exercise Name
//
//                                            Text("\(exercise.name ?? "Unknown Exercise")")
//                                                .font(.system(size: 27, weight: .medium))
//                                                .foregroundColor(Color("TextColor"))
//                                                .padding(10)
//                                                .frame(maxWidth: .infinity, alignment: .leading)
//                                                .background(Color("ButtonColor"))
//                                                .cornerRadius(10)
//
//                                        // MARK: - Delete Button
//                                        deleteButton(exercise: exercise)
//                                    }
//                                    .padding(.bottom, 10)
//                                    // Swipe Deletion
//                                    .offset(x: slideOffset.width + positionX)
//                                    .gesture(DragGesture()
//                                        .updating($slideOffset, body: { dragValue, slideOffset, transaction in
//                                            if dragValue.translation.width < 0 && dragValue.translation.width > -55 && self.positionX != 0 {
//                                                slideOffset = dragValue.translation
//                                            }
//                                        })
//                                            .onEnded({ dragValue in
//                                                if dragValue.translation.width < 0 {
//                                                    withAnimation(.easeInOut) {
//                                                        self.positionX = 0
//                                                        self.deleteButtonIsHidden = false
//                                                    }
//                                                } else {
//                                                    withAnimation(.easeInOut) {
//                                                        self.positionX = 0
//                                                        self.deleteButtonIsHidden = true
//                                                    }
//                                                }
//                                            })
//                                    )
//
//                                    exerciseSetView(for: exercise)
//                                }
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .padding(.bottom, 20)
//                            }
//
//                        } else {
//                            Text("No exercises added yet.")
//                                .foregroundColor(.white)
//                                .padding()
//                                .padding(.leading, 20)
//                        }
//
//                        // MARK: - Add Exercise Button
//                        HStack {
//                            Text("Add Exercise")
//                                .font(.title2)
//                                .foregroundColor(Color("TextColor"))
//                            Button(action: {
//                                isShowingExercisesView = true
//                            }) {
//                                Image(systemName: "plus")
//                                    .font(.system(size: 30, weight: .regular))
//                                    .foregroundColor(.black)
//                                    .padding(15)
//                                    .background(Circle().fill(Color("ButtonColor")))
//                            }
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.bottom, 20)
//                    }
//                }
//                .onTapGesture {
//                    hideKeyboard()
//                }
//            }
//            .background(
//                Color("BackgroundColor")
//                    .edgesIgnoringSafeArea(.all)
//            )
//
//            .sheet(isPresented: $isShowingExercisesView) {
//                ExercisesView(viewModel: viewModel, workoutDay: $workoutDay)
//                    .background(Color("BackgroundColor"))
//                    .edgesIgnoringSafeArea(.all)
//                    .transition(.opacity)
//            }
//        }
//        .background(
//            Color("BackgroundColor")
//                .edgesIgnoringSafeArea(.all)
//        )
//        .overlay(
//            Group {
//                if showingWeightRepsSheet {
//                    Color.black.opacity(0.5)
//                        .edgesIgnoringSafeArea(.all)
//                        .transition(.opacity)
//                }
//            }
//        )
//        .sheet(isPresented: $showingWeightRepsSheet) {
//            WeightRepsInputView(
//                weightInput: $exerciseWeightInput,
//                weightInputUnit: $weightInputUnit,
//                repsInput: $exerciseRepsInput,
//                onSave: { weight, unit, reps in
//                    exerciseWeightInput = weight
//                    weightInputUnit = unit
//                    if let selectedSet = selectedSet {
//                        selectedSet.weight = Double(weight) ?? 0.0
//                        selectedSet.weightUnit = unit.rawValue
//                        selectedSet.reps = Int16(reps) ?? 0 // Update reps
//                        viewModel.saveContext()
//                    }
//                    hideKeyboard()
//                    showingWeightRepsSheet = false
//                },
//                onCancel: {
//                    hideKeyboard()
//                    showingWeightRepsSheet = false
//                }
//            )
//            .presentationDetents([.height(330)]) // Set the sheet size to medium
//        }
//
//    }
//
//
//    private func deleteExercise(_ exercise: Exercise) {
//        viewModel.deleteExercise(exercise)
//    }
//
//    private func deleteSet(_ set: ExerciseSet) {
//        viewModel.deleteSet(set)
//    }
//
//
//
//    private var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMMM yyyy"
//        return formatter
//    }
//
//    private func exerciseSetView(for exercise: Exercise) -> some View {
//        VStack(alignment: .leading) {
//            ForEach(sets(for: exercise)) { set in
//                Button(action: {
//                    exerciseWeightInput = "\(set.weight)"
//                    weightInputUnit = WeightUnit(rawValue: set.weightUnit ?? WeightUnit.kg.rawValue) ?? .kg
//                    exerciseRepsInput = "\(set.reps)"
//                    selectedSet = set
//                    showingWeightRepsSheet = true
//                }) {
//                    HStack(spacing: 10) {
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text("Set \(set.count):")
//                                .foregroundColor(Color("TextColor"))
//                                .fontWeight(.bold)
//                        }
//
//                        Text("Weight: \(set.weight, specifier: "%.1f") \(set.weightUnit ?? WeightUnit.kg.rawValue), Reps: \(set.reps)")
//                            .foregroundColor(Color("TextColor"))
//
//                        //                        Spacer()
//
//                        //                        Button(action: {
//                        //                            viewModel.deleteSet(set)
//                        //                        }) {
//                        //                            Image(systemName: "trash.fill")
//                        //                                .foregroundColor(.red)
//                        //                        }
//
//                    }
//                    .padding(10)
//                    .background(Color.white.opacity(0.3))
//                    .cornerRadius(10)
//                    .padding(.horizontal, 20)
//
//                    deleteButton(set: set)
//                }
//            }
//
//            Button(action: {
//                addSet(to: exercise)
//            }) {
//                Text("Add Set")
//                    .foregroundColor(Color("TextColor"))
//                    .padding()
//                    .background(Color("ViewColor"))
//                    .cornerRadius(15)
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 10)
//        }
//    }
//
//    private func sets(for exercise: Exercise) -> [ExerciseSet] {
//        let nsSet = exercise.sets ?? NSSet()
//        return nsSet.allObjects.compactMap { $0 as? ExerciseSet }.sorted { $0.count < $1.count }
//    }
//
//    private func addSet(to exercise: Exercise) {
//        let newSet = ExerciseSet(context: viewContext)
//        let maxCount = sets(for: exercise).map { $0.count }.max() ?? 0
//        newSet.count = maxCount + 1
//        newSet.weight = 0
//        newSet.reps = 0
//        newSet.weightUnit = WeightUnit.kg.rawValue
//        newSet.exercise = exercise
//        viewModel.saveContext()
//    }
//
//    private func hideKeyboard() {
//        UIApplication.shared.endEditing()
//    }
//}
//
//extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
//
//extension WorkoutDay {
//    var exercisesArray: [Exercise] {
//        let set = exercises as? Set<Exercise> ?? []
//        return set.sorted { $0.name ?? "" < $1.name ?? "" } // Сортировка по имени
//    }
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
//        workoutDay.addToExercises(exercise)
//
//        // Добавляем пример подходов к упражнению
//        let set1 = ExerciseSet(context: context)
//        set1.weight = 20
//        set1.reps = 15
//        set1.count = 1
//        set1.weightUnit = WeightUnit.kg.rawValue
//        set1.exercise = exercise
//
//        let set2 = ExerciseSet(context: context)
//        set2.weight = 25
//        set2.reps = 12
//        set2.count = 2
//        set2.weightUnit = WeightUnit.kg.rawValue
//        set2.exercise = exercise
//
//        // Возвращаем `WorkoutDayDetailsView` с переданными данными
//        return WorkoutDayDetailsView(
//            viewModel: WorkoutViewModel(),
//            workoutDay: .constant(workoutDay)
//        )
//        .environment(\.managedObjectContext, context)  // Используем mock контекст
//    }
//}

//import SwiftUI
//
//struct WorkoutDayDetailsView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @ObservedObject var viewModel: WorkoutViewModel
//    @Binding var workoutDay: WorkoutDay?
//
//    @State private var bodyWeight: String = ""
//    @State private var isShowingExercisesView = false
//
//    @State private var expandedExercise: String? = nil
//
//    @State private var expandedExercises: [String: Bool] = [:]
//
//    @State private var weightString: String = ""
//    @State private var repsString: String = ""
//
//    @State private var isPanelVisible: Bool = false
//
//
//    var body: some View {
//        ZStack {
//            Color("BackgroundColor")
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture {
//                    hideKeyboard()
//                }
//            VStack {
//                bodyWeightView
//                exercisesListView
//                //                addExerciseButton
//
//
//                // Swipeable panel with buttons
//                if isPanelVisible {
//                    swipeablePanelStack
//                }
//
//            }
//            .padding(.top, 20)
//
//
//    }
//        // -MARK: Swipeable Panel with Button
//                .overlay(
//                    swipeablePanel,
//                    alignment: .bottomTrailing
//
//                )
//                .gesture(
//                    DragGesture()
//                        .onEnded { value in
//                            if value.translation.width < -50 {
//                                withAnimation(.bouncy) {
//                                    isPanelVisible = true
//                                }
//                            } else if value.translation.width > 50 {
//                                withAnimation(.bouncy) {
//                                    isPanelVisible = false
//                                }
//                            }
//                        }
//                )
//
//        .sheet(isPresented: $isShowingExercisesView) {
//            ExercisesView(viewModel: viewModel, workoutDay: $workoutDay)
//                .background(Color("BackgroundColor"))
//                .edgesIgnoringSafeArea(.all)
//                .transition(.opacity)
//        }
//
//    }
//
//    private var swipeablePanel: some View {
//         Rectangle()
//             .fill(Color.gray.opacity(0.2))
//             .frame(width: 10, height: 60)
//             .cornerRadius(5)
//             .padding(.bottom, 60)
//     }
//
//    private var swipeablePanelStack: some View {
//
//        HStack {
//            Spacer()
//            VStack {
//                deleteButton
//                addExerciseButton
//            }
//            .padding()
//            .transition(.move(edge: .trailing))
//            .padding(.bottom, 40)
//        }
//
//    }
//
//    private var bodyWeightView: some View {
//        VStack {
//            Text(bodyWeight.isEmpty ? "Tap to enter body weight" : "My weight today: \(bodyWeight)")
//                .font(.title3)
//                .foregroundColor(Color("TextColor"))
//                .padding()
//                .background(Color("ViewColor"))
//                .cornerRadius(10)
//                .onTapGesture {
//                    // Логика ввода веса
//                }
//        }
//        .padding(.bottom, 20)
//    }
//
//
//    // -MARK: Exercise List View
//    private var exercisesListView: some View {
//        List {
//            if let workoutDay = workoutDay, !workoutDay.exercisesArray.isEmpty {
//                ForEach(workoutDay.exercisesArray, id: \.self) { exercise in
//
//                    exerciseRow(for: exercise)
//                        .listRowBackground(Color.clear)
//                }
//            }
//        }
//        .scrollContentBackground(.hidden)
//        .listStyle(PlainListStyle())
//        .padding(.bottom, 33)
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
//                    expandedExercise = expandedExercise == exercise.name ? nil : exercise.name
//
//                }) {
//                    Image(systemName: expandedExercise == exercise.name ? "chevron.up" : "chevron.down")
//                        .foregroundColor(.gray)
//                        .frame(width: 20, height: 20)
//                }
//
//            }
//            .frame(height: 50)
//
//            // Используем List и Section для отображения подходов
//            if expandedExercise == exercise.name {
//
//                exerciseSetView(for: exercise)
//            }
//        }
//    }
//
//    // -MARK: Exercise Set View
//    private func exerciseSetView(for exercise: Exercise) -> some View {
//        VStack {
//            if exercise.setsArray.isEmpty {
//                HStack(alignment: .center) {
//                    Text("No added sets")
//                        .foregroundColor(Color("TextColor"))
//                        .frame(maxWidth: .infinity, alignment: .center)
//                }
//
//                addSetButton(for: exercise)
//
//            } else {
//                VStack {
//                    List {
//                        ForEach(exercise.setsArray.enumeratedArray(), id: \.element) { index, set in
//                            Section {
//                                HStack {
//                                    Text("Set \(index + 1):")
//                                        .foregroundColor(Color("TextColor"))
//                                        .padding(.trailing, 10)
//
//                                    Spacer()
//
//                                    TextField("Weight", text: Binding(
//                                        get: { set.weight > 0 ? "\(set.weight)" : "" },
//                                        set: { newValue in
//                                            set.weight = Double(newValue) ?? 0
//                                            viewModel.saveContext()
//                                        }
//                                    ))
//                                    .multilineTextAlignment(.center)
//                                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                                    .keyboardType(.decimalPad)
//
//                                    TextField("Reps", text: Binding(
//                                        get: { set.reps > 0 ? "\(set.reps)" : "" },
//                                        set: { newValue in
//                                            set.reps = Int16(newValue) ?? 0
//                                            viewModel.saveContext()
//                                        }
//                                    ))
//                                    .multilineTextAlignment(.center)
//                                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                                    .keyboardType(.numberPad)
//
//                                }
//                                .padding(.horizontal, 0)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .listRowBackground(Color.clear)
//
//                                // -MARK: Swipe Action
//                                .swipeActions {
//                                    Button(role: .destructive) {
//                                        withAnimation {
//                                            deleteSet(set, exercise: exercise)
//                                        }
//                                    } label: {
//                                        Text("Delete")
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .listStyle(PlainListStyle())
//                    .frame(maxWidth: .infinity)
//                    .scrollContentBackground(.hidden)
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.top, 10)
//                .onTapGesture {
//                               hideKeyboard()
//                           }
//
//                addSetButton(for: exercise)
//            }
//        }
//        .frame(height: expandedExercise == exercise.name ? CGFloat(exercise.setsArray.count * 50 + 120) : 0)
//        .frame(maxWidth: .infinity)
//    }
//
//
//
//    // -MARK: Add Set Button
//    private func addSetButton(for exercise: Exercise) -> some View {
//        Button(action: {
//
//            viewModel.addSet(to: exercise)
//
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
//            .padding(.top, 10)
//            .padding(.bottom, 10)
//        }
//    }
//
//    private var deleteButton: some View {
//           Button(action: {
//               if let workoutDay = workoutDay {
//                   viewModel.deleteWorkoutDay(workoutDay)
//               }
//           }) {
//               Image(systemName: "trash.fill")
//                   .font(.system(size: 18))
//                   .foregroundColor(Color("TextColor"))
//                   .padding(15)
//                   .background(Circle().fill(Color.red))
//           }
//       }
//
//    private var addExerciseButton: some View {
//           Button(action: {
//               isShowingExercisesView = true
//           }) {
//               HStack {
//                   Image(systemName: "plus")
//                       .font(.system(size: 20, weight: .regular))
//                       .foregroundColor(.white)
//                       .padding(15)
//                       .background(Circle().fill(Color("ButtonColor")))
//               }
//           }
//       }
//
//
//    func deleteExercise(_ exercise: Exercise) {
//        viewModel.deleteExercise(exercise)
//    }
//
//    func deleteSet(_ set: ExerciseSet, exercise: Exercise) {
//        viewModel.deleteSet(set, in: exercise)
//    }
//
//    func hideKeyboard() {
//        UIApplication.shared.endEditing()
//    }
//}
//
//extension WorkoutDay {
//    var exercisesArray: [Exercise] {
//        let set = exercises as? Set<Exercise> ?? []
//        return set.sorted { $0.name ?? "" < $1.name ?? "" } // Сортировка по имени
//    }
//}
//
//extension Exercise {
//    var setsArray: [ExerciseSet] {
//        let set = sets as? Set<ExerciseSet> ?? []
//        return set.sorted { $0.count < $1.count } // Упорядочьте по вашему усмотрению
//    }
//}
//
//extension Array {
//    func enumeratedArray() -> [(offset: Int, element: Element)] {
//        return self.enumerated().map { (offset: $0.offset, element: $0.element) }
//    }
//}
//
//extension NumberFormatter {
//    static var decimal: NumberFormatter {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
//        return formatter
//    }
//
//    static var integer: NumberFormatter {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .none
//        return formatter
//    }
//}
//
//
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
//        if let image = UIImage(named: "Push-Ups") {
//            exercise.image = image.pngData()  // Сохраняем изображение в формате PNG
//        }
//
//        // Создаем пример упражнения
//        let exercise1 = Exercise(context: context)
//        exercise1.name = "New Exercise"
//        if let image = UIImage(named: "defaultExerciseImage") {
//            exercise1.image = image.pngData()  // Сохраняем изображение в формате PNG
//        }
//
//        workoutDay.addToExercises(exercise)
//        workoutDay.addToExercises(exercise1)
//
//        // Добавляем пример подходов к упражнению
//        let set1 = ExerciseSet(context: context)
//        set1.weight = 20
//        set1.reps = 15
//        set1.count = 1
//
//        set1.exercise = exercise
//
//        let set2 = ExerciseSet(context: context)
//        set2.weight = 25
//        set2.reps = 12
//        set2.count = 2
//
//        set2.exercise = exercise
//
//        let set3 = ExerciseSet(context: context)
//        set3.weight = 30
//        set3.reps = 12
//        set3.count = 3
//
//        set3.exercise = exercise
//
//        let set4 = ExerciseSet(context: context)
//        set4.weight = 35
//        set4.reps = 12
//        set4.count = 4
//
//        set4.exercise = exercise
//
//        // Возвращаем `WorkoutDayDetailsView` с переданными данными
//        return WorkoutDayDetailsView(
//            viewModel: WorkoutViewModel(),
//            workoutDay: .constant(workoutDay)
//        )
//        .environment(\.managedObjectContext, context)  // Используем mock контекст
//    }
//}


import SwiftUI

struct WorkoutDayDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var viewModel: WorkoutViewModel
    @Binding var workoutDay: WorkoutDay?
    
    @State private var bodyWeight: Double = 0.0
    @State private var isShowingExercisesView = false
    
    @State private var expandedExercise: String? = nil
    
    @State private var expandedExercises: [String: Bool] = [:]
    
    @State private var weightString: String = ""
    @State private var repsString: String = ""
    
    @State private var isPanelVisible: Bool = false
    @State private var panelOffset: CGFloat = 0
    
    @State private var isBodyWeightViewVisible: Bool = false
    @State private var isEditingBodyWeight: Bool = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            VStack {
                bodyWeightView
                exercisesListView
                emptyExercisesScreenView
                    .offset(x: isPanelVisible ? -UIScreen.main.bounds.width : 0)
            }
            .padding(.top, 20)
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
                .fill(Color.gray.opacity(0.2))
                .frame(width: 10, height: 90)
                .cornerRadius(5)
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
            hideKeyboard()
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
    
    func hideKeyboard() {
        UIApplication.shared.endEditing()
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
                    
                    expandedExercise = expandedExercise == exercise.name ? nil : exercise.name
                    
                }) {
                    Image(systemName: expandedExercise == exercise.name ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .frame(width: 20, height: 20)
                }
                
            }
            .frame(height: 50)
            
            // Используем List и Section для отображения подходов
            if expandedExercise == exercise.name {
                
                exerciseSetView(for: exercise)
            }
        }
    }
    
    // -MARK: Exercise Set View
    private func exerciseSetView(for exercise: Exercise) -> some View {
        VStack {
            if exercise.setsArray.isEmpty {
                HStack(alignment: .center) {
                    Text("No added sets")
                        .foregroundColor(Color("TextColor"))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                addSetButton(for: exercise)
                
            } else {
                VStack {
                    List {
                        ForEach(exercise.setsArray.enumeratedArray(), id: \.element) { index, set in
                            Section {
                                HStack {
                                    Text("Set \(index + 1):")
                                        .foregroundColor(Color("TextColor"))
                                        .padding(.trailing, 10)
                                    
                                    Spacer()
                                    
                                    TextField("Weight", text: Binding(
                                        get: { set.weight > 0 ? "\(set.weight)" : "" },
                                        set: { newValue in
                                            let formattedValue = newValue.replacingOccurrences(of: ",", with: ".")
                                            set.weight = Double(formattedValue) ?? 0
                                            viewModel.saveContext()
                                        }
                                    ))
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                                    .environment(\.locale, Locale(identifier: "en_US"))
                                    
                                    TextField("Reps", text: Binding(
                                        get: { set.reps > 0 ? "\(set.reps)" : "" },
                                        set: { newValue in
                                            set.reps = Int16(newValue) ?? 0
                                            viewModel.saveContext()
                                        }
                                    ))
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                    
                                }
                                .padding(.horizontal, 0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .listRowBackground(Color.clear)
                                
                                // -MARK: Swipe Action
                                .swipeActions {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            deleteSet(set, exercise: exercise)
                                        }
                                    } label: {
                                        Text("Delete")
                                    }
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .listStyle(PlainListStyle())
                    .frame(maxWidth: .infinity)
                    .scrollContentBackground(.hidden)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .onTapGesture {
                    hideKeyboard()
                }
                
                addSetButton(for: exercise)
            }
        }
        .frame(height: expandedExercise == exercise.name ? CGFloat(exercise.setsArray.count * 50 + 70) : 0)
        .frame(maxWidth: .infinity)
    }
    
    
    
    // -MARK: Add Set Button
    private func addSetButton(for exercise: Exercise) -> some View {
        Button(action: {
            
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
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
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
        viewModel.deleteExercise(exercise)
    }
    
    func deleteSet(_ set: ExerciseSet, exercise: Exercise) {
        viewModel.deleteSet(set, in: exercise)
    }
    
    
}

extension WorkoutDay {
    var exercisesArray: [Exercise] {
        let set = exercises as? Set<Exercise> ?? []
        return set.sorted { $0.name ?? "" < $1.name ?? "" } // Сортировка по имени
    }
}

extension Exercise {
    var setsArray: [ExerciseSet] {
        let set = sets as? Set<ExerciseSet> ?? []
        return set.sorted { $0.count < $1.count } // Упорядочьте по вашему усмотрению
    }
}

extension Array {
    func enumeratedArray() -> [(offset: Int, element: Element)] {
        return self.enumerated().map { (offset: $0.offset, element: $0.element) }
    }
}

extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    static var integer: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
}


struct WorkoutDayDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        
        // Создаем пример тренировочного дня
        let workoutDay = WorkoutDay(context: context)
        workoutDay.date = Date()
        
        //        // Создаем пример упражнения
        //        let exercise = Exercise(context: context)
        //        exercise.name = "Push-ups"
        //        if let image = UIImage(named: "Push-Ups") {
        //            exercise.image = image.pngData()  // Сохраняем изображение в формате PNG
        //        }
        //
        //        // Создаем пример упражнения
        //        let exercise1 = Exercise(context: context)
        //        exercise1.name = "New Exercise"
        //        if let image = UIImage(named: "defaultExerciseImage") {
        //            exercise1.image = image.pngData()  // Сохраняем изображение в формате PNG
        //        }
        //
        //        workoutDay.addToExercises(exercise)
        //        workoutDay.addToExercises(exercise1)
        //
        //        // Добавляем пример подходов к упражнению
        //        let set1 = ExerciseSet(context: context)
        //        set1.weight = 20
        //        set1.reps = 15
        //        set1.count = 1
        //
        //        set1.exercise = exercise
        //
        //        let set2 = ExerciseSet(context: context)
        //        set2.weight = 25
        //        set2.reps = 12
        //        set2.count = 2
        //
        //        set2.exercise = exercise
        //
        //        let set3 = ExerciseSet(context: context)
        //        set3.weight = 30
        //        set3.reps = 12
        //        set3.count = 3
        //
        //        set3.exercise = exercise
        //
        //        let set4 = ExerciseSet(context: context)
        //        set4.weight = 35
        //        set4.reps = 12
        //        set4.count = 4
        //
        //        set4.exercise = exercise
        
        // Возвращаем `WorkoutDayDetailsView` с переданными данными
        return WorkoutDayDetailsView(
            viewModel: WorkoutViewModel(),
            workoutDay: .constant(workoutDay)
        )
        .environment(\.managedObjectContext, context)  // Используем mock контекст
    }
}
