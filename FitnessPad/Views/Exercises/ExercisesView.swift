//
//  ExercisesView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI
import CoreData

//// MARK: - ExercisesView
//struct ExercisesView: View {
//    @ObservedObject var viewModel: WorkoutViewModel
//    @Binding var workoutDay: WorkoutDay?
//    @Binding var selectedExerciseItem: DeafaultExerciseItem?
//    @State private var allDefaultExercises: [DefaultExercise] = []
//    @Binding var isShowingExercisesView: Bool
//    @State private var isPresentingAddExerciseView = false
//    @State private var isPresentingEditExerciseView = false
//    @State private var isEditing = false
//    @State private var isShowingDeleteAlert = false
//    @State private var itemToDelete: DefaultExercise?
//    @State private var groupToDelete: ExerciseGroup?
//
//    @FetchRequest(
//        entity: Exercise.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.id, ascending: true)]
//    ) private var coreDataExercises: FetchedResults<Exercise>
//
//    @FetchRequest(
//        entity: DefaultExercise.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \DefaultExercise.exerciseName, ascending: true)]
//    ) private var defaultExercises: FetchedResults<DefaultExercise>
//
//    private var allExerciseGroups: [ExerciseGroup] {
//        defaultExerciseGroups
//    }
//
//    let gridForm = [GridItem(.flexible()), GridItem(.flexible())]
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            header
//            exerciseGroups
//        }
//        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
//        .sheet(isPresented: $isPresentingAddExerciseView) {
//            AddExerciseView(viewModel: viewModel)
//        }
////        .sheet(isPresented: $isPresentingEditExerciseView) {
////            if let selectedExercise = selectedExerciseItem {
////                let category = selectedExercise.exerciseCategory ?? ""
////                EditExerciseView(viewModel: viewModel, exerciseName: selectedExercise, originalCategory: category)
////            }
////        }
//        .alert(isPresented: $isShowingDeleteAlert) {
//            Alert(
//                title: Text("Are you sure?"),
//                message: Text("This action will delete the selected item. All data associated with it will be lost."),
//                primaryButton: .destructive(Text("Delete")) {
//                    if let group = groupToDelete {
//                        viewModel.deleteExercises(in: group.name)
//                    } else if let item = itemToDelete {
////                        deleteExercise(item)
//                    }
//                },
//                secondaryButton: .cancel()
//            )
//        }
//    }
//
//    // MARK: - Header
//    private var header: some View {
//        HStack {
//            Text("Exercises")
//                .font(.system(size: 43))
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
//    // MARK: - Edit Button
//    private var editButton: some View {
//        Button {
//            isEditing.toggle()
//        } label: {
//            Image(systemName: isEditing ? "checkmark" : "pencil")
//                .font(.system(size: 30, weight: .regular))
//                .foregroundColor(Color.black)
//                .padding(15)
//                .background(Circle().fill(Color("ButtonColor")))
//                .clipShape(Circle())
//                .padding()
////                .opacity(hasUserExercisesOrCategories ? 1.0 : 0.3)
//        }
////        .disabled(!hasUserExercisesOrCategories)
//    }
//
//    // MARK: - Add Button
//    private var addButton: some View {
//        Button {
//            isPresentingAddExerciseView = true
//        } label: {
//            Image(systemName: "plus")
//                .font(.system(size: 30, weight: .regular))
//                .foregroundColor(Color.black)
//                .padding(15)
//                .background(Circle().fill(Color("ButtonColor")))
//                .clipShape(Circle())
//                .padding()
//        }
//    }
//
//    // MARK: - Exercise Groups
//    private var exerciseGroups: some View {
//        ScrollView(showsIndicators: false) {
//            ForEach(allExerciseGroups, id: \ExerciseGroup.name) { group in
//                VStack(alignment: .leading, spacing: 15) {
//                    groupHeader(for: group)
////                    groupContent(for: group)
//                }
//            }
//        }
//        .padding(.bottom, 100)
//    }
//
//    // MARK: - Group Header
//    private func groupHeader(for group: ExerciseGroup) -> some View {
//        HStack {
//            Text(group.name)
//                .font(.system(size: 30))
//                .fontWeight(.bold)
//                .foregroundColor(Color("TextColor"))
//                .padding(.leading, 20)
//                .padding(.bottom, 10)
//
//            if !defaultExerciseGroups.contains(where: { $0.name == group.name }) {
//                deleteButton(for: group)
//            }
//        }
//    }
//
//    // MARK: - Delete Button for Group
//    private func deleteButton(for group: ExerciseGroup) -> some View {
//        Button(action: {
//            groupToDelete = group
//            isShowingDeleteAlert = true
//        }) {
//            VStack {
//                Image(systemName: "trash")
//                    .font(.system(size: 25))
//                    .foregroundColor(.red)
//                    .padding(.leading, 10)
//                    .padding(.bottom, 10)
//                Text("Delete category")
//                    .foregroundColor(Color("TextColor"))
//                    .font(.system(size: 12))
//                    .padding(.bottom, 10)
//            }
//            .opacity(isEditing ? 1 : 0)
//        }
//    }
//
//    // MARK: - Group Content
////    private func groupContent(for group: ExerciseGroup) -> some View {
////        let userExercises = coreDataExercises
////            .filter { $0.exerciseCategory == group.name }
////
////        let defaultExercisesInGroup = defaultExercises
////            .filter { $0.exerciseCategory == group.name }
////
////        return Group {
////            if defaultExercisesInGroup.isEmpty && userExercises.isEmpty {
////                Text("No exercises available")
////                    .font(.system(size: 20))
////                    .foregroundColor(.gray)
////                    .padding(.leading, 20)
////                    .padding(.bottom, 20)
////            } else {
////                LazyVGrid(columns: gridForm) {
////                    ForEach(defaultExercisesInGroup) { item in
////                        exerciseButton(for: item, in: group)
////                    }
////                    ForEach(userExercises) { item in
////                        userExerciseButton(for: item, in: group)
////                    }
////                }
////                .padding(.bottom, 20)
////            }
////        }
////    }
//
//    // MARK: - Exercise Button
//    private func exerciseButton(for item: DeafaultExerciseItem, in group: ExerciseGroup) -> some View {
//        ZStack(alignment: .topTrailing) {
//            Button {
//                if isEditing {
//                    selectedExerciseItem = item
//                    isPresentingEditExerciseView = true
//                } else if workoutDay != nil {
//                    addExerciseToWorkoutDay(for: item)
//                }
//            } label: {
//                VStack {
//                    exerciseImage(for: item)
//                    Text(item.exerciseName ?? "")
//                        .font(.system(size: 23))
//                        .fontWeight(.medium)
//                        .foregroundColor(Color("TextColor"))
//                        .padding(.vertical, 10)
//                }
//                .background(Color.white.opacity(0.1))
//                .cornerRadius(15)
//                .padding(.horizontal, 10)
//            }
//        }
//        .disabled(workoutDay == nil && !isEditing)
//    }
//
//    private func userExerciseButton(for item: DefaultExercise, in group: ExerciseGroup) -> some View {
//        ZStack(alignment: .topTrailing) {
//            Button {
//                if isEditing {
//                    selectedExerciseItem = nil
//                    isPresentingEditExerciseView = true
//                } else if workoutDay != nil {
//                    addExerciseToWorkoutDay(for: item)
//                }
//            } label: {
//                VStack {
//                    if let imageData = item.exerciseImage, let image = UIImage(data: imageData) {
//                        Image(uiImage: image)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(minWidth: 150, maxWidth: 200, minHeight: 150, maxHeight: 200)
//                            .cornerRadius(15)
//                    } else {
//                        Image("defaultExerciseImage")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 200, height: 200)
//                    }
//                }
//            }
//        }
//    }
//
//    func addExerciseToWorkoutDay(for exercise: DefaultExercise) {
//        guard let workoutDay = workoutDay else { return }
//        let context = viewModel.viewContext
//        let newExercise = Exercise(context: context)
//
//        newExercise.exerciseName = exercise.exerciseName
//        newExercise.exerciseCategory = exercise.exerciseCategory
//        newExercise.exerciseImage = exercise.exerciseImage
//        newExercise.workoutDay = workoutDay
//
//        do {
//            try context.save()
//            print("Exercise added successfully to the workout day.")
//        } catch {
//            print("Failed to add exercise: \(error.localizedDescription)")
//        }
//    }
//}

