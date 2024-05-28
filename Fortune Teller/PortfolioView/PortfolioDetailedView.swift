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
    @Binding var portfolio: Portfolio
    @State private var portfolios: [Portfolio] = []
    var onUpdate: (Portfolio) -> Void
    var onDelete: () -> Void
    
    // Binding to control the presentation of the alert
    @State private var isShowingAlert = false
    @State private var sharedText: SharedTextItem? = nil
    @State private var isEditViewActive = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showCostBasis: [String: Bool] = [:]

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .padding()
                Spacer()
            }

            Text(portfolio.name)
                .font(.largeTitle)

            List {
                ForEach(portfolio.tickerSymbols, id: \.self) { ticker in
                    HStack {
                        Text(ticker)
                        Spacer()
                        Button(action: {
                            showCostBasis[ticker]?.toggle()
                        }) {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundColor(.green)
                        }
                        if showCostBasis[ticker] == true, let index = portfolio.tickerSymbols.firstIndex(of: ticker), index < portfolio.costBasis.count {
                            Text(portfolio.costBasis[index])
                                .foregroundColor(.green)
                        }
                    }
                }
            }

            HStack {
                Button(action: {
                    // Delete the portfolio
                    deletePortfolio()
                    // Call the onDelete closure
                    onDelete()
                    // Navigate back to the previous view
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                        Text("Delete Portfolio")
                            .foregroundColor(.red)
                    }
                }
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

                NavigationLink(destination: CreatePortfolioView(
                    isPresented: $isEditViewActive,
                    onSave: { updatedPortfolio in
                        saveUpdatedPortfolio(updatedPortfolio)
                    },
                    existingPortfolio: portfolio
                ), isActive: $isEditViewActive) {
                    Button("Edit Portfolio") {
                        isEditViewActive = true
                    }
                }
                .padding()
            }
        }
        .navigationBarHidden(true) // Hide the default back button
        .onAppear {
            // Show the alert if there's an error in generating the JSON string
            if dataParsingService.parsingError != nil {
                isShowingAlert = true
            }
            print("PortfolioDetailedView appeared")
            showCostBasis = Dictionary(uniqueKeysWithValues: portfolio.tickerSymbols.map { ($0, false) })
            loadPortfolios()
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

    private func saveUpdatedPortfolio(_ updatedPortfolio: Portfolio) {
        do {
            print("Trying to save your updated portfolio now")
            try savePortfolioToFile(updatedPortfolio)
            self.portfolio = updatedPortfolio
            onUpdate(updatedPortfolio)
            print("Let's see if this saved or not?")
            loadPortfolios()
        } catch {
            print("Error saving updated portfolio: \(error)")
        }
    }
    
    private func loadPortfolios() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("portfolios.json")

        print("Loading portfolios from file...")
        guard let data = try? Data(contentsOf: fileURL!) else {
            print("Portfolios file not found or empty")
            return
        }

        do {
            portfolios = try JSONDecoder().decode([Portfolio].self, from: data)
            print("Portfolios loaded: \(portfolios)")
        } catch {
            print("Error decoding portfolios from file: \(error)")
        }
    }

    private func savePortfolioToFile(_ portfolio: Portfolio) throws {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("portfolios.json")
        
        var portfolios = loadPortfoliosFromFile()
        if let index = portfolios.firstIndex(where: { $0.id == portfolio.id }) {
            portfolios[index] = portfolio
        } else {
            portfolios.append(portfolio)
        }
        
        let data = try JSONEncoder().encode(portfolios)
        try data.write(to: fileURL!)
    }

    private func deletePortfolio() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("portfolios.json")
        
        var portfolios = loadPortfoliosFromFile()
        portfolios.removeAll { $0.id == portfolio.id }
        
        do {
            let data = try JSONEncoder().encode(portfolios)
            try data.write(to: fileURL!)
        } catch {
            print("Error deleting old portfolio: \(error)")
        }
    }

    private func loadPortfoliosFromFile() -> [Portfolio] {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("portfolios.json")
        
        guard let data = try? Data(contentsOf: fileURL!) else {
            return []
        }
        
        do {
            let portfolios = try JSONDecoder().decode([Portfolio].self, from: data)
            return portfolios
        } catch {
            print("Error loading portfolios from file: \(error)")
            return []
        }
    }
}

struct PortfolioDetailedView_Previews: PreviewProvider {
    @State static var portfolio = Portfolio(id: UUID(), name: "Sample Portfolio", tickerSymbols: ["AAPL", "GOOGL"], costBasis: ["100", "200"])

    static var previews: some View {
        NavigationView {
            PortfolioDetailedView(portfolio: $portfolio, onUpdate: { _ in }, onDelete: { })
        }
    }
}

struct SharedTextItem: Identifiable {
    let id = UUID()
    let text: String
}

