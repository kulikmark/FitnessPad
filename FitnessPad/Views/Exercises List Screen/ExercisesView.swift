//
//  ExercisesView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

//import SwiftUI
//import CoreData
//
//enum AlertType {
//    case delete(DefaultExercise)
//    case defaultExercise
//    case alreadyAdded
//    case resetDefaults
//    case error
//}
//
//struct ExercisesView: View {
//    @EnvironmentObject var workoutViewModel: WorkoutDayViewModel
//    @EnvironmentObject var exerciseViewModel: ExerciseViewModel
//    @EnvironmentObject var coreDataService: CoreDataService
//    @State var isEditing = false
//    @State var selectedExercise: DefaultExercise?
//    @State private var isShowingAddExerciseView = false
//    @State private var isShowingEditExerciseView = false
//    @State private var isFromWokroutDayView: Bool
//    @State private var showFavouritesOnly = false
//    
//    @State private var selectedDate: Date
//    
//    @State private var alertType: AlertType?
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//    
//    @State private var navigationPath = NavigationPath()
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    // Добавьте инициализатор
//    init(isFromWokroutDayView: Bool = false, selectedDate: Date = Date()) {
//         _isFromWokroutDayView = State(initialValue: isFromWokroutDayView)
//         _selectedDate = State(initialValue: selectedDate)
//     }
//    
//    var body: some View {
//           NavigationStack(path: $navigationPath) { // Используем NavigationStack
//               VStack(alignment: .leading, spacing: 20) {
//                   exercisesListHeaderView
//                   exercisesListView
//               }
//               .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
//               .sheet(isPresented: $isShowingAddExerciseView) {
//                   ExerciseFormView(exerciseViewModel: exerciseViewModel)
//                       .background(Color("BackgroundColor"))
//                       .edgesIgnoringSafeArea(.all)
//                       .transition(.opacity)
//               }
//               .sheet(isPresented: $isShowingEditExerciseView) {
//                   if let exercise = selectedExercise {
//                       ExerciseFormView(viewModel: viewModel, exerciseToEdit: exercise)
//                           .background(Color("BackgroundColor"))
//                           .edgesIgnoringSafeArea(.all)
//                           .transition(.opacity)
//                   }
//               }
//               .alert(isPresented: $showingAlert) {
//                   alertForExerciseManipulations()
//               }
//               .navigationDestination(for: DefaultExercise.self) { exercise in
//                   ExerciseDetailView(exerciseViewModel: exerciseViewModel, coreDataService: coreDataService, exercise: exercise)
//               }
//           }
//       }
//    
//    // MARK: - Header
//    var exercisesListHeaderView: some View {
//        HStack(spacing: 15) {
//            Text("Exercises List")
//                .font(.system(size: 24))
//                .fontWeight(.medium)
//                .foregroundColor(Color("TextColor"))
//                .frame(maxWidth: .infinity, alignment: .leading)
//            
//            Spacer()
//            resetDefaultsButton
//            heartButton
//            addButton
//        }
//        .padding(.horizontal)
//    }
//    
//    // MARK: - Exercises List View
//    private var exercisesListView: some View {
//        List {
//            // Группируем упражнения по категориям
//            ForEach(exerciseViewModel.allDefaultExercisesGroupedByCategory, id: \.category) { category, exercises in
//                let filteredExercises = showFavouritesOnly ? exercises.filter { $0.isFavourite } : exercises
//                
//                if !filteredExercises.isEmpty {
//                    Section {
//                        // Название категории
//                        Text(category)
//                            .font(.headline)
//                            .foregroundColor(Color("TextColor"))
//                            .padding(.top, 10)
//                            .padding(.bottom, 10)
//                        
//                        // Сами упражнения
//                        ForEach(filteredExercises, id: \.self) { exercise in
//                            exerciseRow(for: exercise)
//                                .listRowBackground(Color.clear)
//                        }
//                    }
//                    .listRowBackground(Color.clear)
//                }
//            }
//        }
//        .scrollIndicators(.hidden)
//        .scrollContentBackground(.hidden)
//        .listStyle(PlainListStyle())
//        .padding(.bottom, 33)
//    }
//    
//    
//    // MARK: - Swipe Actions
//    private func deleteSwipeAction(for exercise: DefaultExercise) -> some View {
//        Button(action: {
//            deleteExercise(exercise)
//            selectedExercise = exercise
//        }) {
//            Label("Delete", systemImage: "trash")
//                .foregroundColor(.text)
//        }
//        .tint(.red)
//    }
//    
//    private func editSwipeAction(for exercise: DefaultExercise) -> some View {
//        Button(action: {
//            isShowingEditExerciseView = true
//            selectedExercise = exercise
//            print(exercise)
//        }) {
//            if let uiImage = UIImage(systemName: "pencil")?
//                .withTintColor(UIColor(Color("TextColor")), renderingMode: .alwaysOriginal) {
//                Image(uiImage: uiImage) // Преобразуем UIImage в Image SwiftUI
//            }
//        }
//        .tint(.clear) // Убираем стандартный tint кнопки
//    }
//    
//    private func favouriteSwipeAction(for exercise: DefaultExercise) -> some View {
//        Button(action: {
//            toggleFavourite(for: exercise)
//        }) {
//            Image(uiImage: UIImage(systemName: exercise.isFavourite ? "heart.fill" : "heart")!
//                .withTintColor(exercise.isFavourite ? .red : .gray, renderingMode: .alwaysOriginal))
//        }
//        .tint(.clear) // Убираем системный tint
//    }
//    
//    private func toggleFavourite(for exercise: DefaultExercise) {
//        exerciseViewModel.toggleFavourite(for: exercise)
//    }
//    
//    private func lockedSwipeAction(for exercise: DefaultExercise) -> some View {
//        Button(action: {
//            // Показываем алерт, что это дефолтное упражнение
//            alertType = .defaultExercise
//            showingAlert = true
//        }) {
//            Image(systemName: "lock.fill")
//                .foregroundColor(.text)
//        }
//        .tint(.gray)
//    }
//    
//    // MARK: - Exercise Row View
//        private func exerciseRow(for exercise: DefaultExercise) -> some View {
//            Section {
//                Button {
//                    if isFromWokroutDayView {
//                        // Логика добавления упражнения в тренировочный день
//                        addExerciseToWorkoutDay(for: exercise, isFromWokroutDayView: true)
//                    } else {
//                        // Логика для перехода из таббара
//                        navigationPath.append(exercise)
//                    }
//                } label: {
//                    HStack {
//                        exerciseImage(for: exercise)
//                            .frame(width: 100, height: 50)
//                            .clipShape(RoundedRectangle(cornerRadius: 3))
//                        
//                        Text(exercise.name ?? "Unknown")
//                            .font(.system(size: 16))
//                            .foregroundColor(Color("TextColor"))
//                            .padding(.leading, 10)
//                        
//                        Spacer()
//                    }
//                    .frame(height: 50)
//                    .frame(maxWidth: .infinity)
//                }
//                .swipeActions {
//                    if exercise.isDefault {
//                        lockedSwipeAction(for: exercise)
//                    } else {
//                        deleteSwipeAction(for: exercise)
//                    }
//                    favouriteSwipeAction(for: exercise)
//                }
//            }
//        }
//
//    
//    // MARK: - Exercise Image View
//    func exerciseImage(for item: DefaultExercise) -> some View {
//        let defaultExerciseImage = UIImage(named: "defaultExerciseImage")!
//        let image: UIImage
//        if let imageData = item.image, let userImage = UIImage(data: imageData) {
//            image = userImage
//        } else {
//            image = defaultExerciseImage // Используйте здесь вашу картинку по умолчанию
//        }
//        
//        return Image(uiImage: image)
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//    }
//    
//    // MARK: - Header Buttons
//    var resetDefaultsButton: some View {
//        HStack (spacing: 10) {
//            Text("Restore\nExercises")
//                .font(.system(size: 8))
//                .foregroundColor(Color("TextColor"))
//            
//            Button(action: {
//                alertType = .resetDefaults
//                showingAlert = true
//            }) {
//                Image(systemName: "arrow.counterclockwise")
//                    .font(.system(size: 16))
//                    .foregroundColor(Color("TextColor"))
//            }
//        }
//        .padding(.trailing, 20)
//    }
//    
//    var addButton: some View {
//        Button(action: {
//            isShowingAddExerciseView = true
//        }) {
//            Image(systemName: "plus")
//                .font(.system(size: 17))
//                .foregroundColor(Color("TextColor"))
//        }
//    }
//    
//    var heartButton: some View {
//        Button(action: {
//            showFavouritesOnly.toggle()
//        }) {
//            Image(systemName: showFavouritesOnly ? "heart.fill" : "heart")
//                .font(.system(size: 17))
//                .foregroundColor(showFavouritesOnly ? .red : Color("TextColor"))
//        }
//    }
//    
//    // MARK: - Helper Functions
//    
//    private func addExerciseToWorkoutDay(for exercise: DefaultExercise, isFromWokroutDayView: Bool = false) {
//        if isFromWokroutDayView {
//            // Логика добавления упражнения только при вызове из экрана деталей
//            if let workoutDay = workoutViewModel.workoutDay(for: selectedDate),
//               workoutDay.exercisesArray.contains(where: { $0.id == exercise.id }) {
//                print("Exercise already added: \(exercise.name ?? "Unknown")")
//                alertType = .alreadyAdded
//                showingAlert = true
//            } else {
//                print("Adding exercise: \(exercise.name ?? "Unknown")")
////                viewModel.addExerciseToWorkoutDay(exercise, workoutDay: viewModel.workoutDay(for: selectedDate), date: selectedDate)
//                workoutViewModel.addExerciseToWorkoutDay(exercise, date: selectedDate)
//                workoutViewModel.fetchWorkoutDays() // Обновляем кэш
//                presentationMode.wrappedValue.dismiss()
//            }
//        } else {
//            // Логика для вызова из таббара (ничего не делаем или показываем сообщение)
//          
//        }
//    }
//    
//    
//    private func deleteExercise(_ exercise: DefaultExercise) {
//        if exercise.isDefault {
//            // Не даем удалить предустановленные упражнения
//            alertType = .defaultExercise
//            showingAlert = true
//        } else {
//            // Показываем предупреждение для удаления недефолтного упражнения
//            alertType = .delete(exercise)
//            showingAlert = true
//        }
//    }
//    
//    private func resetToDefaultExercises() {
//        
//        PersistenceController.shared.resetDefaultExercises(viewModel: exerciseViewModel)
//        
//    }
//    
//    private func confirmDeletion(for exercise: DefaultExercise) {
//        // Если пользователь подтвердил удаление
//        exerciseViewModel.deleteExerciseFromCoreData(exercise: exercise)
//        
//        // Удаляем упражнение из Core Data
//      
////        let context = viewModel.viewContext
////        context.delete(exercise)
//        
////        do {
////            try context.save()
////        } catch {
////            print("Error saving after deletion: \(error)")
////        }
//        coreDataService.saveContext()
//    }
//    
//    private func alertForExerciseManipulations() -> Alert {
//        guard let alertType = alertType else {
//            return Alert(
//                title: Text("Error"),
//                message: Text("Something went wrong."),
//                dismissButton: .default(Text("OK"))
//            )
//        }
//        
//        switch alertType {
//        case .delete(let exercise):
//            return Alert(
//                title: Text("Warning"),
//                message: Text("This will remove the exercise from all workout days and reset your progress. Are you sure you want to delete it?"),
//                primaryButton: .destructive(Text("Delete")) {
//                    confirmDeletion(for: exercise)
//                },
//                secondaryButton: .cancel()
//            )
//        case .defaultExercise:
//            return Alert(
//                title: Text("Locked Operation"),
//                message: Text("You cannot delete or edit the default exercise."),
//                dismissButton: .default(Text("OK"))
//            )
//        case .alreadyAdded:
//            return Alert(
//                title: Text("Exercise Already Added"),
//                message: Text("This exercise is already added to your workout day."),
//                dismissButton: .default(Text("OK"))
//            )
//        case .resetDefaults:
//            return Alert(
//                title: Text("Reset Exercises"),
//                message: Text("All exercises will be reset to their original state. This action cannot be undone."),
//                primaryButton: .destructive(Text("Continue")) {
//                    resetToDefaultExercises()
//                },
//                secondaryButton: .cancel()
//            )
//        case .error:
//            return Alert(
//                title: Text("Error"),
//                message: Text("Something went wrong."),
//                dismissButton: .default(Text("OK"))
//            )
//        }
//    }
//}
//
//
//// MARK: - Previews
//
////struct ExercisesView_Previews: PreviewProvider {
////    static var previews: some View {
////        // Создание фейковых упражнений
////        let exercise1 = DefaultExercise(context: PersistenceController.shared.container.viewContext)
////        exercise1.name = "Push Up"
////        exercise1.image = UIImage(named: "defaultExerciseImage")?.jpegData(compressionQuality: 1.0)
////        
////        // Добавляем фейковые упражнения в WorkoutViewModel
////        let viewModel = FitnessPadViewModel()
////        viewModel.allDefaultExercises = [exercise1]
////        
////        return ExercisesView()
////        .environmentObject(viewModel) // Передаем viewModel как EnvironmentObject
////        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
////    }
////}


