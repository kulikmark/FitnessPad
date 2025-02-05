//
//  ExerciseFormView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 17.01.2025.
//
//
//import SwiftUI
//import CoreData
//import PhotosUI
//
//struct ExerciseFormView: View {
//    @ObservedObject var exerciseViewModel: ExerciseViewModel
//    @Environment(\.presentationMode) var presentationMode
//    
//    var exerciseToEdit: DefaultExercise?
//    
//    @State private var exerciseName = ""
//    @State private var selectedCategory: ExerciseCategory?
//    @State private var selectedAttributes: Set<String> = []
//    @State private var exerciseImage: UIImage?
//    @State private var isShowingImagePicker = false
//    @State private var isExerciseNameValid = true
//    @State private var isCategoryValid = true
//    @State private var isAttributesValid = true
//    @State private var isExerciseNameUnique = true
//    @State private var isCategoryNameUnique = true
//    @State private var isAddingNewCategory = false
//    @State private var newCategoryName = ""
//    @State private var showPermissionAlert = false
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//    @State private var showAttributeLimitAlert = false
//    @State private var errorMessage: String?
//    
//    @FocusState private var isExerciseNameFocused: Bool
//    @FocusState private var isCategoryNameFocused: Bool
//    
//    private let attributes = ["Weight", "Reps", "Distance", "Time"]
//    
//    // Идентификаторы для прокрутки
//    private let exerciseNameFieldID = "exerciseNameField"
//    private let categoryNameFieldID = "categoryNameField"
//    
//    // Инициализатор для редактирования упражнения
//       init(exerciseViewModel: ExerciseViewModel, exerciseToEdit: DefaultExercise? = nil) {
//           self.exerciseViewModel = exerciseViewModel
//           self.exerciseToEdit = exerciseToEdit
//           
//           // Заполняем начальные значения, если редактируем упражнение
//           if let exercise = exerciseToEdit {
//               _exerciseName = State(initialValue: exercise.name ?? "")
//               _selectedCategory = State(initialValue: exercise.categories)
//               
//               if let imageData = exercise.image {
//                   _exerciseImage = State(initialValue: UIImage(data: imageData))
//               }
//               
//               // Извлекаем атрибуты из ExerciseAttribute
//                      if let attributes = exercise.attributes as? Set<ExerciseAttribute> {
//                          // Преобразуем атрибуты в Set<String>
//                          let attributeNames = attributes.filter { $0.isAdded }.compactMap { $0.name }
//                          _selectedAttributes = State(initialValue: Set(attributeNames))
//                      } else {
//                          _selectedAttributes = State(initialValue: [])
//                      }
//                  }
//              }
//    
//    var body: some View {
//        ZStack {
//            // Фоновый цвет
//            Color("BackgroundColor")
//                .edgesIgnoringSafeArea(.all)
//            
//            ScrollViewReader { proxy in
//                ScrollView {
//                    VStack(spacing: 40) {
//                        // MARK: - Title
//                        Text(exerciseToEdit == nil ? "Add New Exercise" : "Edit Exercise")
//                            .font(.system(size: 24))
//                            .foregroundColor(.gray)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                        
//                        // MARK: - Exercise Name
//                        CustomTextField(
//                            placeholder: "Enter Exercise Name",
//                            text: $exerciseName,
//                            isValid: isExerciseNameUnique,
//                            errorMessage: !isExerciseNameUnique
//                            ? "Exercise with this name already exists. Please choose another name."
//                            : "Enter Exercise Name"
//                        )
//                        .id(exerciseNameFieldID) // Уникальный идентификатор для прокрутки
//                        .focused($isExerciseNameFocused) // Отслеживаем фокус
//                        .onChange(of: isExerciseNameFocused) { _, isFocused in
//                            if isFocused {
//                                // Прокручиваем к текстовому полю при фокусе
//                                withAnimation {
//                                    proxy.scrollTo(exerciseNameFieldID, anchor: .center)
//                                }
//                            }
//                        }
//                        .onChange(of: exerciseName) { _, newValue in
//                            isExerciseNameUnique = isExerciseNameUniqueInCategory()
//                        }
//                        
//                        // MARK: - Category List Selection
//                        VStack {
//                            Text(isCategoryValid ? "Exercise Category" : "Choose Exercise Category")
//                                .font(.system(size: 18))
//                                .foregroundColor(isCategoryValid ? .gray : .red)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            
//                            List {
//                                Section {
//                                    ForEach(exerciseViewModel.allCategories, id: \.name) { category in
//                                        HStack {
//                                            Text(category.name ?? "Unknown Category")
//                                                .foregroundColor(selectedCategory == category ? .blue : Color("TextColor"))
//                                                .font(.system(size: 18))
//                                                .padding(.leading, 10)
//                                            Spacer()
//                                            
//                                            if selectedCategory == category {
//                                                Image(systemName: "checkmark.circle.fill")
//                                                    .foregroundColor(.blue)
//                                                    .padding(.trailing, 10)
//                                            }
//                                        }
//                                        .listRowSeparator(.hidden)
//                                        .listRowBackground(Color.clear)
//                                        .contentShape(Rectangle())
//                                        .onTapGesture {
//                                            selectedCategory = category
//                                            isCategoryValid = true
//                                        }
//                                        .swipeActions {
//                                            if category.isDefault != true {
//                                                Button(role: .destructive) {
//                                                    exerciseViewModel.deleteCategory(category)
//                                                    
//                                                    if selectedCategory == category {
//                                                        selectedCategory = exerciseViewModel.allCategories.first
//                                                    }
//                                                } label: {
//                                                    Label("Delete", systemImage: "trash")
//                                                }
//                                            } else {
//                                                Button {
//                                                    showAlert = true
//                                                } label: {
//                                                    Label("Cannot Delete", systemImage: "lock.fill")
//                                                }
//                                                .tint(.gray)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            .listStyle(PlainListStyle())
//                            .background(Color("ViewColor").opacity(0.2))
//                            .cornerRadius(8)
//                            .frame(minHeight: CGFloat(exerciseViewModel.allCategories.count) * 45)
//                            .onAppear {
//                                exerciseViewModel.loadCategories()
//                            }
//                            
//                            // Кнопка "Add New Category"
//                            Button(action: {
//                                isAddingNewCategory = true
//                            }) {
//                                Text("+ Add New Category")
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .padding(.horizontal, 5)
//                                    .background(Color("ButtonColor"))
//                                    .cornerRadius(10)
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                                    .padding()
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            .contentShape(Rectangle())
//                        }
//                        .alert(isPresented: $showAlert) {
//                            Alert(
//                                title: Text("Cannot Delete Category"),
//                                message: Text("Default categories cannot be deleted."),
//                                dismissButton: .default(Text("OK"))
//                            )
//                        }
//                        
//                        // MARK: - Create New Category
//                        if isAddingNewCategory {
//                            VStack {
//                                Text("Create New Category")
//                                    .font(.system(size: 18))
//                                    .foregroundColor(.gray)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                
//                                VStack {
//                                    CustomTextField(
//                                        placeholder: "Enter Category Name",
//                                        text: $newCategoryName,
//                                        isValid: isCategoryNameUnique,
//                                        errorMessage: isCategoryNameUnique
//                                        ? "Enter Category Name"
//                                        : "Category with this name already exists. Please choose another name."
//                                    )
//                                    .id(categoryNameFieldID) // Уникальный идентификатор для прокрутки
//                                    .focused($isCategoryNameFocused) // Отслеживаем фокус
//                                    .onChange(of: isCategoryNameFocused) { _, isFocused in
//                                        if isFocused {
//                                            // Прокручиваем к текстовому полю при фокусе
//                                            withAnimation {
//                                                proxy.scrollTo(categoryNameFieldID, anchor: .center)
//                                            }
//                                        }
//                                    }
//                                    .onChange(of: newCategoryName) { _, newValue in
//                                        isCategoryNameUnique = isCategoryNameUniqueInCategories()
//                                    }
//                                    
//                                    CustomButton(
//                                        title: "Done",
//                                        isEnabled: isCategoryNameUnique,
//                                        action: {
//                                            addNewCategory()
////                                            isAddingNewCategory.toggle()
//                                            isAddingNewCategory = false
//                                        }
//                                    )
//                                }
//                                .background(Color("ViewColor").opacity(0.2))
//                                .cornerRadius(8)
//                            }
//                        }
//                        
//                        // MARK: - Add Exercise Picture
//                        VStack {
//                            Text("Add Exercise Picture")
//                                .font(.system(size: 18))
//                                .foregroundColor(.gray)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            
//                            VStack {
//                                if let uiImage = exerciseImage {
//                                    Image(uiImage: uiImage)
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                        .padding()
//                                } else {
//                                    Text("No image selected")
//                                        .foregroundColor(.gray)
//                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                        .padding()
//                                }
//                                
//                                Button(action: {
//                                    PHPhotoLibrary.checkPermission { granted, status in
//                                        if granted {
//                                            isShowingImagePicker = true
//                                        } else {
//                                            switch status {
//                                            case .denied:
//                                                alertMessage = "Photo access is denied. Please allow access in Settings."
//                                            case .restricted:
//                                                alertMessage = "Photo access is restricted by system settings."
//                                            case .limited:
//                                                alertMessage = "Photo access is limited. Please allow full access in Settings."
//                                            default:
//                                                alertMessage = "Unable to access the photo library."
//                                            }
//                                            showPermissionAlert = true
//                                        }
//                                    }
//                                }) {
//                                    Text("Select Image")
//                                        .font(.system(size: 14))
//                                        .foregroundColor(.white)
//                                        .padding()
//                                        .padding(.horizontal, 5)
//                                        .background(Color("ButtonColor"))
//                                        .cornerRadius(10)
//                                        .frame(maxWidth: .infinity, alignment: .center)
//                                        .padding()
//                                }
//                                .buttonStyle(PlainButtonStyle())
//                                .contentShape(Rectangle())
//                                .alert(isPresented: $showPermissionAlert) {
//                                    Alert(
//                                        title: Text("Access Error"),
//                                        message: Text(alertMessage),
//                                        primaryButton: .default(Text("Open Settings")) {
//                                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
//                                                UIApplication.shared.open(appSettings)
//                                            }
//                                        },
//                                        secondaryButton: .cancel(Text("Cancel"))
//                                    )
//                                }
//                            }
//                            .background(Color("ViewColor").opacity(0.2))
//                            .cornerRadius(8)
//                        }
//                        
//                        // MARK: - Select Attributes
//                        VStack {
//                            Text(isAttributesValid ? "Select Attributes for Exercise" : "Please select at least one attribute")
//                                .font(.system(size: 18))
//                                .foregroundColor(isAttributesValid ? .gray : .red)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                            
//                            List {
//                                Section {
//                                    ForEach(attributes, id: \.self) { attribute in
//                                        HStack {
//                                            Text(attribute)
//                                                .foregroundColor(selectedAttributes.contains(attribute) ? .blue : Color("TextColor"))
//                                                .font(.system(size: 18))
//                                                .padding(.leading, 10)
//                                            Spacer()
//                                            if selectedAttributes.contains(attribute) {
//                                                Image(systemName: "checkmark.circle.fill")
//                                                    .foregroundColor(.blue)
//                                                    .padding(.trailing, 10)
//                                            }
//                                        }
//                                        .listRowSeparator(.hidden)
//                                        .listRowBackground(Color.clear)
//                                        .contentShape(Rectangle())
//                                        .onTapGesture {
//                                            if selectedAttributes.contains(attribute) {
//                                                selectedAttributes.remove(attribute)
//                                            } else {
//                                                if selectedAttributes.count < 2 {
//                                                    selectedAttributes.insert(attribute)
//                                                    isAttributesValid = true
//                                                } else {
//                                                    showAttributeLimitAlert = true
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            .background(Color("ViewColor").opacity(0.2))
//                            .cornerRadius(8)
//                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                            .listRowBackground(Color.clear)
//                            .listRowSeparator(.hidden)
//                            .listStyle(PlainListStyle())
//                            .scrollIndicators(.hidden)
//                            .frame(minHeight: CGFloat(attributes.count) * 45)
//                        }
//                        .alert(isPresented: $showAttributeLimitAlert) {
//                            Alert(
//                                title: Text("Limit Reached"),
//                                message: Text("You can select a maximum of 2 attributes."),
//                                dismissButton: .default(Text("OK"))
//                            )
//                        }
//                        
//                        // MARK: - Submit Button
//                        VStack {
//                            CustomButton(
//                                title: exerciseToEdit == nil ? "Create Exercise" : "Save Changes",
//                                isEnabled: isValidExerciseInput(),
//                                action: {
//                                    if exerciseToEdit == nil {
//                                        addExercise()
//                                    } else {
//                                        saveExerciseChanges()
//                                    }
//                                }
//                            )
//                            
//                            if let errorMessage = errorMessage {
//                                Text(errorMessage)
//                                    .font(.system(size: 14))
//                                    .foregroundColor(.red)
//                                    .frame(maxWidth: .infinity)
//                            }
//                        }
//                    }
//                    .padding()
//                    .padding(.top, 20)
//                    .padding(.bottom, 20)
//                }
////                .scrollDismissesKeyboard(.interactively) // Скрываем клавиатуру при прокрутке
//            }
//        }
//        .simultaneousGesture(TapGesture().onEnded {
//            UIApplication.shared.endEditing(true)
//        })
//        .sheet(isPresented: $isShowingImagePicker) {
//            ImagePickerWithCrop(selectedImage: $exerciseImage, isImagePicked: .constant(true))
//        }
//        .onAppear {
//            updateErrorMessage()
//        }
//        .onChange(of: exerciseName) {
//            updateErrorMessage()
//        }
//        .onChange(of: selectedCategory) {
//            updateErrorMessage()
//        }
//        .onChange(of: selectedAttributes) {
//            updateErrorMessage()
//        }
//        .onChange(of: isExerciseNameUnique) {
//            updateErrorMessage()
//        }
//    }
//    
//    // MARK: - Helper Functions
//    
//    private func addExercise() {
//        guard isValidExerciseInput() else {
//            handleInvalidExerciseInput()
//            return
//        }
//        
//        exerciseViewModel.addExerciseToCoreData(
//            name: exerciseName,
//            category: selectedCategory,
//            image: exerciseImage,
//            attributes: selectedAttributes
//        )
//        
//        presentationMode.wrappedValue.dismiss()
//    }
//    
//    private func saveExerciseChanges() {
//        guard let exercise = exerciseToEdit else { return }
//        
//        guard isValidExerciseInput() else {
//            handleInvalidExerciseInput()
//            return
//        }
//        
//        exerciseViewModel.updateExerciseInCoreData(
//            exercise: exercise,
//            name: exerciseName,
//            category: selectedCategory,
//            image: exerciseImage,
//            attributes: selectedAttributes
//        )
//        
//        presentationMode.wrappedValue.dismiss()
//    }
//    
//    private func isValidExerciseInput() -> Bool {
//        return !exerciseName.isEmpty && selectedCategory != nil && !selectedAttributes.isEmpty && isExerciseNameUnique
//    }
//    
//    private func handleInvalidExerciseInput() {
//        updateErrorMessage()
//    }
//    
//    private func updateErrorMessage() {
//        if exerciseName.isEmpty {
//            errorMessage = "Enter exercise name"
//        } else if selectedCategory == nil {
//            errorMessage = "Choose exercise category"
//        } else if selectedAttributes.isEmpty {
//            errorMessage = "Select at least one attribute"
//        } else if !isExerciseNameUnique {
//            errorMessage = "Exercise with this name already exists. Please choose another name."
//        } else {
//            errorMessage = nil
//        }
//    }
//    
//    private func isExerciseNameUniqueInCategory() -> Bool {
//        let trimmedName = exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
//        return !exerciseViewModel.allDefaultExercises.contains { $0.name == trimmedName && $0.id != exerciseToEdit?.id }
//    }
//    
//    private func addNewCategory() {
//        guard !newCategoryName.isEmpty, !categoryExists() else { return }
//        
//        exerciseViewModel.addCategory(newCategoryName)
//        selectedCategory = exerciseViewModel.allCategories.last
//        isCategoryValid = true
//        resetCategoryCreationState()
//    }
//    
//    private func isCategoryNameUniqueInCategories() -> Bool {
//        return !exerciseViewModel.allCategories.contains { $0.name?.lowercased() == newCategoryName.lowercased() }
//    }
//    
//    private func categoryExists() -> Bool {
//        return exerciseViewModel.allCategories.contains { $0.name == newCategoryName }
//    }
//    
//    private func resetCategoryCreationState() {
//        newCategoryName = ""
//        isAddingNewCategory = false
//    }
//}


