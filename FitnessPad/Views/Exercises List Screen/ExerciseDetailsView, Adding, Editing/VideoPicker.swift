//
//  VideoPicker.swift
//  FitnessPad
//
//  Created by Марк Кулик on 27.01.2025.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct VideoPicker: UIViewControllerRepresentable {
    @Binding var selectedVideoData: Data?
    @Binding var isVideoPicked: Bool
    @Binding var showVideoSizeAlert: Bool
    var maxFileSize: Int // Максимальный размер файла в байтах
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .videos
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: VideoPicker
        
        init(_ parent: VideoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let result = results.first else { return }
            
            // Загружаем видео как Data
            result.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.movie.identifier) { data, error in
                if let error = error {
                    print("Failed to load video: \(error.localizedDescription)")
                    return
                }
                
                if let videoData = data {
                    let fileSize = videoData.count
                    
                    DispatchQueue.main.async {
                        if fileSize <= self.parent.maxFileSize {
                            // Видео подходит по размеру
                            self.parent.selectedVideoData = videoData
                            self.parent.isVideoPicked = true
                        } else {
                            // Видео слишком большое, показываем алерт
                            print("Video is too large, showing alert") // Отладочное сообщение
                            self.parent.showVideoSizeAlert = true
                        }
                    }
                }
            }
        }
    }
}
