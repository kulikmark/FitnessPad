//
//  ExerciseDetailView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.01.2025.
//

import SwiftUI
import AVKit
import PhotosUI

struct ExerciseDetailView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @ObservedObject var coreDataService: CoreDataService
    var exercise: DefaultExercise
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditing = false
    @State private var exerciseName: String
    @State private var exerciseDescription: String
    @State private var exerciseImage: UIImage?
    @State private var exerciseVideoURL: URL?
    @State private var selectedAttributes: Set<String> = []
    @State private var isShowingImagePicker = false
    @State private var isShowingVideoPicker = false
    @State private var showVideoSizeAlert = false
    @State private var selectedCategory: ExerciseCategory?
    @State private var isAttributesValid = true
    @State private var showAttributeLimitAlert = false
    @State private var isCategoryValid = true
    @State private var isCategoryNameUnique = true
    @State private var isAddingNewCategory = false
    @State private var newCategoryName = ""
    @State private var showPermissionAlert = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let attributes = [
        NSLocalizedString("attribute_weight", comment: ""),
        NSLocalizedString("attribute_reps", comment: ""),
        NSLocalizedString("attribute_distance", comment: ""),
        NSLocalizedString("attribute_time", comment: "")
    ]

    
    init(exerciseViewModel: ExerciseViewModel, coreDataService: CoreDataService, exercise: DefaultExercise) {
        self.exerciseViewModel = exerciseViewModel
        self.coreDataService = coreDataService
        self.exercise = exercise
        _exerciseName = State(initialValue: exercise.name ?? "")
        _exerciseDescription = State(initialValue: exercise.exerciseDescription ?? "")
        
        if let imageData = exercise.image {
            _exerciseImage = State(initialValue: UIImage(data: imageData))
        }
        
        _selectedCategory = State(initialValue: exercise.categories)
        
        if let attributes = exercise.attributes as? Set<ExerciseAttribute> {
            // Преобразуем атрибуты в Set<String>, используя локализованные строки
            let attributeNames = attributes.filter { $0.isAdded }.compactMap {
                switch $0.name {
                case "Weight":
                    return NSLocalizedString("attribute_weight", comment: "")
                case "Reps":
                    return NSLocalizedString("attribute_reps", comment: "")
                case "Distance":
                    return NSLocalizedString("attribute_distance", comment: "")
                case "Time":
                    return NSLocalizedString("attribute_time", comment: "")
                default:
                    return nil
                }
            }
            _selectedAttributes = State(initialValue: Set(attributeNames))
        } else {
            _selectedAttributes = State(initialValue: [])
        }

    }
    
    var body: some View {
        ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            
            // Заголовок с названием упражнения
            HStack {
                if isEditing {
                    TextField("Exercise Name", text: $exerciseName)
                        .font(.system(size: 24))
                        .fontWeight(.medium)
                        .foregroundColor(Color("TextColor"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("BackgroundColor").opacity(0.1))
                        .cornerRadius(8)
                } else {
                    Text(exercise.name ?? "Unknown exercise")
                        .font(.system(size: 24))
                        .fontWeight(.medium)
                        .foregroundColor(Color("TextColor"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                CloseButtonCircle()
            }
            .padding()
            
            // Категория упражнения
            if let category = exercise.categories {
                Text("Category: \(category.name ?? "Unknown")")
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                    .padding(.horizontal)
            }
            
            // Фото упражнения
            if isEditing {
                VStack {
                    if let uiImage = exerciseImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    } else {
                        Text("No image selected")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    Button(action: {
                        PHPhotoLibrary.checkPermission { granted, status in
                            if granted {
                                isShowingImagePicker = true
                            } else {
                                showPermissionAlert(for: status)
                            }
                        }
                    }) {
                        Text("Change Image")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            } else if let imageData = exercise.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            // Видео упражнения
            if isEditing {
                VStack {
                    if let videoURL = exerciseVideoURL {
                        VideoPlayer(player: AVPlayer(url: videoURL))
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    } else {
                        Text("No video selected")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    Button(action: {
                        PHPhotoLibrary.checkPermission { granted, status in
                            if granted {
                                isShowingVideoPicker = true
                            } else {
                                showPermissionAlert(for: status)
                            }
                        }
                    }) {
                        Text("Change Video")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            } else if let videoURL = Bundle.main.url(forResource: "videoFileName", withExtension: "mp4") {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding(.horizontal)
            } else {
                Text("No video file found")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            
            // Описание упражнения
            if isEditing {
                TextEditor(text: $exerciseDescription)
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                    .frame(height: 100)
                    .padding()
                    .background(Color("BackgroundColor").opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
            } else if let description = exercise.exerciseDescription {
                Text("Description: \(description)")
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                    .padding(.horizontal)
            }
            
            // MARK: - Category List Selection
            if isEditing {
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
                            .onChange(of: newCategoryName) { _, newValue in
                                isCategoryNameUnique = isCategoryNameUniqueInCategories()
                            }
                            
                            CustomButton(
                                title: "Done",
                                isEnabled: isCategoryNameUnique,
                                action: {
                                    addNewCategory()
                                    //                                            isAddingNewCategory.toggle()
                                    isAddingNewCategory = false
                                }
                            )
                        }
                        .background(Color("ViewColor").opacity(0.2))
                        .cornerRadius(8)
                    }
                }
            }
            
            // MARK: - Select Attributes
            if isEditing {
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
            }
            
            Spacer()
            
            // Кнопка "Edit" или "Save Changes"
            if isEditing {
                Button(action: saveChanges) {
                    Text("Save Changes")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("ButtonTextColor"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            } else {
                Button(action: {
                    isEditing = true
                }) {
                    Text("Edit Exercise")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("ButtonTextColor"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("ButtonColor"))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
        }
    }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePickerWithCrop(selectedImage: $exerciseImage, isImagePicked: .constant(true))
        }
        .sheet(isPresented: $isShowingVideoPicker) {
            VideoPicker(selectedVideoURL: $exerciseVideoURL, isVideoPicked: .constant(true), showVideoSizeAlert: $showVideoSizeAlert, maxFileSize: 100 * 1024 * 1024) // 100 MB
        }
        .alert(isPresented: $showVideoSizeAlert) {
            Alert(
                title: Text("File Too Large"),
                message: Text("The selected video exceeds the maximum allowed size of 100 MB."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func categoryExists() -> Bool {
        return exerciseViewModel.allCategories.contains { $0.name == newCategoryName }
    }
    
    private func resetCategoryCreationState() {
        newCategoryName = ""
        isAddingNewCategory = false
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
    
    private func saveChanges() {
        // Обновляем данные упражнения
        exercise.name = exerciseName
        exercise.exerciseDescription = exerciseDescription
        
        if let image = exerciseImage {
            exercise.image = image.jpegData(compressionQuality: 1.0)
        }
        
        // Сохраняем изменения в Core Data
        coreDataService.saveContext()
        
        // Выходим из режима редактирования
        isEditing = false
    }
    
    private func showPermissionAlert(for status: PHAuthorizationStatus) {
        var alertMessage = ""
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
        
        let alert = UIAlertController(
            title: "Access Error",
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}
