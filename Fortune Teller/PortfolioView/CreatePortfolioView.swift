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
    var existingPortfolio: Portfolio? = nil

    @State private var portfolioName: String = ""
    @State private var tickerSymbols: [String] = [""]
    @State private var costBasis: [String] = [""]
    @State private var showCostBasis = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Portfolio Details")) {
                    TextField("Portfolio Name", text: $portfolioName)

                    ForEach(tickerSymbols.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            HStack {
                                TextField("Ticker Symbol \(index + 1)", text: Binding(
                                    get: { tickerSymbols[safe: index] ?? "" },
                                    set: { tickerSymbols[safe: index] = $0 }
                                ))
                                .padding()

                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundColor(.green)
                                    .padding(.trailing, 8)
                                    .onTapGesture {
                                        showCostBasis.toggle()
                                    }

                                Button(action: {
                                    if tickerSymbols.indices.contains(index) && costBasis.indices.contains(index) {
                                        tickerSymbols.remove(at: index)
                                        costBasis.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.horizontal)

                            if showCostBasis {
                                TextField("Cost Basis", text: Binding(
                                    get: { costBasis.indices.contains(index) ? costBasis[index] : "" },
                                    set: {
                                        if costBasis.indices.contains(index) {
                                            costBasis[index] = $0
                                        }
                                    })
                                )
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.leading, 40)
                            }
                        }
                    }

                    Button(action: {
                        tickerSymbols.append("")
                        costBasis.append("")
                    }) {
                        Label("Add Ticker Symbol", systemImage: "plus")
                    }
                }
            }
            .navigationTitle(existingPortfolio == nil ? "Create Portfolio" : "Edit Portfolio")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    savePortfolio()
                }
            )
            .onAppear {
                if let portfolio = existingPortfolio {
                    portfolioName = portfolio.name
                    tickerSymbols = portfolio.tickerSymbols
                    costBasis = portfolio.costBasis
                }
            }
        }
    }

    private func savePortfolio() {
        guard !portfolioName.isEmpty else {
            print("Error: Portfolio name is empty")
            return
        }

        synchronizeArraySizes()

        let newPortfolio = Portfolio(id: existingPortfolio?.id ?? UUID(), name: portfolioName, tickerSymbols: tickerSymbols, costBasis: costBasis)
        onSave(newPortfolio)
        isPresented = false
    }

    private func synchronizeArraySizes() {
        while tickerSymbols.count > costBasis.count {
            costBasis.append("")
        }
        while costBasis.count > tickerSymbols.count {
            tickerSymbols.append("")
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        get {
            return indices.contains(index) ? self[index] : nil
        }
        set {
            if let newValue = newValue, indices.contains(index) {
                self[index] = newValue
            }
        }
    }
}
