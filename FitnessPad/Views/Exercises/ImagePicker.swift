//
//  ImagePicker.swift
//  FitnessPad
//
//  Created by Марк Кулик on 07.08.2024.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isImagePicked: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true) {
                if let provider = results.first?.itemProvider {
                    if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        provider.loadObject(ofClass: UIImage.self) { image, error in
                            DispatchQueue.main.async {
                                if let image = image as? UIImage {
                                    self.parent.selectedImage = image
                                    self.parent.isImagePicked = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
