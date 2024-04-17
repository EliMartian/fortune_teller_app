//
//  NotificationsView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/6/24.
//

//
//  ResearchView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/6/24.
//

import Foundation
import SwiftUI

struct NotificationsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Notifications")
                        .font(.title)
                        .foregroundColor(.green)
                    
                    Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use stack navigation style to avoid tab bar interference
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
