//
//  ExercisesView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

//import SwiftUI
//import CoreData
//
//struct ExercisesView: View {
//    @ObservedObject var viewModel: WorkoutViewModel
//    @State var isEditing = false
//    @State var selectedExerciseItem: DefaultExercise?
//    @State private var isShowingAddExerciseView = false
//    @State var isPresentingEditExerciseView = false
//    @Binding var workoutDay: WorkoutDay?
//    
//    @State private var showingAlert = false
//    @State private var alertMessage = ""
//    
//    @Environment(\.presentationMode) var presentationMode
//
//    // Пример для сетки
//    let gridForm = [GridItem(.flexible()), GridItem(.flexible())]
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            header
//            exerciseGroups
//        }
//        .onAppear {
//            viewModel.loadDefaultExercises()
//        }
//        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
//        .sheet(isPresented: $isShowingAddExerciseView) {
//            AddExerciseView(viewModel: viewModel)
//                .background(Color("BackgroundColor"))
//                .edgesIgnoringSafeArea(.all)
//                .transition(.opacity)
//        }
//        .navigationBarBackButtonHidden(true)
//        .alert(isPresented: $showingAlert) {
//            alertForExerciseManipulations(exercise: selectedExerciseItem)
//        }
//
//    }
//
//    // MARK: - Header
//    var header: some View {
//        HStack {
//            Text("Exercises List")
//                .font(.system(size: 35))
//                .fontWeight(.medium)
//                .foregroundColor(Color("TextColor"))
//                .padding(.top, 20)
//                .padding(.leading, 20)
//                .padding(.bottom, 20)
//
//            Spacer()
//
//            editButton
//            addButton
//        }
//    }
//
//    // MARK: - Exercise Groups
//    var exerciseGroups: some View {
//        ScrollView(showsIndicators: false) {
//            ForEach(groupedExercises.keys.sorted(), id: \.self) { category in
//                VStack(alignment: .leading, spacing: 15) {
//                    groupHeader(for: category)
//                    groupContent(for: category)
//                }
//            }
//        }
//        .padding(.bottom, 40)
//    }
//
//    private var groupedExercises: [String: [DefaultExercise]] {
//        Dictionary(grouping: viewModel.allDefaultExercises, by: { $0.category ?? "Uncategorized" })
//    }
//
//    func groupHeader(for category: String) -> some View {
//        HStack {
//            Text(category)
//                .font(.system(size: 30))
//                .fontWeight(.bold)
//                .foregroundColor(Color("TextColor"))
//                .padding(.leading, 20)
//                .padding(.bottom, 10)
//        }
//    }
//
//    func groupContent(for category: String) -> some View {
//        LazyVGrid(columns: gridForm, spacing: 15) {
//            ForEach(groupedExercises[category] ?? [], id: \.self) { exercise in
//                exerciseButton(for: exercise)
//            }
//        }
//        .padding(.horizontal, 20)
//    }
//    
//    func exerciseButton(for exercise: DefaultExercise) -> some View {
//        VStack {
//            HStack {
//                Spacer()
//                if isEditing {
//                    Button(action: {
//                        deleteExercise(exercise)
//                        selectedExerciseItem = exercise
//                    }) {
//                        Image(systemName: "trash")
//                            .font(.system(size: 20))
//                            .foregroundColor(.red)
//                            .padding(5)
//                    }
//                } else {
//                    
//                }
//            }
//            .frame(maxWidth: .infinity, alignment: .trailing)
//
//            exerciseImage(for: exercise)
//            Text(exercise.name ?? "Unknown")
//                .font(.system(size: 23))
//                .fontWeight(.medium)
//                .foregroundColor(Color("TextColor"))
//                .multilineTextAlignment(.center)
//                .padding(.vertical, 10)
//        }
//        .frame(maxWidth: .infinity, maxHeight: 400)
//        .background(Color.white.opacity(0.1))
//        .cornerRadius(10)
//        .onTapGesture {
//            addExerciseToWorkoutDay(for: exercise)
//        }
//    }
//    
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
//            .frame(minWidth: 150, maxWidth: 200, minHeight: 150, maxHeight: 200)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//    }
//
//    // MARK: - Edit and Add Buttons
//    var editButton: some View {
//        Button(action: {
//            isEditing.toggle()  // Переключаем режим редактирования
//        }) {
//            Image(systemName: isEditing ? "checkmark" : "pencil")  // Используем галочку для редактирования, карандаш — для обычного режима
//                .font(.system(size: 25))
//                .foregroundColor(Color("TextColor"))
//                .padding(.trailing, 20)
//        }
//    }
//    
//    var addButton: some View {
//        Button(action: {
//            isShowingAddExerciseView = true
//        }) {
//            Image(systemName: "plus")
//                .font(.system(size: 25))
//                .foregroundColor(Color("TextColor"))
//        }
//        .padding(.trailing, 20)
//    }
//
//    // MARK: - Helper Functions
//    private func addExerciseToWorkoutDay(for exercise: DefaultExercise) {
//        if workoutDay?.exercisesArray.contains(where: { $0.name == exercise.name }) == true {
//            alertMessage = "Exercise '\(exercise.name ?? "Unknown")' is already added to the workout day."
//                   showingAlert = true
//        } else {
//            viewModel.addExerciseToWorkoutDay(exercise, workoutDay: workoutDay)
//            presentationMode.wrappedValue.dismiss()
//        }
//    }
//    
//    private func deleteExercise(_ exercise: DefaultExercise) {
//        if exercise.isDefault {
//            // Не даем удалить предустановленные упражнения
//            alertMessage = "You cannot delete the default exercise."
//            showingAlert = true
//        } else {
//            // Показываем предупреждение, если это не предустановленное упражнение
//            alertMessage = "This will remove the exercise from all workout days and reset your progress. Are you sure you want to delete it?"
//            showingAlert = true
//        }
//    }
//
//    private func confirmDeletion(for exercise: DefaultExercise) {
//        // Если пользователь подтвердил удаление
//        viewModel.deleteExerciseFromWorkoutDays(exerciseToDelete: exercise)
//        
//        // Удаляем упражнение из Core Data
//        let context = viewModel.viewContext
//        context.delete(exercise)
//        
//        do {
//            try context.save()
//        } catch {
//            print("Error saving after deletion: \(error)")
//        }
//    }
//    
//    private func alertForExerciseManipulations(exercise: DefaultExercise?) -> Alert {
//        // Проверяем, что selectedExerciseItem не nil
//        if let exercise = exercise {
//            print("Exercise passed to alert: \(exercise.name ?? "Unknown")") // Это поможет вам убедиться, что объект передан
//        } else {
//            print("Exercise is nil") // Если selectedExerciseItem == nil
//        }
//        
//        guard let exercise = exercise else {
//            return Alert(
//                title: Text("Error"),
//                message: Text("Something went wrong."),
//                dismissButton: .default(Text("OK"))
//            )
//        }
//
//        if workoutDay?.exercisesArray.contains(where: { $0.name == exercise.name }) == true {
//            return Alert(
//                title: Text("Exercise Already Added"),
//                message: Text(alertMessage),
//                dismissButton: .default(Text("OK"))
//            )
//        }
//        
//        switch exercise.isDefault {
//        case true:
//            // Если упражнение дефолтное, показываем только кнопку "OK"
//            return Alert(
//                title: Text("Warning"),
//                message: Text(alertMessage),
//                dismissButton: .default(Text("OK"))
//            )
//        case false:
//            // Если упражнение не дефолтное, показываем кнопки "Delete" и "Cancel"
//            return Alert(
//                title: Text("Warning"),
//                message: Text(alertMessage),
//                primaryButton: .destructive(Text("Delete")) {
//                    confirmDeletion(for: exercise)
//                },
//                secondaryButton: .cancel()
//            )
//        }
//    }
//
//    
//}

