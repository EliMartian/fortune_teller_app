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
        Text("Profile Screen")
            .font(.title)
            .navigationBarTitle("Profile")
            .tabItem {
                Image(systemName: "person.circle")
                Text("Profile")
            }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
