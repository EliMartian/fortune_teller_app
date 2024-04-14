//
//  HomeView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/6/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Fortune Teller")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: DetailView()) {
                    Text("Go to Detail View")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Spacer()
            }
        }
        .tabItem {
            Image(systemName: "house.fill")
            Text("Home")
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("This is the Detail View")
            .font(.title)
            .padding()
            .navigationBarTitle("Detail")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