//
//  ExercisesView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI
import CoreData

enum AlertType {
    case delete(DefaultExercise)
    case defaultExercise
    case alreadyAdded
    case resetDefaults
    case error
}

struct ExercisesView: View {
    @EnvironmentObject var workoutViewModel: WorkoutDayViewModel
    @EnvironmentObject var exerciseViewModel: ExerciseViewModel
    @EnvironmentObject var coreDataService: CoreDataService
    
    @State private var isShowingAddExerciseView = false
    @State private var isFromWokroutDayView: Bool
    @State private var showFavouritesOnly = false
    @State private var searchText = ""
    
    @State private var selectedDate: Date
    
    @State private var alertType: AlertType?
    @State private var showingAlert = false
    
    @State private var navigationPath = NavigationPath()
    
    @State private var isSearchBarVisible = false
    
    @Environment(\.presentationMode) var presentationMode
    
    init(isFromWokroutDayView: Bool = false, selectedDate: Date = Date()) {
        _isFromWokroutDayView = State(initialValue: isFromWokroutDayView)
        _selectedDate = State(initialValue: selectedDate)
    }
    
    var body: some View {
          NavigationStack(path: $navigationPath) {
              VStack(alignment: .leading, spacing: 20) {
                
                  exercisesViewTitle
                  if isSearchBarVisible { // Условно отображаем SearchBar
                      ExercisesViewSearchBar(text: $searchText)
                  }
                  
                  exercisesViewButtonsHeader
                  exercisesListView
              }
              .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
              .sheet(isPresented: $isShowingAddExerciseView) {
                  ExerciseFormView(exerciseViewModel: exerciseViewModel)
                      .background(Color("BackgroundColor"))
                      .edgesIgnoringSafeArea(.all)
                      .transition(.opacity)
              }
              .alert(isPresented: $showingAlert) {
                  alertForExerciseManipulations()
              }
              .navigationDestination(for: DefaultExercise.self) { exercise in
                  ExerciseDetailView(exerciseViewModel: exerciseViewModel, coreDataService: coreDataService, exercise: exercise)
              }
          }
      }
    
    
    // MARK: - Header
    var exercisesViewTitle: some View {
        HStack {
        Text("exercises_list_title".localized)
            .font(.system(size: 24))
            .fontWeight(.medium)
            .foregroundColor(Color("TextColor"))
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        searchButton
    }
        .padding(.horizontal)
    }
    
