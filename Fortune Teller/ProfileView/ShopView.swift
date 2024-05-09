//
//  ShopView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/28/24.
//
import SwiftUI
import Combine

struct ShopView: View {
    @EnvironmentObject private var shopKitManager: ShopKitManager
    @State private var isNavigatingBack = false // State to control navigation back
    
    var body: some View {
        VStack {
            Text("Shop")
                .font(.title)
                .foregroundColor(.green)
                .padding() // Add padding for visual separation
            
            if !shopKitManager.fakeProducts.isEmpty {
                List(shopKitManager.fakeProducts) { product in
                    Text(product.localizedTitle)
                    Text(String(describing: product.price))
                        .foregroundColor(.green)
                }
            } else {
                ProgressView("Loading...") // Show loading indicator while fakeProducts is empty
            }
        }
        .navigationBarTitle("In-App Purchases")
        .navigationBarBackButtonHidden(true) // Hide default back button
        
        // Custom back button leading navigation link
        .navigationBarItems(leading:
            Button(action: {
                isNavigatingBack = true // Set state to trigger navigation back
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.green)
                    .imageScale(.large)
            }
        )
        .background(
            NavigationLink(
                destination: ProfileView(),
                isActive: $isNavigatingBack,
                label: {
                    EmptyView() // Use a NavigationLink to navigate back to ProfileView
                }
            )
            .hidden() // Hide the NavigationLink view
        )
    }
}

