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
    @State private var exerciseImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    @State private var isCreatingNewCategory = false
    @State private var newCategoryName = ""
    @State private var isImagePicked = false
    @State private var isExerciseNameValid = true
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
                                .background(isExerciseNameValid ? (Color("ViewColor")) : Color.red.opacity(0.3))
                                .cornerRadius(15)
                                .padding(8)
                                .focused($isExerciseNameFocused)
                                .onChange(of: exerciseName) { _, _ in
                                    isExerciseNameValid = !exerciseName.isEmpty
                                }
                               
                            
                            Text(isExerciseNameValid ? "Enter Exercise Name" : "Exercise name is required")
                                .font(.system(size: 12))
                                .foregroundColor(isExerciseNameValid ? .gray : .red)
                                .padding(.leading, 16)
                                .padding(.bottom, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .background(Color("ViewColor").opacity(0.2))
                        .cornerRadius(8)
                        
                        
                        VStack {
                            
                            // Логика отображения текста под полем ввода
                            Text("Exercise Category")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            List {
                                ForEach(viewModel.allCategories, id: \.name) { category in
                                    HStack {
                                        Text(category.name ?? "Unknown Category")
                                            .font(.headline)
                                            .foregroundColor(selectedCategory == category ? .blue : .white)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal)
                                        
                                        Spacer()
                                        
                                        if selectedCategory == category {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.blue)
                                                .padding()
                                        }
                                    }
                                    .background(selectedCategory == category ? Color.blue.opacity(0.1) : Color.clear)
                                    .cornerRadius(15)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedCategory = category
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            viewModel.deleteCategory(category)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .listRowBackground(Color.clear) // Прозрачный фон для строки
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
                            .frame(minHeight: CGFloat(viewModel.allCategories.count) * 60)
                        }
                        
                        
                        VStack {
                            
                            Text("Create New Category")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack {
                                
                                
                                TextField("", text: $newCategoryName)
                                    .padding()
                                    .background(Color("ViewColor"))
                                    .cornerRadius(15)
                                    .padding(8)
                                Text("Enter Category Name")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
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
                                .background(Color("ButtonColor"))
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                                
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
                        
                        
                        Button(action: addNewExerciseToCoreData) {
                            Text("Create Exercise")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .padding(.horizontal, 40)
                                .background(Color("ButtonColor"))
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                    }
                    .padding()
                    .padding(.top, 20)
                    .onChange(of: isExerciseNameValid) { valid0, valid1 in
                        if !valid1 {
                            withAnimation {
                                proxy.scrollTo("anchor", anchor: .bottom) // Прокрутка до элемента с id
                                isExerciseNameFocused = true
                            }
                        }
                    }
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
        
        if !categoryExists() {
            viewModel.addNewCategory(newCategoryName)
            selectedCategory = viewModel.allCategories.last
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
        guard isValidExerciseInput() else {
            isExerciseNameValid = false
            return
        }
        
        let newExercise = createNewExercise()
        viewModel.allDefaultExercises.append(newExercise)
        viewModel.saveContext()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func isValidExerciseInput() -> Bool {
        return !(exerciseName.isEmpty || selectedCategory == nil)
    }
    
    private func createNewExercise() -> DefaultExercise {
        let newExercise = DefaultExercise(context: viewModel.viewContext)
        newExercise.name = exerciseName
        newExercise.categories = selectedCategory
        
        if let imageData = exerciseImage?.jpegData(compressionQuality: 1.0) {
            newExercise.image = imageData
        }
        
        newExercise.isDefault = false
        return newExercise
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(viewModel: WorkoutViewModel())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
