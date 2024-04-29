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
    @Published var products: [SKProduct] = []
    @Published var selectedProduct: SKProduct?

    private var productsRequest: SKProductsRequest?

    override init() {
        super.init()
        fetchProducts()
    }

    func fetchProducts() {
        let productIDs: Set<String> = ["com.yourapp.upgrade"]

        productsRequest = SKProductsRequest(productIdentifiers: productIDs)
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    func purchaseProduct(_ product: SKProduct) {
        selectedProduct = product
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension ShopKitManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }
}
