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
    @State private var showCostBasis = false // State variable to control visibility of Cost Basis textbox


    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Portfolio Details")) {
                    TextField("Portfolio Name", text: $portfolioName)

                    ForEach(tickerSymbols.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            HStack {
                                TextField("Ticker Symbol \(index + 1)", text: $tickerSymbols[index])
                                    .padding() // Add padding to the text field for spacing
                                
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundColor(.green)
                                    .padding(.trailing, 8) // Adjust trailing padding to separate the icon from the text field
                                    .onTapGesture {
                                        // Toggle the state to show/hide the cost basis textbox
                                        showCostBasis.toggle()
                                    }
                            }
                            .padding(.horizontal) // Add horizontal padding to the HStack
                            
                            if showCostBasis {
                                TextField("Cost Basis", text: .constant(""))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.leading, 40) // Add leading padding to indent the cost basis textbox
                            }
                        }
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
