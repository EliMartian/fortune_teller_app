//
//  ShopKitManager.swift
//  Fortune Teller
//
//  Created by E Martin on 4/28/24.
//

import Foundation
import StoreKit

class ShopKitManager: NSObject, ObservableObject {
    @Published var isAuthorizedForPayments = false
    @Published var products: [FakeProduct] = []
    @Published var selectedProduct: FakeProduct?
    @Published var fakeProducts: [FakeProduct] = [] // Add @Published property for fakeProducts

    private var productsRequest: SKProductsRequest?

    override init() {
        super.init()
        fetchFakeProducts()
    }

    func fetchFakeProducts() {
        let locale = Locale(identifier: "en_US")
        let fakeProduct1 = FakeProduct(localizedTitle: "Upgrade to Pro", price: NSDecimalNumber(decimal: 4.99), priceLocale: locale)
        let fakeProduct2 = FakeProduct(localizedTitle: "Premium Package", price: NSDecimalNumber(decimal: 9.99), priceLocale: locale)

        // Simulate delay for asynchronous loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.fakeProducts = [fakeProduct1, fakeProduct2]
        }
    }

    func purchaseFakeProduct(_ product: FakeProduct) {
        selectedProduct = product
        // Simulate purchase flow
        print("Simulating purchase of product: \(product.localizedTitle)")
    }
}


// Custom struct to represent fake product data
struct FakeProduct: Identifiable {
    let id = UUID()
    let localizedTitle: String
    let price: NSDecimalNumber
    let priceLocale: Locale
}
