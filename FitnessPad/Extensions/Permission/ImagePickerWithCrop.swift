////
////  ImagePicker.swift
////  FitnessPad
////
////  Created by Марк Кулик on 07.08.2024.
////
//

import SwiftUI
import UIKit

struct ImagePickerWithCrop: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
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
                } else if let originalImage = info[.originalImage] as? UIImage {
                    self.parent.selectedImage = originalImage
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
