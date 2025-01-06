//
//  EditExerciseView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.08.2024.
//

import SwiftUI
import CoreData
import PhotosUI

struct EditExerciseView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    var exercise: DefaultExercise // Передаём упражнение для редактирования
    @Environment(\.presentationMode) var presentationMode
    
    @State private var exerciseName: String
    @State private var selectedCategory: String?
    @State private var exerciseImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isImagePicked = false // Отслеживает, была ли выбрана картинка

    init(viewModel: WorkoutViewModel, exercise: DefaultExercise) {
        self.viewModel = viewModel
        self.exercise = exercise
        
        // Инициализация State с данными упражнения
        _exerciseName = State(initialValue: exercise.name ?? "")
        _selectedCategory = State(initialValue: exercise.categories?.name)
        
        if let imageData = exercise.image, let uiImage = UIImage(data: imageData) {
            _exerciseImage = State(initialValue: uiImage)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Exercise Details")) {
                    TextField("Exercise Name", text: $exerciseName)
                    
                    Picker("Exercise Category", selection: $selectedCategory) {
                        ForEach(allCategories, id: \.self) { category in
                            Text(category).tag(category as String?)
                        }
                    }
                    
                    Button("Select Image") {
                        isShowingImagePicker = true
                    }
                    
                    if let uiImage = exerciseImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
                
                Button(action: saveEditedExercise) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Edit Exercise")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePickerWithCrop(selectedImage: $exerciseImage, isImagePicked: $isImagePicked)
            }
        }
        .onAppear(perform: debugExerciseValues)
    }
    
    // MARK: - Methods
    
    private var allCategories: [String] {
        viewModel.allDefaultExercisesGroupedByCategory.map { $0.category }
    }
    
    private func saveEditedExercise() {
        guard let selectedCategory = selectedCategory, !exerciseName.isEmpty else {
            print("Exercise name or category is missing")
            return
        }
        
        exercise.name = exerciseName
        exercise.categories?.name = selectedCategory
        
        if let imageData = exerciseImage?.jpegData(compressionQuality: 1.0) {
            exercise.image = imageData
        }
        
        viewModel.saveContext()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func debugExerciseValues() {
        print("Debugging Exercise Values:")
        print("Name: \(exercise.name ?? "Unknown")")
        print("Category: \(exercise.categories?.name ?? "None")")
        if let imageData = exercise.image {
            print("Image: \(UIImage(data: imageData) != nil ? "Image exists" : "No image")")
        } else {
            print("Image: None")
        }
    }
}
