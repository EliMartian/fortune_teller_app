//
//  PortfolioDetailedView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/27/24.
//

import Foundation
import SwiftUI

struct PortfolioDetailedView: View {
    @EnvironmentObject private var dataParsingService: DataParsingService
    let portfolio: Portfolio
    let onDelete: () -> Void
    
    // Binding to control the presentation of the alert
    @State private var isShowingAlert = false
    @State private var sharedText: SharedTextItem? = nil

    var body: some View {
        VStack {
            Spacer()
            Text("Portfolio Name: \(portfolio.name)")
                .padding()
                .foregroundColor(.blue)

            Text("Ticker Symbols:")
                .padding(.top, 10)
                .foregroundColor(.blue)

            List(portfolio.tickerSymbols, id: \.self) { tickerSymbol in
                Text(tickerSymbol)
            }

            Spacer()

            Button("Delete Portfolio") {
                onDelete()
            }
            .foregroundColor(.red)
            .padding()
            
            Button(action: {
                // Generate JSON representation of the portfolio
                if let jsonData = try? JSONEncoder().encode(portfolio),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    sharedText = SharedTextItem(text: jsonString)
                } else {
                    sharedText = nil
                    isShowingAlert = true
                }
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.blue)
            }
            .padding() // Add padding to the share button
        }
        .navigationTitle("Portfolio Details")
        .onAppear {
            // Show the alert if there's an error in generating the JSON string
            if dataParsingService.parsingError != nil {
                isShowingAlert = true
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Error"),
                message: Text("Failed to generate JSON representation"),
                dismissButton: .default(Text("OK"))
            )
        }
        .sheet(item: $sharedText) { sharedTextItem in
            // Present custom ActivityViewController to share the JSON string
            ActivityViewController(activityItems: [sharedTextItem.text])
        }
    }
}


struct SharedTextItem: Identifiable {
    let id = UUID()
    let text: String
}
