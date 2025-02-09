//
//  FavoritesView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 06.02.2025.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var productViewModel: ProductViewModel
    
    var body: some View {
        List {
            ForEach(productViewModel.favoriteProducts) { product in
                Text(product.name)
            }
        }
        .navigationTitle("Избранное")
    }
}
