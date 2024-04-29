//
//  ShopView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/28/24.
//

import SwiftUI
import StoreKit

struct ShopView: View {
    @EnvironmentObject private var shopKitManager: ShopKitManager
    
    var body: some View {
        List {
            ForEach(Array(shopKitManager.products.enumerated()), id: \.element) { index, product in
                Button(action: {
                    shopKitManager.purchaseProduct(product)
                }) {
                    Text("\(product.localizedTitle) - \(formatPrice(product.price, locale: product.priceLocale))")
                }
                .id(index) // Ensure each button has a unique identifier
            }
        }
    }
    
    // Helper function to format SKProduct price
    private func formatPrice(_ price: NSDecimalNumber, locale: Locale) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: price) ?? ""
    }
}
