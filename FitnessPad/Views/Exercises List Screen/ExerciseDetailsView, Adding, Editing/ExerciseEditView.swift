//
//  ExerciseEditView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.02.2025.
//

import SwiftUI

import SwiftUI
import AVKit
import PhotosUI

struct ExerciseEditView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var exerciseName: String
    @State private var exerciseDescription: String
    @State private var exerciseImage: UIImage?
    @State private var exerciseVideoData: Data?
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
    
    init(exerciseViewModel: ExerciseViewModel) {
        self.exerciseViewModel = exerciseViewModel
        let exercise = exerciseViewModel.selectedExercise!
        
        _exerciseName = State(initialValue: exercise.name ?? "")
        _exerciseDescription = State(initialValue: exercise.exerciseDescription ?? "")
        
        if let imageData = exercise.image {
            _exerciseImage = State(initialValue: UIImage(data: imageData))
        }
        
        if let videoData = exercise.video {
            _exerciseVideoData = State(initialValue: videoData)
        }
        
        _selectedCategory = State(initialValue: exercise.categories)
        
        if let attributes = exercise.attributes as? Set<ExerciseAttribute> {
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
                // Поле для ввода названия упражнения
                TextField("Exercise Name", text: $exerciseName)
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextColor"))
                    .padding()
                    .background(Color("BackgroundColor").opacity(0.1))
                    .cornerRadius(8)
                
                // Категория упражнения
                CategorySelectionView(
                    exerciseViewModel: exerciseViewModel,
                    selectedCategory: $selectedCategory,
                    isCategoryValid: $isCategoryValid,
                    isAddingNewCategory: $isAddingNewCategory,
                    newCategoryName: $newCategoryName,
                    isCategoryNameUnique: $isCategoryNameUnique,
                    showAlert: $showAlert
                )
                
                // Фото упражнения
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
                    
                    CustomButton(
                        title: "Change Image",
                        isEnabled: true,
                        action: {
                            PHPhotoLibrary.checkPermission { granted, status in
                                if granted {
                                    isShowingImagePicker = true
                                } else {
                                    showPermissionAlert(for: status)
                                }
                            }
                        }
                    )
                }
                
                // Видео упражнения
                VStack {
                    if let videoData = exerciseVideoData {
                        VideoPlayerView(videoData: videoData)
                        
                        CustomButton(
                            title: "Delete Video",
                            isEnabled: true,
                            action: {
                                exerciseVideoData = nil
                            }
                        )
                        .padding(.top, 8)
                        .foregroundColor(.red)
                    } else {
                        Text("No video selected")
                            .foregroundColor(.gray)
                            .padding()
                    }

                    CustomButton(
                        title:  exerciseVideoData == nil ? "Select Video" : "Change Video",
                        isEnabled: true,
                        action: {
                            PHPhotoLibrary.checkPermission { granted, status in
                                if granted {
                                    isShowingVideoPicker = true
                                } else {
                                    showPermissionAlert(for: status)
                                }
                            }
                        }
                    )
                }

                
                // Описание упражнения
                TextEditor(text: $exerciseDescription)
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextColor"))
                    .frame(height: 100)
                    .padding()
                    .background(Color("BackgroundColor").opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // Атрибуты упражнения
                AttributeSelectionView(
                    attributes: attributes,
                    selectedAttributes: $selectedAttributes,
                    isAttributesValid: $isAttributesValid,
                    showAttributeLimitAlert: $showAttributeLimitAlert
                )
                
                // Кнопка сохранения изменений
                CustomButton(
                    title: "Save Changes",
                    isEnabled: true,
                    action: saveChanges
                )
            }
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Edit Exercise", displayMode: .inline)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePickerWithCrop(selectedImage: $exerciseImage)
        }
        .sheet(isPresented: $isShowingVideoPicker) {
            VideoPicker(
                selectedVideoData: $exerciseVideoData,
                isVideoPicked: .constant(true),
                showVideoSizeAlert: $showVideoSizeAlert,
                maxFileSize: 100 * 1024 * 1024 // 100 МБ
            )
        }
        .alert(isPresented: $showVideoSizeAlert) {
            Alert(
                title: Text("File Too Large"),
                message: Text("The selected video exceeds the maximum allowed size of 100 MB. Do you want to compress it?"),
                primaryButton: .default(Text("Compress")) {
                    Task {
                        await handleVideoCompression()
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func saveChanges() {
        exerciseViewModel.updateExerciseInCoreData(
            exercise: exerciseViewModel.selectedExercise!,
            name: exerciseName,
            exerciseDescription: exerciseDescription,
            category: selectedCategory,
            image: exerciseImage,
            video: exerciseVideoData, // Передаем videoData
            attributes: selectedAttributes
        )
        
        // Закрываем экран редактирования
        presentationMode.wrappedValue.dismiss()
    }
    
    private func handleVideoCompression() async {
        // Логика сжатия видео
    }
    
    private func showPermissionAlert(for status: PHAuthorizationStatus) {
        // Логика показа алерта для разрешений
    }
}
