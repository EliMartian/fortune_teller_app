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
        Text("Notifications Screen")
            .font(.title)
            .navigationBarTitle("Research")
            .tabItem {
                Image(systemName: "bell")
                Text("Notifications")
            }
    }
}

struct Notifications_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