import SwiftUI
import CoreData

struct ExercisesView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @State  var isEditing = false
    @State  var selectedExerciseItem: DefaultExerciseItem?
    @State private var isShowingWorkoutDetailsView = false
    @State  var isPresentingEditExerciseView = false
    @Binding var workoutDay: WorkoutDay?
    
    @Environment(\.presentationMode) var presentationMode

    // Пример для сетки
    let gridForm = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            exerciseGroups
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
       
        .navigationBarBackButtonHidden(true)
        
        if isShowingWorkoutDetailsView {
            WorkoutDayDetailsView(viewModel: viewModel, workoutDay: $workoutDay)
        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                CustomBackButtonView()
//            }
//        }
        
    }

    // MARK: - Header
     var header: some View {
        HStack {
            
            Text("Exercises")
                .font(.system(size: 43))
                .fontWeight(.medium)
                .foregroundColor(Color("TextColor"))
                .padding(.top, 20)
                .padding(.leading, 20)
                .padding(.bottom, 20)

            Spacer()

            editButton
            addButton
        }
    }

    // MARK: - Exercise Groups
     var exerciseGroups: some View {
        ScrollView(showsIndicators: false) {
            ForEach(defaultExerciseGroups, id: \.name) { group in
                VStack(alignment: .leading, spacing: 15) {
                    groupHeader(for: group)
                    groupContent(for: group)
                }
            }
        }
        .padding(.bottom, 100)
    }

     func groupHeader(for group: ExerciseGroup) -> some View {
        HStack {
            Text(group.name)
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundColor(Color("TextColor"))
                .padding(.leading, 20)
                .padding(.bottom, 10)
        }
    }

     func groupContent(for group: ExerciseGroup) -> some View {
        LazyVGrid(columns: gridForm, spacing: 15) {
            ForEach(group.exercises, id: \.exerciseName) { item in
                exerciseButton(for: item)
            }
        }
        .padding(.horizontal, 20)
    }

     func exerciseButton(for item: DefaultExerciseItem) -> some View {
        Button {
                addExerciseToWorkoutDay(for: item)
            
            isShowingWorkoutDetailsView = true
        } label: {
            VStack {
                exerciseImage(for: item)
                Text(item.exerciseName)
                    .font(.system(size: 23))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextColor"))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: 400)
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
        }
    }

     func exerciseImage(for item: DefaultExerciseItem) -> some View {
        Image(uiImage: item.exerciseImage ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 150, maxWidth: 200, minHeight: 150, maxHeight: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Edit and Add Buttons
     var editButton: some View {
        Button(action: {
            isEditing.toggle()
        }) {
            Image(systemName: "pencil")
                .font(.system(size: 25))
                .foregroundColor(Color("TextColor"))
        }
        .padding(.trailing, 20)
    }

     var addButton: some View {
        Button(action: {
            // Логика для добавления нового упражнения
        }) {
            Image(systemName: "plus")
                .font(.system(size: 25))
                .foregroundColor(Color("TextColor"))
        }
        .padding(.trailing, 20)
    }

    // MARK: - Helper Functions
     func addExerciseToWorkoutDay(for item: DefaultExerciseItem) {

        let context = PersistenceController.shared.container.viewContext

        // Создаем новое упражнение для текущего дня тренировок
        let newExercise = Exercise(context: context)
        newExercise.name = item.exerciseName
        newExercise.image = item.exerciseImage?.jpegData(compressionQuality: 0.8) // Сохранение изображения
        newExercise.workoutDay = workoutDay

        do {
            // Сохраняем изменения в CoreData
            try context.save()
            print("Exercise \(item.exerciseName) successfully added to workout day.")
            
            // Закрытие экрана с упражнениями после успешного добавления
//                   presentationMode.wrappedValue.dismiss()
           
            
        } catch {
            print("Failed to save exercise: \(error.localizedDescription)")
        }
    }

}

// MARK: - Previews

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView(
            viewModel: WorkoutViewModel(), // Замените на реальный ViewModel или фейковые данные
            workoutDay: .constant(WorkoutDay(context: PersistenceController.shared.container.viewContext)) // Создаем фейковый WorkoutDay
        )
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