//
//  ExerciseFormView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 17.01.2025.
//

import SwiftUI
import CoreData
import PhotosUI

struct ExerciseFormView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var exerciseName = ""
    @State private var selectedCategory: ExerciseCategory?
    @State private var selectedAttributes: Set<String> = []
    @State private var exerciseImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isExerciseNameValid = true
    @State private var isCategoryValid = true
    @State private var isAttributesValid = true
    @State private var isExerciseNameUnique = true
    @State private var isCategoryNameUnique = true
    @State private var isAddingNewCategory = false
    @State private var newCategoryName = ""
    @State private var showPermissionAlert = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showAttributeLimitAlert = false
    @State private var errorMessage: String?
    
    @FocusState private var isExerciseNameFocused: Bool
    @FocusState private var isCategoryNameFocused: Bool
    
    private let attributes = ["Weight", "Reps", "Distance", "Time"]
    
    // Идентификаторы для прокрутки
    private let exerciseNameFieldID = "exerciseNameField"
    private let categoryNameFieldID = "categoryNameField"
    
    var body: some View {
        ZStack {
            // Фоновый цвет
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 40) {
                        // MARK: - Title
                        Text("Add New Exercise")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // MARK: - Exercise Name
                        CustomTextField(
                            placeholder: "Enter Exercise Name",
                            text: $exerciseName,
                            isValid: isExerciseNameUnique,
                            errorMessage: !isExerciseNameUnique
                            ? "Exercise with this name already exists. Please choose another name."
                            : "Enter Exercise Name"
                        )
                        .id(exerciseNameFieldID) // Уникальный идентификатор для прокрутки
                        .focused($isExerciseNameFocused) // Отслеживаем фокус
                        .onChange(of: isExerciseNameFocused) { _, isFocused in
                            if isFocused {
                                // Прокручиваем к текстовому полю при фокусе
                                withAnimation {
                                    proxy.scrollTo(exerciseNameFieldID, anchor: .center)
                                }
                            }
                        }
                        .onChange(of: exerciseName) { _, newValue in
                            isExerciseNameUnique = isExerciseNameUniqueInCategory()
                        }
                        
                        // MARK: - Category List Selection
                        VStack {
                            Text(isCategoryValid ? "Exercise Category" : "Choose Exercise Category")
                                .font(.system(size: 18))
                                .foregroundColor(isCategoryValid ? .gray : .red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            List {
                                Section {
                                    ForEach(exerciseViewModel.allCategories, id: \.name) { category in
                                        HStack {
                                            Text(category.name ?? "Unknown Category")
                                                .foregroundColor(selectedCategory == category ? .blue : Color("TextColor"))
                                                .font(.system(size: 18))
                                                .padding(.leading, 10)
                                            Spacer()
                                            
                                            if selectedCategory == category {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.blue)
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            selectedCategory = category
                                            isCategoryValid = true
                                        }
                                        .swipeActions {
                                            if category.isDefault != true {
                                                Button(role: .destructive) {
                                                    exerciseViewModel.deleteCategory(category)
                                                    
                                                    if selectedCategory == category {
                                                        selectedCategory = exerciseViewModel.allCategories.first
                                                    }
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            } else {
                                                Button {
                                                    showAlert = true
                                                } label: {
                                                    Label("Cannot Delete", systemImage: "lock.fill")
                                                }
                                                .tint(.gray)
                                            }
                                        }
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .background(Color("ViewColor").opacity(0.2))
                            .cornerRadius(8)
                            .frame(minHeight: CGFloat(exerciseViewModel.allCategories.count) * 45)
                            .onAppear {
                                exerciseViewModel.loadCategories()
                            }
                            
                            // Кнопка "Add New Category"
                            Button(action: {
                                isAddingNewCategory = true
                            }) {
                                Text("+ Add New Category")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding()
                                    .padding(.horizontal, 5)
                                    .background(Color("ButtonColor"))
                                    .cornerRadius(10)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .contentShape(Rectangle())
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Cannot Delete Category"),
                                message: Text("Default categories cannot be deleted."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        
                        // MARK: - Create New Category
                        if isAddingNewCategory {
                            VStack {
                                Text("Create New Category")
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack {
                                    CustomTextField(
                                        placeholder: "Enter Category Name",
                                        text: $newCategoryName,
                                        isValid: isCategoryNameUnique,
                                        errorMessage: isCategoryNameUnique
                                        ? "Enter Category Name"
                                        : "Category with this name already exists. Please choose another name."
                                    )
                                    .id(categoryNameFieldID) // Уникальный идентификатор для прокрутки
                                    .focused($isCategoryNameFocused) // Отслеживаем фокус
                                    .onChange(of: isCategoryNameFocused) { _, isFocused in
                                        if isFocused {
                                            // Прокручиваем к текстовому полю при фокусе
                                            withAnimation {
                                                proxy.scrollTo(categoryNameFieldID, anchor: .center)
                                            }
                                        }
                                    }
                                    .onChange(of: newCategoryName) { _, newValue in
                                        isCategoryNameUnique = isCategoryNameUniqueInCategories()
                                    }
                                    
                                    CustomButton(
                                        title: "Done",
                                        isEnabled: isCategoryNameUnique,
                                        action: {
                                            addNewCategory()
                                            isAddingNewCategory = false
                                        }
                                    )
                                }
                                .background(Color("ViewColor").opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                        
                        // MARK: - Add Exercise Picture
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
                                } else {
                                    Text("No image selected")
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding()
                                }
                                
                                Button(action: {
                                    PHPhotoLibrary.checkPermission { granted, status in
                                        if granted {
                                            isShowingImagePicker = true
                                        } else {
                                            switch status {
                                            case .denied:
                                                alertMessage = "Photo access is denied. Please allow access in Settings."
                                            case .restricted:
                                                alertMessage = "Photo access is restricted by system settings."
                                            case .limited:
                                                alertMessage = "Photo access is limited. Please allow full access in Settings."
                                            default:
                                                alertMessage = "Unable to access the photo library."
                                            }
                                            showPermissionAlert = true
                                        }
                                    }
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
                                .buttonStyle(PlainButtonStyle())
                                .contentShape(Rectangle())
                                .alert(isPresented: $showPermissionAlert) {
                                    Alert(
                                        title: Text("Access Error"),
                                        message: Text(alertMessage),
                                        primaryButton: .default(Text("Open Settings")) {
                                            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                                                UIApplication.shared.open(appSettings)
                                            }
                                        },
                                        secondaryButton: .cancel(Text("Cancel"))
                                    )
                                }
                            }
                            .background(Color("ViewColor").opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                        // MARK: - Select Attributes
                        VStack {
                            Text(isAttributesValid ? "Select Attributes for Exercise" : "Please select at least one attribute")
                                .font(.system(size: 18))
                                .foregroundColor(isAttributesValid ? .gray : .red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            List {
                                Section {
                                    ForEach(attributes, id: \.self) { attribute in
                                        HStack {
                                            Text(attribute)
                                                .foregroundColor(selectedAttributes.contains(attribute) ? .blue : Color("TextColor"))
                                                .font(.system(size: 18))
                                                .padding(.leading, 10)
                                            Spacer()
                                            if selectedAttributes.contains(attribute) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.blue)
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            if selectedAttributes.contains(attribute) {
                                                selectedAttributes.remove(attribute)
                                            } else {
                                                if selectedAttributes.count < 2 {
                                                    selectedAttributes.insert(attribute)
                                                    isAttributesValid = true
                                                } else {
                                                    showAttributeLimitAlert = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .background(Color("ViewColor").opacity(0.2))
                            .cornerRadius(8)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listStyle(PlainListStyle())
                            .scrollIndicators(.hidden)
                            .frame(minHeight: CGFloat(attributes.count) * 45)
                        }
                        .alert(isPresented: $showAttributeLimitAlert) {
                            Alert(
                                title: Text("Limit Reached"),
                                message: Text("You can select a maximum of 2 attributes."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        
                        // MARK: - Submit Button
                        VStack {
                            CustomButton(
                                title: "Create Exercise",
                                isEnabled: isValidExerciseInput(),
                                action: {
                                    addExercise()
                                }
                            )
                            
                            if let errorMessage = errorMessage {
                                Text(errorMessage)
                                    .font(.system(size: 14))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding()
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .simultaneousGesture(TapGesture().onEnded {
            UIApplication.shared.endEditing(true)
        })
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePickerWithCrop(selectedImage: $exerciseImage, isImagePicked: .constant(true))
        }
        .onAppear {
            updateErrorMessage()
        }
        .onChange(of: exerciseName) {
            updateErrorMessage()
        }
        .onChange(of: selectedCategory) {
            updateErrorMessage()
        }
        .onChange(of: selectedAttributes) {
            updateErrorMessage()
        }
        .onChange(of: isExerciseNameUnique) {
            updateErrorMessage()
        }
    }
    
    // MARK: - Helper Functions
    
    private func addExercise() {
        guard isValidExerciseInput() else {
            handleInvalidExerciseInput()
            return
        }
        
        exerciseViewModel.addExerciseToCoreData(
            name: exerciseName,
            category: selectedCategory,
            image: exerciseImage,
            attributes: selectedAttributes
        )
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func isValidExerciseInput() -> Bool {
        return !exerciseName.isEmpty && selectedCategory != nil && !selectedAttributes.isEmpty && isExerciseNameUnique
    }
    
    private func handleInvalidExerciseInput() {
        updateErrorMessage()
    }
    
    private func updateErrorMessage() {
        if exerciseName.isEmpty {
            errorMessage = "Enter exercise name"
        } else if selectedCategory == nil {
            errorMessage = "Choose exercise category"
        } else if selectedAttributes.isEmpty {
            errorMessage = "Select at least one attribute"
        } else if !isExerciseNameUnique {
            errorMessage = "Exercise with this name already exists. Please choose another name."
        } else {
            errorMessage = nil
        }
    }
    
    private func isExerciseNameUniqueInCategory() -> Bool {
        let trimmedName = exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
        return !exerciseViewModel.allDefaultExercises.contains { $0.name == trimmedName }
    }
    
    private func addNewCategory() {
        guard !newCategoryName.isEmpty, !categoryExists() else { return }
        
        exerciseViewModel.addCategory(newCategoryName)
        selectedCategory = exerciseViewModel.allCategories.last
        isCategoryValid = true
        resetCategoryCreationState()
    }
    
    private func isCategoryNameUniqueInCategories() -> Bool {
        return !exerciseViewModel.allCategories.contains { $0.name?.lowercased() == newCategoryName.lowercased() }
    }
    
    private func categoryExists() -> Bool {
        return exerciseViewModel.allCategories.contains { $0.name == newCategoryName }
    }
    
    private func resetCategoryCreationState() {
        newCategoryName = ""
        isAddingNewCategory = false
    }
}
