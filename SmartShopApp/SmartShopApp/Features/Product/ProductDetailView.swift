//
//  ProductDetailView.swift
//  SmartShopApp
//
//  Created by Зейнаддин Зургамбаев on 13.05.2025.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        Form {
            Section(header: Text("Product Info")) {
                Text("Name: \(product.name ?? "-")")
                Text("Category: \(product.category ?? "-")")
                Text("Quantity: \(product.quantity)")
                Text("Price: \(product.price, specifier: "%.2f") ₸")
                Text("Store: \(product.store ?? "-")")
                Text("Importance: \(product.importance)/5")
                Text("Completed: \(product.isCompleted ? "Yes" : "No")")
            }
        }
        .navigationTitle("Product Details")
    }
}
