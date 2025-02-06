//
//  CategoryTile.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.02.2025.
//

import SwiftUI

//// Компонент для плитки категории
//struct CategoryTile: View {
//    let category: String
//    
//    var body: some View {
//        VStack {
//            // Изображение категории (можно заменить на реальное изображение)
//            Image(systemName: "leaf.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 50, height: 50)
//                .padding()
//                .background(Color("ButtonColor"))
//                .foregroundColor(Color("ButtonTextColor"))
//                .cornerRadius(10)
//            
//            // Название категории
//            Text(LocalizedStringKey(category))
//                .font(.system(size: 16, weight: .medium))
//                .foregroundColor(Color("TextColor"))
//                .multilineTextAlignment(.center)
//                .padding(.top, 8)
//        }
//        .frame(maxWidth: .infinity, minHeight: 150)
//        .background(Color("ViewColor"))
//        .cornerRadius(12)
//    }
//}
import SwiftUI

struct CategoryTile: View {
    let category: Category
    
    var body: some View {
        VStack {
            // Изображение категории
            Image(category.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding()
//                .background(Color("ButtonColor"))
//                .foregroundColor(Color("ButtonTextColor"))
                .cornerRadius(10)
            Spacer()
            // Название категории
            Text(category.name.localized)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("TextColor"))
                .multilineTextAlignment(.center)
                .padding()
               
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(Color("ViewColor"))
        .cornerRadius(12)
    }
}
