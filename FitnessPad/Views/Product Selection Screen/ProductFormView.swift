//
//  AddProductView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 06.02.2025.
//

import SwiftUI
import PhotosUI

struct ProductFormView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var category: CustomCategory
    @State private var proteins: String = ""
    @State private var fats: String = ""
    @State private var carbohydrates: String = ""
    @State private var calories: String = ""
    @State private var isShowingImagePicker = false
    @State private var isShowingCategoryPicker = false
    
    var productToEdit: CustomProduct?
    @ObservedObject var productViewModel: ProductViewModel
    
    init(productViewModel: ProductViewModel, category: CustomCategory) {
        self.productViewModel = productViewModel
        self._category = State(initialValue: category)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Product Information")) {
                    TextField("Name", text: $name)
                    TextField("Category", text: Binding(
                        get: { category.name ?? "" },
                        set: { category.name = $0 }
                    ))
                    TextField("Proteins", text: $proteins)
                    TextField("Fats", text: $fats)
                    TextField("Carbohydrates", text: $carbohydrates)
                    TextField("Calories", text: $calories)
                }
            }
            .navigationTitle(productToEdit == nil ? "Add Product" : "Edit Product")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProduct()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveProduct() {
        let proteinsValue = Double(proteins) ?? 0
        let fatsValue = Double(fats) ?? 0
        let carbohydratesValue = Double(carbohydrates) ?? 0
        let caloriesValue = Double(calories) ?? 0
        
        if let product = productToEdit {
            productViewModel.updateProduct(
                product,
                name: name,
                category: category,
                proteins: proteinsValue,
                fats: fatsValue,
                carbohydrates: carbohydratesValue,
                calories: caloriesValue
            )
        } else {
            productViewModel.addProduct(
                name: name,
                category: category,
                proteins: proteinsValue,
                fats: fatsValue,
                carbohydrates: carbohydratesValue,
                calories: caloriesValue
            )
        }
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
