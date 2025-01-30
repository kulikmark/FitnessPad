//
//  ExerciseDetailView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.01.2025.
//

//import SwiftUI
//import AVKit
//
//struct ExerciseDetailView: View {
//    @ObservedObject var viewModel: WorkoutViewModel
//    var exercise: DefaultExercise
//    
//    @Environment(\.presentationMode) var presentationMode // Для закрытия экрана
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            // Заголовок с названием упражнения
//            Text(exercise.name ?? "Unknown exercise")
//                .font(.system(size: 24))
//                .fontWeight(.bold)
//                .foregroundColor(Color("TextColor"))
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding()
//            
//            // Категория упражнения
//            if let category = exercise.categories {
//                Text("Category: \(category.name ?? "Unknown")")
//                    .font(.system(size: 16))
//                    .foregroundColor(Color("TextColor"))
//                    .padding(.horizontal)
//            }
//            
//            // Фото упражнения
//            if let imageData = exercise.image, let uiImage = UIImage(data: imageData) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(maxWidth: .infinity)
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//            }
//            
//            // Видео упражнения
//            if let videoURL = Bundle.main.url(forResource: "videoFileName", withExtension: "mp4") {
//                VideoPlayer(player: AVPlayer(url: videoURL))
//                    .frame(height: 200)
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//            } else {
//                Text("No video file found")
//                    .font(.system(size: 16))
//                    .foregroundColor(.gray)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding()
//            }
//            
//            // Описание упражнения
//            if let description = exercise.exerciseDescription {
//                Text("Description: \(description)")
//                    .font(.system(size: 16))
//                    .foregroundColor(Color("TextColor"))
//                    .padding(.horizontal)
//            }
//            
//            Spacer()
//        }
//        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
//        .navigationBarBackButtonHidden(true) // Скрываем стандартную кнопку "Back"
//        .overlay(alignment: .topTrailing) {
//            CloseButtonCircle()
//        }
//    }
//}


import SwiftUI
import AVKit
import PhotosUI

struct ExerciseDetailView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    var exercise: DefaultExercise
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isEditing = false
    @State private var exerciseName: String
    @State private var exerciseDescription: String
    @State private var exerciseImage: UIImage?
    @State private var exerciseVideoURL: URL?
    @State private var isShowingImagePicker = false
    @State private var isShowingVideoPicker = false
    @State private var showVideoSizeAlert = false
    
    init(viewModel: WorkoutViewModel, exercise: DefaultExercise) {
        self.viewModel = viewModel
        self.exercise = exercise
        _exerciseName = State(initialValue: exercise.name ?? "")
        _exerciseDescription = State(initialValue: exercise.exerciseDescription ?? "")
        
        if let imageData = exercise.image {
            _exerciseImage = State(initialValue: UIImage(data: imageData))
        }
    }
    
    var body: some View {
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
    
    private func saveChanges() {
        // Обновляем данные упражнения
        exercise.name = exerciseName
        exercise.exerciseDescription = exerciseDescription
        
        if let image = exerciseImage {
            exercise.image = image.jpegData(compressionQuality: 1.0)
        }
        
        // Сохраняем изменения в Core Data
        viewModel.saveContext()
        
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
