//
//  AddExerciseView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.08.2024.
//

import SwiftUI
import PhotosUI

struct AddExerciseView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var exerciseName = ""
    @State private var selectedGroup: String? = defaultExerciseGroups.first?.name
    @State private var exerciseImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var isCreatingNewGroup = false
    @State private var newGroupName = ""
    @State private var isImagePicked = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercise Details")) {
                    TextField("Exercise Name", text: $exerciseName)
                    
                    Picker("Exercise Category", selection: $selectedGroup) {
                        ForEach(allExerciseGroups.map(\.name), id: \.self) { group in
                            Text(group).tag(group as String?)
                        }
                    }
                    
                    Button("Add New Exercise Category") {
                        isCreatingNewGroup = true
                    }
                    
                    if isCreatingNewGroup {
                        TextField("New Category Name", text: $newGroupName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button("Done") {
                            if !newGroupName.isEmpty {
                                defaultExerciseGroups.append(
                                    ExerciseGroup(name: newGroupName, exercises: [])
                                )
                                selectedGroup = newGroupName
                                newGroupName = ""
                                isCreatingNewGroup = false
                            }
                        }
                        .padding()
                    }
                    
                    Button("Select Image") {
                        isShowingImagePicker = true
                    }
                    
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
                
                Button(action: addExercise) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $exerciseImage, isImagePicked: $isImagePicked)
            }
        }
    }
    
    private func addExercise() {
        guard let selectedGroup = selectedGroup, !exerciseName.isEmpty else {
            print("No group selected or name is empty")
            return
        }
        
        // Сохраняем упражнение в Core Data
        let newExercise = Exercise(context: viewModel.viewContext)
        newExercise.exerciseName = exerciseName
        newExercise.exerciseCategory = selectedGroup
        if let imageData = exerciseImage?.jpegData(compressionQuality: 1.0) {
            newExercise.exerciseImage = imageData
        } else {
            newExercise.exerciseImage = nil
        }
        newExercise.isDefault = false // Устанавливаем флаг для пользовательского упражнения
        
        viewModel.saveContext()
        
        // Добавляем упражнение в соответствующую категорию в defaultExerciseGroups
        if let groupIndex = defaultExerciseGroups.firstIndex(where: { $0.name == selectedGroup }) {
            let newExerciseItem = ExerciseItem(
                exerciseName: exerciseName,
                exerciseImage: exerciseImage,
                categoryName: selectedGroup
            )
            defaultExerciseGroups[groupIndex].exercises.append(newExerciseItem)
        }
        
        presentationMode.wrappedValue.dismiss()
    }

    
    private var allExerciseGroups: [ExerciseGroup] {
        defaultExerciseGroups
    }
}
