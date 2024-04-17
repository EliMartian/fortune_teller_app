//
//  ProfileView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/6/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Profile")
                        .font(.title)
                        .foregroundColor(.green)
                    
                    Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use stack navigation style to avoid
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
