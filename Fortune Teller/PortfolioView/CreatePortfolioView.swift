//
//  CreatePortfolioView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/27/24.
//

import Foundation
import SwiftUI

struct CreatePortfolioView: View {
    @Binding var isPresented: Bool
    var onSave: (Portfolio) -> Void

    @State private var portfolioName: String = ""
    @State private var tickerSymbols: [String] = [""]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Portfolio Details")) {
                    TextField("Portfolio Name", text: $portfolioName)

                    ForEach(tickerSymbols.indices, id: \.self) { index in
                        TextField("Ticker Symbol \(index + 1)", text: $tickerSymbols[index])
                    }

                    Button(action: {
                        tickerSymbols.append("")
                    }) {
                        Label("Add Ticker Symbol", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Create Portfolio")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    savePortfolio()
                }
            )
        }
    }

    private func savePortfolio() {
        // Ensure portfolioName is not empty before saving
        guard !portfolioName.isEmpty else {
            // Optionally show an alert or message for empty portfolio name
            print("Error: Portfolio name is empty")
            return
        }

        // Create a new Portfolio instance
        let newPortfolio = Portfolio(name: portfolioName, tickerSymbols: tickerSymbols)

        // Invoke the onSave closure to handle the newly created portfolio
        onSave(newPortfolio)

        // Dismiss the view
        isPresented = false
    }
}


//struct CreatePortfolioView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatePortfolioView(isPresented: .constant(true), onSave: { _ in })
//    }
//}
