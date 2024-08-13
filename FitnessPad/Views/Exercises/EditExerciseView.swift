//
//  EditExerciseView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.08.2024.
//

import SwiftUI
import CoreData
import PhotosUI

//struct EditExerciseView: View {
//    @ObservedObject var viewModel: WorkoutViewModel
//    @Environment(\.presentationMode) var presentationMode
//    @State private var exerciseName: String
//    @State private var selectedGroup: String?
//    @State private var exerciseImage: UIImage?
//    @State private var isShowingImagePicker = false
//    @State private var isCreatingNewGroup = false
//    @State private var newGroupName = ""
//    @State private var isImagePicked = false
//
//    var exerciseItem: ExerciseItem
//    var originalCategory: String  // Новый параметр для хранения исходной категории
//
//    init(viewModel: WorkoutViewModel, exerciseItem: ExerciseItem, originalCategory: String) {
//        self.viewModel = viewModel
//        self.exerciseItem = exerciseItem
//        self.originalCategory = originalCategory
//        _exerciseName = State(initialValue: exerciseItem.exerciseName)
//        _exerciseImage = State(initialValue: exerciseItem.exerciseImage)
//        _selectedGroup = State(initialValue: originalCategory)
//    }
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Exercise Details")) {
//                    TextField("Exercise Name", text: $exerciseName)
//                    
//                    Picker("Exercise Category", selection: $selectedGroup) {
//                        ForEach(allExerciseGroups.map(\.name), id: \.self) { group in
//                            Text(group).tag(group as String?)
//                        }
//                    }
//                    
//                    Button("Add New Exercise Category") {
//                        isCreatingNewGroup = true
//                    }
//                    
//                    if isCreatingNewGroup {
//                        TextField("New Category Name", text: $newGroupName)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding()
//                        
//                        Button("Done") {
//                            if !newGroupName.isEmpty {
//                                defaultExerciseGroups.append(
//                                    ExerciseGroup(name: newGroupName, exercises: [])
//                                )
//                                selectedGroup = newGroupName
//                                newGroupName = ""
//                                isCreatingNewGroup = false
//                            }
//                        }
//                        .padding()
//                    }
//                    
//                    Button("Select Image") {
//                        isShowingImagePicker = true
//                    }
//                    
//                    if let uiImage = exerciseImage {
//                        Image(uiImage: uiImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 200)
//                    } else if !isImagePicked {
//                        Text("No image selected")
//                            .foregroundColor(.gray)
//                    }
//                }
//                
//                Button(action: updateExercise) {
//                    Text("Save Changes")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color("ButtonColor"))
//                        .cornerRadius(10)
//                }
//            }
//            .navigationTitle("Edit Exercise")
//            .navigationBarItems(trailing: Button("Cancel") {
//                presentationMode.wrappedValue.dismiss()
//            })
//            .sheet(isPresented: $isShowingImagePicker) {
//                ImagePicker(selectedImage: $exerciseImage, isImagePicked: $isImagePicked)
//            }
//        }
//    }
//    
//   
//    
//    private var allExerciseGroups: [ExerciseGroup] {
//        defaultExerciseGroups
//    }
//}
//
////
////#Preview {
////    EditExerciseView()
////}
//

struct EditExerciseView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var exerciseName: String
    @State private var selectedGroup: String?
    @State private var exerciseImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isCreatingNewGroup = false
    @State private var newGroupName = ""
    @State private var isImagePicked = false
    
    var exerciseItem: ExerciseItem
    var originalCategory: String
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.exerciseCategory, ascending: true)])
    private var coreDataExercises: FetchedResults<Exercise>

    init(viewModel: WorkoutViewModel, exerciseItem: ExerciseItem, originalCategory: String) {
        self.viewModel = viewModel
        self.exerciseItem = exerciseItem
        self.originalCategory = originalCategory
        _exerciseName = State(initialValue: exerciseItem.exerciseName)
        _exerciseImage = State(initialValue: exerciseItem.exerciseImage)
        _selectedGroup = State(initialValue: originalCategory)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercise Details")) {
                    TextField("Exercise Name", text: $exerciseName)
                        .disabled(exerciseItem.isDefault(in: viewModel.viewContext)) // Disable for default exercises
                    
                    Picker("Exercise Category", selection: $selectedGroup) {
                        ForEach(allExerciseGroups, id: \.self) { group in
                            Text(group).tag(group as String?)
                        }
                    }
                    .disabled(exerciseItem.isDefault(in: viewModel.viewContext)) // Disable for default exercises
                    
                    Button("Select Image") {
                        isShowingImagePicker = true
                    }
                    .disabled(exerciseItem.isDefault(in: viewModel.viewContext)) // Disable for default exercises
                    
                    if let uiImage = exerciseImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else if !isImagePicked {
                        Text("No image selected")
                            .foregroundColor(.gray)
                    }
                }
                
                if !exerciseItem.isDefault(in: viewModel.viewContext) {  // Hide Save button for default exercises
                    Button(action: saveChanges) {
                        Text("Save Changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("ButtonColor"))
                            .cornerRadius(10)
                    }
                } else {
                    Text("Cannot edit default exercises")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Edit Exercise")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $exerciseImage, isImagePicked: $isImagePicked)
            }
        }
    }

    
    private func addNewGroup(_ name: String) {
        // Add new category logic
        // ...
        selectedGroup = name
        newGroupName = ""
        isCreatingNewGroup = false
    }
    
    private var allExerciseGroups: [String] {
        // Return combined list of default and user-created groups
        let userGroups = Set(coreDataExercises.compactMap { $0.exerciseCategory })
        let defaultGroupNames = Set(defaultExerciseGroups.map(\.name))
        return Array(userGroups.union(defaultGroupNames)).sorted()
    }
    
    private func saveChanges() {
        guard !exerciseName.isEmpty, let selectedGroup = selectedGroup else {
            print("Exercise name is empty or category is not selected")
            return
        }

        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "exerciseName == %@ AND exerciseCategory == %@", exerciseItem.exerciseName, originalCategory)

        do {
            if let exerciseToUpdate = try viewModel.viewContext.fetch(fetchRequest).first {
                // Update the existing exercise instead of creating a new one
                exerciseToUpdate.exerciseName = exerciseName
                exerciseToUpdate.exerciseCategory = selectedGroup

                if let imageData = exerciseImage?.jpegData(compressionQuality: 1.0) {
                    exerciseToUpdate.exerciseImage = imageData
                }

                try viewModel.viewContext.save()
                print("Exercise updated successfully.")
                
                // Обновляем UI
                DispatchQueue.main.async {
                    // Если viewModel или другая часть вашего UI может обновиться, вызываем метод objectWillChange.send() для уведомления об изменениях
                    self.viewModel.objectWillChange.send()
                    // Также можно вручную перезагрузить данные, если это необходимо
                }
                
            }
        } catch {
            print("Error updating exercise: \(error.localizedDescription)")
        }

        presentationMode.wrappedValue.dismiss()
    }

}