// MARK: - Previews

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        // Создание фейковых упражнений
        let exercise1 = DefaultExercise(context: PersistenceController.shared.container.viewContext)
        exercise1.name = "Push Up"
//        exercise1.categories?.name = "Strength"
        exercise1.image = UIImage(named: "defaultExerciseImage")?.jpegData(compressionQuality: 1.0)

        // Добавляем фейковые упражнения в WorkoutViewModel
        let viewModel = WorkoutViewModel()
        viewModel.allDefaultExercises = [exercise1]

        return ExercisesView(
            viewModel: viewModel, // Используем viewModel с фейковыми данными
            workoutDay: .constant(WorkoutDay(context: PersistenceController.shared.container.viewContext)) // Создаем фейковый WorkoutDay
        )
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}


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
    @ObservedObject var viewModel: WorkoutViewModel
    @State var isEditing = false
    @State var selectedExercise: DefaultExercise?
    @State private var isShowingAddExerciseView = false
    @State private var isShowingEditExerciseView = false
    @Binding var workoutDay: WorkoutDay?
    
    @State private var alertType: AlertType?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            exercisesListView
        }
        .onAppear {
            viewModel.loadDefaultExercises()
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isShowingAddExerciseView) {
            AddExerciseView(viewModel: viewModel)
                .background(Color("BackgroundColor"))
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
        }
        .sheet(isPresented: $isShowingEditExerciseView) {
            if let exercise = selectedExercise {
                EditExerciseView(viewModel: viewModel, exercise: exercise)
                    .background(Color("BackgroundColor"))
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
            }
        }

        .alert(isPresented: $showingAlert) {
            alertForExerciseManipulations()
        }
    }

    // MARK: - Header
    var header: some View {
        HStack {
            Text("Exercises List")
                .font(.system(size: 24))
                .fontWeight(.medium)
                .foregroundColor(Color("TextColor"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
//                .padding(.top, 20)
//                .padding(.leading, 20)
//                .padding(.bottom, 20)

            Spacer()
            resetDefaultsButton
            addButton
        }
        
      
    }

    // MARK: - Exercises List View
    private var exercisesListView: some View {
        List {
            // Группируем упражнения по категориям
            ForEach(viewModel.allDefaultExercisesGroupedByCategory, id: \.category) { category, exercises in
                Section {
                    // Название категории
                    Text(category)
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    
                    // Сами упражнения
                    ForEach(exercises, id: \.self) { exercise in
                        exerciseRow(for: exercise)
                            .listRowBackground(Color.clear)
                           
                    }
                }
                .listRowBackground(Color.clear)
            }
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listStyle(PlainListStyle())
        .padding(.bottom, 33)
    }

    
    // MARK: - Swipe Actions
       private func deleteSwipeAction(for exercise: DefaultExercise) -> some View {
           Button(action: {
              deleteExercise(exercise)
               selectedExercise = exercise
               print("Delete button tapped")
           }) {
               Label("Delete", systemImage: "trash")
                   .foregroundColor(.text)
           }
           .tint(.red)
       }

       private func editSwipeAction(for exercise: DefaultExercise) -> some View {
           Button(action: {
               isShowingEditExerciseView = true
               selectedExercise = exercise
           }) {
               Label("Edit", systemImage: "pencil")
                   .foregroundColor(.text)
           }
           .tint(.viewColor2)
       }
    
    // MARK: - Exercise Row View
    private func exerciseRow(for exercise: DefaultExercise) -> some View {
        Section {
            HStack {
                exerciseImage(for: exercise)
                    .frame(width: 100, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 3))

                Text(exercise.name ?? "Unknown")
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                    .padding(.leading, 10)
                
                    .swipeActions {
                        deleteSwipeAction(for: exercise)
                        editSwipeAction(for: exercise)
                    }

                Spacer()

                Button(action: {
                    selectedExercise = exercise
                    addExerciseToWorkoutDay(for: exercise)
                })
                {
                    
                }
            }
            
            .frame(height: 50)
            
        }
    }

    // MARK: - Exercise Image View
    func exerciseImage(for item: DefaultExercise) -> some View {
        let defaultExerciseImage = UIImage(named: "defaultExerciseImage")!
        let image: UIImage
        if let imageData = item.image, let userImage = UIImage(data: imageData) {
            image = userImage
        } else {
            image = defaultExerciseImage // Используйте здесь вашу картинку по умолчанию
        }

        return Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }

    // MARK: - Reset Defaults Button
      var resetDefaultsButton: some View {
          HStack (spacing: 10) {
              Text("Restore\nExercises")
                  .font(.system(size: 8))
                  .fontWeight(.medium)
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
         
          .padding(7)
          .background(Color("ViewColor").opacity(0.2))
          .cornerRadius(10)
          .padding(.trailing, 30)
      }
    
    // MARK: - Edit and Add Buttons
var addButton: some View {
        Button(action: {
            isShowingAddExerciseView = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 17))
                .foregroundColor(Color("TextColor"))
                .padding(7)
                .background(Circle().fill(Color("ButtonColor")))
               
        }
        .padding(.trailing, 20)
    }

    // MARK: - Helper Functions
    
    private func addExerciseToWorkoutDay(for exercise: DefaultExercise) {
        
        if workoutDay?.exercisesArray.contains(where: { $0.name == exercise.name }) == true {
            print("Exercise already added: \(exercise.name ?? "Unknown")")
            alertType = .alreadyAdded
            showingAlert = true
        } else {
            print("Adding exercise: \(exercise.name ?? "Unknown")")
            viewModel.addExerciseToWorkoutDay(exercise, workoutDay: workoutDay)
            presentationMode.wrappedValue.dismiss()
        }
    }

    
    private func deleteExercise(_ exercise: DefaultExercise) {
        if exercise.isDefault {
            // Не даем удалить предустановленные упражнения
            alertType = .defaultExercise
            showingAlert = true
        } else {
            // Показываем предупреждение для удаления недефолтного упражнения
            alertType = .delete(exercise)
            showingAlert = true
        }
    }

    private func resetToDefaultExercises() {
        Task {
            await PersistenceController.shared.resetDefaultExercises(viewModel: viewModel)
                   }
       }
    
    private func confirmDeletion(for exercise: DefaultExercise) {
        // Если пользователь подтвердил удаление
        viewModel.deleteExerciseFromCoreData(exercise)
        
        // Удаляем упражнение из Core Data
        let context = viewModel.viewContext
        context.delete(exercise)
        
        do {
            try context.save()
        } catch {
            print("Error saving after deletion: \(error)")
        }
    }
    
    private func alertForExerciseManipulations() -> Alert {
        guard let alertType = alertType else {
            return Alert(
                title: Text("Error"),
                message: Text("Something went wrong."),
                dismissButton: .default(Text("OK"))
            )
        }

        switch alertType {
        case .delete(let exercise):
            return Alert(
                title: Text("Warning"),
                message: Text("This will remove the exercise from all workout days and reset your progress. Are you sure you want to delete it?"),
                primaryButton: .destructive(Text("Delete")) {
                    confirmDeletion(for: exercise)
                },
                secondaryButton: .cancel()
            )
        case .defaultExercise:
            return Alert(
                title: Text("Warning"),
                message: Text("You cannot delete the default exercise."),
                dismissButton: .default(Text("OK"))
            )
        case .alreadyAdded:
            return Alert(
                title: Text("Exercise Already Added"),
                message: Text("This exercise is already added to your workout day."),
                dismissButton: .default(Text("OK"))
            )
        case .resetDefaults:
                   return Alert(
                       title: Text("Reset Exercises"),
                       message: Text("All exercises will be reset to their original state. This action cannot be undone."),
                       primaryButton: .destructive(Text("Continue")) {
                           resetToDefaultExercises()
                       },
                       secondaryButton: .cancel()
                   )
        case .error:
            return Alert(
                title: Text("Error"),
                message: Text("Something went wrong."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
