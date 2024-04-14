//
//  PortfolioView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/6/24.
//

import Foundation
import SwiftUI

struct PortfolioView: View {
    var body: some View {
        Text("Portfolio Screen")
            .font(.title)
            .navigationBarTitle("Portfolio")
            .tabItem {
                Image(systemName: "hourglass")
                Text("Portfolio")
            }
    }
}

struct Portfolio_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
