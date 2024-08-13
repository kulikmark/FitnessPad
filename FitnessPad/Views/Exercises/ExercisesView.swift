//
//  ExercisesView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 22.03.2022.
//

import SwiftUI
import CoreData

// MARK: - ExerciseItem Model
class ExerciseItem: Identifiable {
    var id = UUID()
    var exerciseName: String
    var exerciseImage: UIImage?
    var categoryName: String?

    init(exerciseName: String, exerciseImage: UIImage? = nil, categoryName: String? = nil) {
        self.exerciseName = exerciseName
        self.exerciseImage = exerciseImage
        self.categoryName = categoryName
    }

    // Convert UIImage to Data
    func toData() -> Data? {
        return exerciseImage?.jpegData(compressionQuality: 1.0)
    }

    func isDefault(in context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "exerciseName == %@ AND isDefault == YES", exerciseName)
        fetchRequest.fetchLimit = 1

        do {
            if let existingExercise = try context.fetch(fetchRequest).first {
                return existingExercise.isDefault
            }
        } catch {
            print("Error fetching exercise: \(error)")
        }
        return false
    }
}

// MARK: - ExerciseGroup Structure
struct ExerciseGroup: Identifiable {
    var id = UUID()
    var name: String
    var exercises: [ExerciseItem]
}

// MARK: - Default Exercise Items
let exerciseItems: [ExerciseItem] = [
    // MARK: - Add exercise items
    ExerciseItem(exerciseName: "Bicep Curls", exerciseImage: UIImage(named: "Bicep Curls")),
    ExerciseItem(exerciseName: "Bench Press", exerciseImage: UIImage(named: "Bench Press")),
    ExerciseItem(exerciseName: "Dumbbell Row", exerciseImage: UIImage(named: "Dumbbell Row")),
    ExerciseItem(exerciseName: "Hammer Curls", exerciseImage: UIImage(named: "Hammer Curls")),
    ExerciseItem(exerciseName: "Pike Push-Ups", exerciseImage: UIImage(named: "Pike Push-Ups")),
    ExerciseItem(exerciseName: "Pistol Squats", exerciseImage: UIImage(named: "Pistol Squats")),
    ExerciseItem(exerciseName: "Pull-Ups", exerciseImage: UIImage(named: "Pull-Ups")),
    ExerciseItem(exerciseName: "Push-Ups", exerciseImage: UIImage(named: "Push-Ups")),
    ExerciseItem(exerciseName: "Shoulder Press", exerciseImage: UIImage(named: "Shoulder Press")),
    ExerciseItem(exerciseName: "Squat", exerciseImage: UIImage(named: "Squat"))
]

// MARK: - Default Exercise Groups
var defaultExerciseGroups: [ExerciseGroup] = [
    // MARK: - Define exercise groups
    ExerciseGroup(name: "ABS", exercises: []),
    ExerciseGroup(name: "Arms", exercises: [
        ExerciseItem(exerciseName: "Bicep Curls", exerciseImage: UIImage(named: "Bicep Curls"), categoryName: "Arms"),
        ExerciseItem(exerciseName: "Hammer Curls", exerciseImage: UIImage(named: "Hammer Curls"), categoryName: "Arms")
    ]),
    ExerciseGroup(name: "Back", exercises: [
        ExerciseItem(exerciseName: "Dumbbell Row", exerciseImage: UIImage(named: "Dumbbell Row"), categoryName: "Back"),
        ExerciseItem(exerciseName: "Pull-Ups", exerciseImage: UIImage(named: "Pull-Ups"), categoryName: "Back")
    ]),
    ExerciseGroup(name: "Cardio", exercises: []),
    ExerciseGroup(name: "Chest", exercises: [
        ExerciseItem(exerciseName: "Bench Press", exerciseImage: UIImage(named: "Bench Press"), categoryName: "Chest"),
        ExerciseItem(exerciseName: "Push-Ups", exerciseImage: UIImage(named: "Push-Ups"), categoryName: "Chest")
    ]),
    ExerciseGroup(name: "Legs", exercises: [
        ExerciseItem(exerciseName: "Pistol Squats", exerciseImage: UIImage(named: "Pistol Squats"), categoryName: "Legs"),
        ExerciseItem(exerciseName: "Squat", exerciseImage: UIImage(named: "Squat"), categoryName: "Legs")
    ]),
    ExerciseGroup(name: "Shoulders", exercises: [
        ExerciseItem(exerciseName: "Pike Push-Ups", exerciseImage: UIImage(named: "Pike Push-Ups"), categoryName: "Shoulders"),
        ExerciseItem(exerciseName: "Shoulder Press", exerciseImage: UIImage(named: "Shoulder Press"), categoryName: "Shoulders")
    ])
]

