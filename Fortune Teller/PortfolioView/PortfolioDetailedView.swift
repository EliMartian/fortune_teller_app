//
//  PortfolioDetailedView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/27/24.
//

import Foundation
import SwiftUI

struct PortfolioDetailedView: View {
    let portfolio: Portfolio
    let onDelete: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("Portfolio Name: \(portfolio.name)")
                .padding()
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)

            Text("Ticker Symbols:")
                .padding(.top, 10)
                .foregroundColor(.red)

            List(portfolio.tickerSymbols, id: \.self) { tickerSymbol in
                Text(tickerSymbol)
            }

            Spacer()

            Button("Delete Portfolio") {
                onDelete()
            }
            .foregroundColor(.red)
            .padding()
        }
        .navigationTitle("Portfolio Details")
    }
}
