//
//  Fortune_TellerApp.swift
//  Fortune Teller
//
//  Created by E Martin on 4/5/24.
//

import SwiftUI

@main
struct Fortune_TellerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView() // Display ContentView with TabView
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
            
            PortfolioView()
            
            ResearchView()
            
            NotificationsView()
            
            ProfileView()
            
        }
    }
}
