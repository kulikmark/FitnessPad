//
//  EditExerciseView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.08.2024.
//

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
    @Environment(\.presentationMode) var presentationMode
    @State private var exerciseName: String
    @State private var selectedCategory: ExerciseCategory?
    @State private var selectedAttributes: Set<String> = []
    @State private var exerciseImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isExerciseNameValid = true
    @State private var isCategoryValid = true
    @State private var isAttributesValid = true
    @State private var isExerciseNameUnique = true
    @State private var isCategoryNameUnique = true
    
    private let attributes = ["Weight", "Reps", "Distance", "Time"]
    
    @FocusState private var isExerciseNameFocused: Bool
    private var exerciseToEdit: DefaultExercise
    
    init(viewModel: WorkoutViewModel, exercise: DefaultExercise) {
        self.viewModel = viewModel
        self.exerciseToEdit = exercise
        _exerciseName = State(initialValue: exercise.name ?? "")
        _selectedCategory = State(initialValue: exercise.categories)
        
        // Инициализация выбранных атрибутов
        _selectedAttributes = State(initialValue: Set(exercise.attributes?.allObjects.compactMap { ($0 as? ExerciseAttribute)?.name } ?? []))
        
        if let imageData = exercise.image, let uiImage = UIImage(data: imageData) {
            _exerciseImage = State(initialValue: uiImage)
        } else {
            _exerciseImage = State(initialValue: nil)
        }
    }

    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack (spacing: 40) {
                    Text("Edit Exercise")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .id("anchor")
                    
                    VStack {
                        TextField("", text: $exerciseName)
                            .padding()
                            .background(isExerciseNameValid && isExerciseNameUnique ? Color("ViewColor") : Color.red.opacity(0.3))
                            .cornerRadius(15)
                            .padding(8)
                            .focused($isExerciseNameFocused)
                            .onAppear {
                                exerciseName = exerciseToEdit.name ?? ""
                            }
                            .onChange(of: exerciseName) { _, _ in
                                isExerciseNameValid = !exerciseName.isEmpty
                                isExerciseNameUnique = isExerciseNameUniqueInCategory()
                            }
                        
                        Text(!isExerciseNameValid
                             ? "Exercise name is required"
                             : !isExerciseNameUnique
                             ? "Exercise with this name already exists. Please choose another name."
                             : "Enter Exercise Name")
                        .font(.system(size: 12))
                        .foregroundColor(isExerciseNameValid && isExerciseNameUnique ? .gray : .red)
                        .padding(.leading, 16)
                        .padding(.bottom, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color("ViewColor").opacity(0.2))
                    .cornerRadius(8)
                    
                    VStack {
                        Text(isCategoryValid ? "Exercise Category" : "Choose Exercise Category")
                            .font(.system(size: 18))
                            .foregroundColor(isCategoryValid ? .gray : .red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .id("anchor2")
                        
                        List {
                            ForEach(viewModel.allCategories, id: \.name) { category in
                                HStack {
                                    Text(category.name ?? "Unknown Category")
                                        .foregroundColor(selectedCategory == category ? .blue : Color("TextColor"))
//                                        .padding()
                                    Spacer()
                                    
                                    if selectedCategory == category {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                            .padding(.trailing, 10)
                                    }
                                }
                                .listRowBackground(Color.clear)
//                                .background(selectedCategory == category ? Color.blue.opacity(0.1) : Color.clear)
                                .cornerRadius(15)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedCategory = category
                                    isCategoryValid = true
                                }
                            }
                        }
                        .background(Color("ViewColor").opacity(0.2))
                        .cornerRadius(8)
                        .listStyle(PlainListStyle())
                        .scrollIndicators(.hidden)
                        .onAppear {
                            viewModel.loadCategories()
                        }
                        .frame(minHeight: CGFloat(viewModel.allCategories.count) * 45)
                    }
                    
                    VStack {
                        Text("Add Exercise Picture")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            if let uiImage = exerciseImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding()
                            } else if exerciseToEdit.image != nil {
                                Image(uiImage: UIImage(data: exerciseToEdit.image!)!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding()
                            } else {
                                Text("No image selected")
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding()
                            }
                            
                            Button(action: {
                                isShowingImagePicker = true
                            }) {
                                Text("Select Image")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding()
                                    .padding(.horizontal, 5)
                                    .background(Color("ButtonColor"))
                                    .cornerRadius(10)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            }
                        }
                        .background(Color("ViewColor").opacity(0.2))
                        .cornerRadius(8)
                    }
                    
                    VStack {
                        Text(isAttributesValid ? "Select Attributes for Exercise" : "Please select at least one attribute")
                            .font(.system(size: 18))
                            .foregroundColor(isAttributesValid ? .gray : .red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        List {
                            ForEach(attributes, id: \.self) { attribute in
                                HStack {
                                    Text(attribute)
                                        .foregroundColor(selectedAttributes.contains(attribute) ? .blue : Color("TextColor"))
                                      
                                    Spacer()
                                    if selectedAttributes.contains(attribute) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                            .padding(.trailing, 10)
                                    }
                                }
//                                .background(selectedAttributes.contains(attribute) ? Color.blue.opacity(0.1) : Color.clear)
                                .cornerRadius(15)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if selectedAttributes.contains(attribute) {
                                        selectedAttributes.remove(attribute)
                                    } else {
                                        selectedAttributes.insert(attribute)
                                        isAttributesValid = true
                                    }
                                }
                            }
                        }
                        .background(Color("ViewColor").opacity(0.2))
                        .cornerRadius(8)
                        .listStyle(PlainListStyle())
                        .scrollIndicators(.hidden)
                        .frame(minHeight: CGFloat(attributes.count) * 45)
                    }
                    
                    Button(action: {
                        saveExerciseChanges()
                        
                        viewModel.updateExerciseInWorkoutDays(exercise: exerciseToEdit)
                        
                        if !isExerciseNameValid && !isExerciseNameUnique {
                            withAnimation {
                                proxy.scrollTo("anchor", anchor: .bottom)
                                isExerciseNameFocused = true
                            }
                        } else if !isCategoryValid {
                            withAnimation {
                                proxy.scrollTo("anchor2", anchor: .bottom)
                            }
                        }
                    }) {
                        Text("Save Changes")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal, 40)
                            .background(Color("ButtonColor"))
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                    .disabled(!isExerciseNameValid || !isExerciseNameUnique || selectedCategory == nil || selectedAttributes.isEmpty)
                }
                .padding()
                .padding(.top, 20)
            }
            .scrollIndicators(.hidden)
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePickerWithCrop(selectedImage: $exerciseImage, isImagePicked: .constant(true))
        }
    }
    
    private func saveExerciseChanges() {
        exerciseName = exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard isValidExerciseInput() else {
            if exerciseName.isEmpty {
                isExerciseNameValid = false
            }
            if selectedCategory == nil {
                isCategoryValid = false
            }
            if selectedAttributes.isEmpty {
                isAttributesValid = false
            }
            return
        }
        
        // Обновляем данные упражнения
        exerciseToEdit.name = exerciseName
        exerciseToEdit.categories = selectedCategory
        if let imageData = exerciseImage?.jpegData(compressionQuality: 1.0) {
            exerciseToEdit.image = imageData
        }
        
        updateAttributesForExercise()
        
        // Обновляем все упражнения в тренировочных днях
        viewModel.updateExerciseInWorkoutDays(exercise: exerciseToEdit)
        
        viewModel.saveContext()
        presentationMode.wrappedValue.dismiss()
    }

    
    private func updateAttributesForExercise() {
        let currentAttributes = exerciseToEdit.attributes?.allObjects as? [ExerciseAttribute] ?? []
        
        // Remove attributes not selected anymore
        for attribute in currentAttributes {
            if !selectedAttributes.contains(attribute.name ?? "") {
                viewModel.viewContext.delete(attribute)
            }
        }
        
        // Add new attributes
        for attribute in selectedAttributes {
            if !currentAttributes.contains(where: { $0.name == attribute }) {
                let newAttribute = ExerciseAttribute(context: viewModel.viewContext)
                newAttribute.name = attribute
                newAttribute.isAdded = true
                exerciseToEdit.addToAttributes(newAttribute)
            }
        }
    }
    
    private func isValidExerciseInput() -> Bool {
        return !(exerciseName.isEmpty || selectedCategory == nil || selectedAttributes.isEmpty || !isExerciseNameUnique)
    }
    
    private func isExerciseNameUniqueInCategory() -> Bool {
        let trimmedName = exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
        return !viewModel.allDefaultExercises.contains { $0.name == trimmedName && $0.id != exerciseToEdit.id }
    }
}
