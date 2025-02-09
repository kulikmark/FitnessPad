//
//  CategorySelectionView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 08.02.2025.
//

import SwiftUI

import SwiftUI

struct CategorySelectionView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    @Binding var selectedCategory: ExerciseCategory?
    @Binding var isCategoryValid: Bool
    @Binding var isAddingNewCategory: Bool
    @Binding var newCategoryName: String
    @Binding var isCategoryNameUnique: Bool
    @Binding var showAlert: Bool
    
    var body: some View {
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
            CustomButton(
                title: "+ Add New Category",
                isEnabled: true,
                action: {
                    isAddingNewCategory = true
                }
            )
        }
        .padding(.horizontal)
        
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
                            isAddingNewCategory = false
                        }
                    )
                }
                .background(Color("ViewColor").opacity(0.2))
                .cornerRadius(8)
            }
        }
    }
    
    private func addNewCategory() {
        guard !newCategoryName.isEmpty, !categoryExists() else { return }
        
        exerciseViewModel.addCategory(newCategoryName)
        selectedCategory = exerciseViewModel.allCategories.last
        isCategoryValid = true
        resetCategoryCreationState()
    }
    
    private func categoryExists() -> Bool {
        return exerciseViewModel.allCategories.contains { $0.name == newCategoryName }
    }
    
    private func resetCategoryCreationState() {
        newCategoryName = ""
        isAddingNewCategory = false
    }
    
    private func isCategoryNameUniqueInCategories() -> Bool {
        return !exerciseViewModel.allCategories.contains { $0.name?.lowercased() == newCategoryName.lowercased() }
    }
}
