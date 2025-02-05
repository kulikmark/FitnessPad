////
////  ImagePicker.swift
////  FitnessPad
////
////  Created by Марк Кулик on 07.08.2024.
////
//
//import SwiftUI
//import PhotosUI
//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    @Binding var isImagePicked: Bool
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var configuration = PHPickerConfiguration()
//        configuration.selectionLimit = 1
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = context.coordinator
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
//    
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        var parent: ImagePicker
//        
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//        
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            picker.dismiss(animated: true) {
//                if let provider = results.first?.itemProvider {
//                    if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
//                        provider.loadObject(ofClass: UIImage.self) { image, error in
//                            DispatchQueue.main.async {
//                                if let image = image as? UIImage {
//                                    self.parent.selectedImage = image
//                                    self.parent.isImagePicked = true
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

import SwiftUI
import UIKit

struct ImagePickerWithCrop: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isImagePicked: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true  // Разрешаем редактировать изображение
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerWithCrop
        
        init(_ parent: ImagePickerWithCrop) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true) {
                if let editedImage = info[.editedImage] as? UIImage {
                    self.parent.selectedImage = editedImage
                    self.parent.isImagePicked = true
                } else if let originalImage = info[.originalImage] as? UIImage {
                    self.parent.selectedImage = originalImage
                    self.parent.isImagePicked = true
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