    // MARK: - Buttons Header
    var exercisesViewButtonsHeader: some View {
        HStack(spacing: 15) {
            // Кнопка для сброса настроек
                        buttonWithLabelAndImage(
                            label: "restore_exercises_button",
                            systemImageName: "arrow.counterclockwise",
                            labelColor: Color("TextColor"),
                            imageColor: Color("TextColor"),
                            action: {
                                alertType = .resetDefaults
                                showingAlert = true
                            }
                        )
            Spacer()
            // Кнопка для отображения только избранных
                       buttonWithLabelAndImage(
                           label: "favourites_only_button",
                           systemImageName: showFavouritesOnly ? "heart.fill" : "heart",
                           labelColor: Color("TextColor"),
                           imageColor: showFavouritesOnly ? .red : Color("TextColor"),
                           action: {
                               showFavouritesOnly.toggle()
                           }
                       )
            // Кнопка для добавления нового упражнения
                       buttonWithLabelAndImage(
                           label: "add_exercise_button",
                           systemImageName: "plus",
                           labelColor: Color("TextColor"),
                           imageColor: Color("TextColor"),
                           action: {
                               isShowingAddExerciseView = true
                           }
                       )
        }
        .padding(.horizontal)
    }
    
    // MARK: - Exercises List View
    private var exercisesListView: some View {
        List {
            // Группируем упражнения по категориям
            ForEach(exerciseViewModel.allDefaultExercisesGroupedByCategory, id: \.category) { category, exercises in
                let filteredExercises = filteredExercises(for: exercises)
                
                if !filteredExercises.isEmpty {
                    Section {
                        // Название категории
                        Text(category)
                            .font(.headline)
                            .foregroundColor(Color("TextColor"))
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                        
                        // Сами упражнения
                        ForEach(filteredExercises, id: \.self) { exercise in
                            exerciseRow(for: exercise)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listStyle(PlainListStyle())
        .padding(.bottom, 33)
    }
    
    // MARK: - Filtered Exercises
    private func filteredExercises(for exercises: [DefaultExercise]) -> [DefaultExercise] {
        var filtered = exercises
        
        // Фильтр по избранным
        if showFavouritesOnly {
            filtered = filtered.filter { $0.isFavourite }
        }
        
        // Фильтр по поиску
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name?.localizedCaseInsensitiveContains(searchText) == true }
        }
        
        return filtered
    }
    
    // MARK: - Swipe Actions
    private func deleteSwipeAction(for exercise: DefaultExercise) -> some View {
        Button(action: {
            deleteExercise(exercise)
        }) {
            Label("Delete", systemImage: "trash")
                .foregroundColor(.text)
        }
        .tint(.red)
    }
    
    private func favouriteSwipeAction(for exercise: DefaultExercise) -> some View {
        Button(action: {
            toggleFavourite(for: exercise)
        }) {
            Image(uiImage: UIImage(systemName: exercise.isFavourite ? "heart.fill" : "heart")!
                .withTintColor(exercise.isFavourite ? .red : .gray, renderingMode: .alwaysOriginal))
        }
        .tint(.clear)
    }
    
    private func toggleFavourite(for exercise: DefaultExercise) {
        exerciseViewModel.toggleFavourite(for: exercise)
    }
    
    private func lockedSwipeAction(for exercise: DefaultExercise) -> some View {
        Button(action: {
            alertType = .defaultExercise
            showingAlert = true
        }) {
            Image(systemName: "lock.fill")
                .foregroundColor(.text)
        }
        .tint(.gray)
    }
    
    // MARK: - Exercise Row View
        private func exerciseRow(for exercise: DefaultExercise) -> some View {
            Section {
                Button {
                    if isFromWokroutDayView {
                        // Логика добавления упражнения в тренировочный день
                        addExerciseToWorkoutDay(for: exercise, isFromWokroutDayView: true)
                    } else {
                        // Логика для перехода из таббара
                        navigationPath.append(exercise)
                    }
                } label: {
                    HStack {
                        exerciseImage(for: exercise)
                            .frame(width: 100, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                        
                        Text(exercise.name ?? "Unknown")
                            .font(.system(size: 16))
                            .foregroundColor(Color("TextColor"))
                            .padding(.leading, 10)
                        
                        Spacer()
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                }
                .swipeActions {
                    if exercise.isDefault {
                        lockedSwipeAction(for: exercise)
                    } else {
                        deleteSwipeAction(for: exercise)
                    }
                    favouriteSwipeAction(for: exercise)
                }
            }
        }
    
    // MARK: - Exercise Image View
    func exerciseImage(for item: DefaultExercise) -> some View {
        let defaultExerciseImage = UIImage(named: "defaultExerciseImage")!
        let image: UIImage
        if let imageData = item.image, let userImage = UIImage(data: imageData) {
            image = userImage
        } else {
            image = defaultExerciseImage
        }
        
        return Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
    
    // MARK: - Header Buttons
       var searchButton: some View {
           Button(action: {
               withAnimation {
                   isSearchBarVisible.toggle()
               }
           }) {
               Image(systemName: "magnifyingglass")
                   .font(.system(size: 20))
                   .foregroundColor(Color("TextColor"))
           }
       }
    
    var resetDefaultsButton: some View {
        HStack(spacing: 5) {
            Text("restore_exercises_button".localized)
                .font(.system(size: 8))
                .foregroundColor(Color("TextColor"))
            
            Button(action: {
                alertType = .resetDefaults
                showingAlert = true
            }) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
            }
        }
        .padding(.trailing, 20)
    }
    
    var addButton: some View {
        HStack(spacing: 5) {
            Text("add_exercise_button".localized)
                .font(.system(size: 8))
                .foregroundColor(Color("TextColor"))
            
            Button(action: {
                isShowingAddExerciseView = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 17))
                    .foregroundColor(Color("TextColor"))
            }
        }
    }
    
    var heartButton: some View {
        HStack(spacing: 5) {
            Text("favourites_only_button".localized)
                .font(.system(size: 8))
                .foregroundColor(Color("TextColor"))
            Button(action: {
                showFavouritesOnly.toggle()
            }) {
                Image(systemName: showFavouritesOnly ? "heart.fill" : "heart")
                    .font(.system(size: 17))
                    .foregroundColor(showFavouritesOnly ? .red : Color("TextColor"))
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func addExerciseToWorkoutDay(for exercise: DefaultExercise, isFromWokroutDayView: Bool = false) {
        if isFromWokroutDayView {
            if let workoutDay = workoutViewModel.workoutDay(for: selectedDate),
               workoutDay.exercisesArray.contains(where: { $0.id == exercise.id }) {
                alertType = .alreadyAdded
                showingAlert = true
            } else {
                workoutViewModel.addExerciseToWorkoutDay(exercise, date: selectedDate)
                workoutViewModel.fetchWorkoutDays()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func deleteExercise(_ exercise: DefaultExercise) {
        if exercise.isDefault {
            alertType = .defaultExercise
            showingAlert = true
        } else {
            alertType = .delete(exercise)
            showingAlert = true
        }
    }
    
    private func resetToDefaultExercises() {
        PersistenceController.shared.resetDefaultExercises(viewModel: exerciseViewModel)
    }
    
    private func confirmDeletion(for exercise: DefaultExercise) {
        exerciseViewModel.deleteExerciseFromCoreData(exercise: exercise)
        coreDataService.saveContext()
    }
    
    private func alertForExerciseManipulations() -> Alert {
        guard let alertType = alertType else {
            return Alert(
                title: Text("error_title".localized),
                message: Text("error_message".localized),
                dismissButton: .default(Text("OK"))
            )
        }
        
        switch alertType {
        case .delete(let exercise):
            return Alert(
                title: Text("delete_exercise_warning_title".localized),
                message: Text("delete_exercise_warning_message".localized),
                primaryButton: .destructive(Text("delete_button".localized)) {
                    confirmDeletion(for: exercise)
                },
                secondaryButton: .cancel(Text("cancel_button".localized))
            )
        case .defaultExercise:
            return Alert(
                title: Text("default_exercise_alert_title".localized),
                message: Text("default_exercise_alert_message".localized),
                dismissButton: .default(Text("OK"))
            )
        case .alreadyAdded:
            return Alert(
                title: Text("exercise_already_added_title".localized),
                message: Text("exercise_already_added_message".localized),
                dismissButton: .default(Text("OK"))
            )
        case .resetDefaults:
            return Alert(
                title: Text("reset_exercises_title".localized),
                message: Text("reset_exercises_message".localized),
                primaryButton: .destructive(Text("continue_button".localized)) {
                    resetToDefaultExercises()
                },
                secondaryButton: .cancel(Text("cancel_button".localized))
            )
        case .error:
            return Alert(
                title: Text("error_title".localized),
                message: Text("error_message".localized),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
