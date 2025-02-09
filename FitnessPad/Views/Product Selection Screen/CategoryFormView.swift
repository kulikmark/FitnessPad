//
//  CategoryFormView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 06.02.2025.
//

import SwiftUI

struct CategoryFormView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker = false
    
    @ObservedObject var productViewModel: ProductViewModel
    var categoryToEdit: CustomCategory? // Категория для редактирования
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Category Information")) {
                    TextField("Name", text: $name)
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    
                    Button("Select Image") {
                        isShowingImagePicker = true
                    }
                }
            }
            .navigationTitle(categoryToEdit == nil ? "Add Category" : "Edit Category")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let imageData = selectedImage?.jpegData(compressionQuality: 1.0)
                        if let categoryToEdit = categoryToEdit {
                            // Редактируем существующую категорию
                            productViewModel.updateCustomCategory(
                                categoryToEdit,
                                name: name,
                                image: imageData
                            )
                        } else {
                            // Создаем новую категорию
                            productViewModel.addCustomCategory(name: name, image: imageData)
                        }
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePickerWithCrop(selectedImage: $selectedImage)
            }
            .onAppear {
                if let categoryToEdit = categoryToEdit {
                    // Заполняем форму данными для редактирования
                    name = categoryToEdit.name ?? ""
                    if let imageData = categoryToEdit.categoryImage,
                       let uiImage = UIImage(data: imageData) {
                        selectedImage = uiImage
                    }
                }
            }
        }
    }
}
