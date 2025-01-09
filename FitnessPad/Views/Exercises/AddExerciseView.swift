//
//  AddExerciseView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.08.2024.
//

import SwiftUI
import CoreData
import PhotosUI

struct AddExerciseView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var exerciseName = ""
    @State private var selectedCategory: ExerciseCategory? = nil
    @State private var selectedAttributes: Set<String> = []
    @State private var exerciseImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var isCreatingNewCategory = false
    @State private var newCategoryName = ""
    @State private var isImagePicked = false
    @State private var isExerciseNameValid = true
    @State private var isCategoryValid = true
    @State private var isAttributesValid = true
    @State private var isExerciseNameUnique = true
    @State private var isCategoryNameUnique = true
    
    private let attributes = ["Weight", "Reps", "Distance", "Time"]
    
    @FocusState private var isExerciseNameFocused: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack (spacing: 40) {
                    
                    Text("Add New Exercise")
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
                            .onChange(of: exerciseName) { _, _ in
                                isExerciseNameValid = !exerciseName.isEmpty
                                isExerciseNameUnique = isExerciseNameUniqueInCategory() // Проверка уникальности
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
                                .swipeActions {
                                    Button(role: .destructive) {
                                        viewModel.deleteCategory(category)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                               
                            }
                            .onDelete { indexSet in
                                if let index = indexSet.first {
                                    let categoryToDelete = viewModel.allCategories[index]
                                    viewModel.deleteCategory(categoryToDelete)
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
                        Text("Create New Category")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            TextField("", text: $newCategoryName)
                                .padding()
                                .background(isCategoryNameUnique ? Color("ViewColor") : Color.red.opacity(0.3))
                                .cornerRadius(15)
                                .padding(8)
                                .onChange(of: newCategoryName) { _, _ in
                                    isCategoryNameUnique = isCategoryNameUniqueInCategories()
                                }
                            
                            
                            Text(isCategoryNameUnique
                                 ? "Enter Category Name" : "Category with this name already exists. Please choose another name.")
                            .font(.system(size: 12))
                            .foregroundColor(isCategoryNameUnique ? .gray : .red)
                            .padding(.leading, 16)
                            .padding(.bottom, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button("Done") {
                                addNewCategory()
                            }
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal, 10)
                            .background(isCategoryNameUnique ? Color("ButtonColor") : Color.gray)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .disabled(!isCategoryNameUnique)
                        }
                        .background(Color("ViewColor").opacity(0.2))
                        .cornerRadius(8)
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
                            } else if !isImagePicked {
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
                    
                    
                    // Выбор атрибутов сета
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
                                    
                                    .listRowBackground(Color.clear)
//                                    .background(selectedAttributes.contains(attribute) ? Color.blue.opacity(0.1) : Color.clear)
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
                        addNewExerciseToCoreData()
                        
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
                        Text(!newCategoryName.isEmpty ? "Please finish creating Category." : "Create Exercise")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal, 40)
                            .background(newCategoryName.isEmpty ? Color("ButtonColor") : Color.gray)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                    
                    .disabled(!newCategoryName.isEmpty)
                }
                .padding()
                .padding(.top, 20)
            }
            .scrollIndicators(.hidden)
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePickerWithCrop(selectedImage: $exerciseImage, isImagePicked: $isImagePicked)
        }
    }
    
    private func addNewCategory() {
        guard !newCategoryName.isEmpty else { return }
        
        isCategoryNameUnique = isCategoryNameUniqueInCategories()
        guard isCategoryNameUnique else { return }
        
        if !categoryExists() {
            viewModel.addNewCategory(newCategoryName)
            selectedCategory = viewModel.allCategories.last
            isCategoryValid = true
        }
        
        resetCategoryCreationState()
    }
    
    
    private func categoryExists() -> Bool {
        return viewModel.allCategories.contains(where: { $0.name == newCategoryName })
    }
    
    private func resetCategoryCreationState() {
        newCategoryName = ""
        isCreatingNewCategory = false
    }
    
    private func addNewExerciseToCoreData() {
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
        
        // Print selected attributes
            print("Selected attributes: \(selectedAttributes)")
        
        let newExercise = createNewExercise()
        viewModel.allDefaultExercises.append(newExercise)
        viewModel.saveContext()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func isValidExerciseInput() -> Bool {
        isExerciseNameUnique = isExerciseNameUniqueInCategory()
        return !(exerciseName.isEmpty || selectedCategory == nil || !isExerciseNameUnique || selectedAttributes.isEmpty)
    }
    
    private func isExerciseNameUniqueInCategory() -> Bool {
        let trimmedName = exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
        return !viewModel.allDefaultExercises.contains(where: {
            $0.name?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == trimmedName.lowercased()
        })
    }
    private func isCategoryNameUniqueInCategories() -> Bool {
        return !viewModel.allCategories.contains(where: { $0.name?.lowercased() == newCategoryName.lowercased() })
    }
    
    // Метод создания нового упражнения
    private func createNewExercise() -> DefaultExercise {
        let newExercise = DefaultExercise(context: viewModel.viewContext)
        newExercise.id = UUID()
        newExercise.name = exerciseName
        newExercise.categories = selectedCategory
        
        if let imageData = exerciseImage?.jpegData(compressionQuality: 1.0) {
            newExercise.image = imageData
        }
        
        newExercise.isDefault = false
        
        // Создаем атрибуты для упражнения
        var attributes: [ExerciseAttribute] = []
        
        if selectedAttributes.contains("Weight") {
            let weightAttribute = ExerciseAttribute(context: viewModel.viewContext)
            weightAttribute.name = "Weight"
            weightAttribute.isAdded = true
            attributes.append(weightAttribute)
        }
        
        if selectedAttributes.contains("Reps") {
            let repsAttribute = ExerciseAttribute(context: viewModel.viewContext)
            repsAttribute.name = "Reps"
            repsAttribute.isAdded = true
            attributes.append(repsAttribute)
        }
        
        if selectedAttributes.contains("Time") {
            let timeAttribute = ExerciseAttribute(context: viewModel.viewContext)
            timeAttribute.name = "Time"
            timeAttribute.isAdded = true
            attributes.append(timeAttribute)
        }
        
        if selectedAttributes.contains("Distance") {
            let distanceAttribute = ExerciseAttribute(context: viewModel.viewContext)
            distanceAttribute.name = "Distance"
            distanceAttribute.isAdded = true
            attributes.append(distanceAttribute)
        }
        
        // Связываем атрибуты с упражнением
        newExercise.attributes = NSSet(array: attributes)
        
        print(newExercise)

        return newExercise
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(viewModel: WorkoutViewModel())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