// MARK: - ExercisesView
struct ExercisesView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Binding var workoutDay: WorkoutDay?
    @Binding var selectedExerciseItem: ExerciseItem?
    @Binding var isShowingExercisesView: Bool
    @State private var isPresentingAddExerciseView = false
    @State private var isPresentingEditExerciseView = false
    @State private var isEditing = false
    @State private var isShowingDeleteAlert = false
    @State private var itemToDelete: ExerciseItem?
    @State private var groupToDelete: ExerciseGroup?
    
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.exerciseName, ascending: true)]
    ) private var coreDataExercises: FetchedResults<Exercise>
    
    private var allExerciseGroups: [ExerciseGroup] {
        defaultExerciseGroups
    }
    
    private var hasUserExercisesOrCategories: Bool {
        !coreDataExercises.isEmpty || !defaultExerciseGroups.contains { $0.exercises.isEmpty }
    }
    
    let gridForm = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header
            exerciseGroups
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isPresentingAddExerciseView) {
            AddExerciseView(viewModel: viewModel)
        }
        .sheet(isPresented: $isPresentingEditExerciseView) {
            if let selectedExercise = selectedExerciseItem {
                let category = coreDataExercises.first(where: { $0.exerciseName == selectedExercise.exerciseName })?.exerciseCategory ?? ""
                EditExerciseView(viewModel: viewModel, exerciseItem: selectedExercise, originalCategory: category)
            }
        }
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(
                title: Text("are you sure??"),
                message: Text("This action will delete the selected item. All data associated with it will be lost."),
                primaryButton: .destructive(Text("Delete")) {
                    if let group = groupToDelete {
                        viewModel.deleteExercises(in: group.name)
                    } else if let item = itemToDelete {
                        deleteExercise(item)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    // MARK: - Header
    private var header: some View {
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
    
    // MARK: - Edit Button
    private var editButton: some View {
        Button {
            isEditing.toggle()
        } label: {
            Image(systemName: isEditing ? "checkmark" : "pencil")
                .font(.system(size: 30, weight: .regular))
                .foregroundColor(Color.black)
                .padding(15)
                .background(Circle().fill(Color("ButtonColor")))
                .clipShape(Circle())
                .padding()
                .opacity(hasUserExercisesOrCategories ? 1.0 : 0.3)
        }
        .disabled(!hasUserExercisesOrCategories)
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            isPresentingAddExerciseView = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 30, weight: .regular))
                .foregroundColor(Color.black)
                .padding(15)
                .background(Circle().fill(Color("ButtonColor")))
                .clipShape(Circle())
                .padding()
        }
    }
    
    // MARK: - Exercise Groups
    private var exerciseGroups: some View {
        ScrollView(showsIndicators: false) {
            ForEach(allExerciseGroups, id: \.name) { group in
                VStack(alignment: .leading, spacing: 15) {
                    groupHeader(for: group)
                    groupContent(for: group)
                }
            }
        }
        .padding(.bottom, 100)
    }
    
    // MARK: - Group Header
    private func groupHeader(for group: ExerciseGroup) -> some View {
        HStack {
            Text(group.name)
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundColor(Color("TextColor"))
                .padding(.leading, 20)
                .padding(.bottom, 10)
            
            if !defaultExerciseGroups.contains(where: { $0.name == group.name }) {
                deleteButton(for: group)
            }
        }
    }
    
    // MARK: - Delete Button for Group
    private func deleteButton(for group: ExerciseGroup) -> some View {
        Button(action: {
            groupToDelete = group
            isShowingDeleteAlert = true
        }) {
            VStack {
                Image(systemName: "trash")
                    .font(.system(size: 25))
                    .foregroundColor(.red)
                    .padding(.leading, 10)
                    .padding(.bottom, 10)
                Text("Delete category")
                    .foregroundColor(Color("TextColor"))
                    .font(.system(size: 12))
                    .padding(.bottom, 10)
            }
            .opacity(isEditing ? 1 : 0)
        }
    }
    
    // MARK: - Group Content
    private func groupContent(for group: ExerciseGroup) -> some View {
        let userExercises = coreDataExercises
            .filter { $0.exerciseCategory == group.name && !$0.isDefault }
            .map { exercise in
                ExerciseItem(
                    exerciseName: exercise.exerciseName ?? "",
                    exerciseImage: UIImage(data: exercise.exerciseImage ?? Data()),
                    categoryName: exercise.exerciseCategory
                )
            }
        
        let defaultExercises = group.exercises.filter { exerciseItem in
            !userExercises.contains { $0.exerciseName == exerciseItem.exerciseName }
        }

        return Group {
            if defaultExercises.isEmpty && userExercises.isEmpty {
                Text("No exercises available")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding(.leading, 20)
                    .padding(.bottom, 20)
            } else {
                LazyVGrid(columns: gridForm) {
                    ForEach(defaultExercises) { item in
                        exerciseButton(for: item, in: group)
                    }
                    ForEach(userExercises) { item in
                        exerciseButton(for: item, in: group)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    // MARK: - Exercise Button
    private func exerciseButton(for item: ExerciseItem, in group: ExerciseGroup) -> some View {
        ZStack(alignment: .topTrailing) {
            Button {
                if isEditing {
                    if !item.isDefault(in: viewModel.viewContext) {  // Check if the exercise is default
                        selectedExerciseItem = item
                        isPresentingEditExerciseView = true
                    } else {
                        print("Cannot edit default exercises")
                    }
                } else if workoutDay != nil {
                    addExerciseToWorkoutDay(with: item)
                }
            } label: {
                VStack {
                    exerciseImage(for: item)
                    Text(item.exerciseName)
                        .font(.system(size: 23))
                        .fontWeight(.medium)
                        .foregroundColor(Color("TextColor"))
                        .padding(.vertical, 10)
                }
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 10)
            }
            
            if !item.isDefault(in: viewModel.viewContext) {
                deleteExerciseButton(for: item, in: group)
            }
        }
        .disabled(workoutDay == nil && !isEditing)
    }

    // MARK: - Exercise Image
    private func exerciseImage(for item: ExerciseItem) -> some View {
        Group {
            if let image = item.exerciseImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 150, maxWidth: 200, minHeight: 150, maxHeight: 200)
                    .cornerRadius(15)
            } else {
                Image("defaultExerciseImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
    }
    
    // MARK: - Delete Exercise Button
    private func deleteExerciseButton(for item: ExerciseItem, in group: ExerciseGroup) -> some View {
        Button(action: {
            itemToDelete = item
            isShowingDeleteAlert = true
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
                .padding(10)
                .background(Color.white.opacity(0.7))
                .clipShape(Circle())
                .offset(x: -7, y: -10)
        }
        .opacity(isEditing && !item.isDefault(in: viewModel.viewContext) ? 1 : 0)
    }
    
    // MARK: - Delete Exercise
    private func deleteExercise(_ item: ExerciseItem) {
        if let exerciseToDelete = coreDataExercises.first(where: {
            $0.exerciseName == item.exerciseName &&
            $0.exerciseCategory == item.categoryName
        }) {
            if exerciseToDelete.isDefault {
                print("Cannot delete default exercise: \(item.exerciseName)")
            } else {
                viewModel.deleteExercise(exerciseToDelete)
            }
        }
    }
    
    // MARK: - Add Exercise to Workout Day
    private func addExerciseToWorkoutDay(with exerciseItem: ExerciseItem) {
        guard let workoutDay = workoutDay else {
            print("Error: workoutDay is nil")
            return
        }

        let existingExercises = workoutDay.exercisesArray
        let exerciseAlreadyExists = existingExercises.contains {
            $0.exerciseName == exerciseItem.exerciseName &&
            $0.exerciseCategory == exerciseItem.categoryName
        }

        if !exerciseAlreadyExists {
            let newExercise = Exercise(context: viewModel.viewContext)
            newExercise.exerciseName = exerciseItem.exerciseName
            newExercise.exerciseImage = exerciseItem.toData()
            newExercise.exerciseCategory = exerciseItem.categoryName
            newExercise.isDefault = false // User-defined exercise

            let newSet = ExerciseSet(context: viewModel.viewContext)
            newSet.count = 1
            newSet.weight = 0.0
            newSet.reps = 0
            newExercise.addToSets(newSet)

            workoutDay.addToExercises(newExercise)
            viewModel.saveContext()
        } else {
            print("Exercise already exists, not adding.")
        }

        isShowingExercisesView = false
    }
}

// MARK: - Previews
struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let workoutViewModel = WorkoutViewModel()
        let workoutDay = WorkoutDay(context: context)
        
        return ExercisesView(
            viewModel: workoutViewModel,
            workoutDay: .constant(workoutDay),
            selectedExerciseItem: .constant(nil),
            isShowingExercisesView: .constant(true)
        )
        .environment(\.managedObjectContext, context)
    }
}
