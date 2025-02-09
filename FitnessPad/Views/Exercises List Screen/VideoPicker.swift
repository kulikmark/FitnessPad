//
//  VideoPicker.swift
//  FitnessPad
//
//  Created by Марк Кулик on 27.01.2025.
//

import SwiftUI
import PhotosUI

struct VideoPicker: UIViewControllerRepresentable {
    @Binding var selectedVideoURL: URL?
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
            
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                if let url = url {
                    let fileSize = (try? url.resourceValues(forKeys: [.fileSizeKey]))?.fileSize ?? 0
                    
                    if fileSize <= self.parent.maxFileSize {
                        DispatchQueue.main.async {
                            self.parent.selectedVideoURL = url
                            self.parent.isVideoPicked = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.parent.isVideoPicked = false
                            // Показываем предупреждение о превышении размера
                            self.parent.showVideoSizeAlert = true
                        }
                    }
                }
            }
        }
    }
}
