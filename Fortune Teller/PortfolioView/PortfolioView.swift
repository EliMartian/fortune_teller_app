//
//  PortfolioView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/6/24.
//


import Foundation
import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var dataParsingService: DataParsingService
    @State private var portfolios: [Portfolio] = []
    @State private var isCreatingNewPortfolio = false
    @State private var isUploadingPortfolio = false
    @State private var uploadedPortfolioString = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Current Portfolios")
                    .font(.title)
                    .foregroundColor(.green)

                List {
                    ForEach(portfolios) { portfolio in
                        NavigationLink(destination: PortfolioDetailedView(
                            portfolio: portfolio,
                            onDelete: {
                                deletePortfolio(portfolio)
                            }
                        ).environmentObject(dataParsingService)) {
                            Text(portfolio.name)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle()) // Apply list style

                HStack {
                    Button("Create a new Portfolio") {
                        isCreatingNewPortfolio = true
                    }
                    .padding()

                    Button("Upload Portfolio") {
                        isUploadingPortfolio = true
                    }
                    .padding()
                }
                .sheet(isPresented: $isCreatingNewPortfolio) {
                    CreatePortfolioView(isPresented: $isCreatingNewPortfolio) { newPortfolio in
                        savePortfolio(newPortfolio)
                    }
                }
                .sheet(isPresented: $isUploadingPortfolio) {
                    VStack {
                        TextEditor(text: $uploadedPortfolioString)
                            .padding()
                            .border(Color.gray)
                        
                        Button("Parse and Save") {
                            parseAndSavePortfolio()
                            isUploadingPortfolio = false
                        }
                        .padding()
                        .disabled(uploadedPortfolioString.isEmpty)
                    }
                }
                .padding(.bottom) // Add padding to the buttons
                Spacer()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all)) // Apply black color
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use stack navigation style
        .onAppear {
            loadPortfolios()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Apply black color
    }

    private func savePortfolio(_ newPortfolio: Portfolio) {
        portfolios.append(newPortfolio)
        savePortfoliosToFile()
    }

    private func savePortfoliosToFile() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("portfolios.json")

        do {
            let data = try JSONEncoder().encode(portfolios)
            try data.write(to: fileURL!)
        } catch {
            print("Error saving portfolios to file: \(error)")
        }
    }

    private func loadPortfolios() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("portfolios.json")

        guard let data = try? Data(contentsOf: fileURL!) else {
            print("Portfolios file not found or empty")
            return
        }

        do {
            portfolios = try JSONDecoder().decode([Portfolio].self, from: data)
        } catch {
            print("Error decoding portfolios from file: \(error)")
        }
    }

    private func deletePortfolio(_ portfolio: Portfolio) {
        if let index = portfolios.firstIndex(where: { $0.id == portfolio.id }) {
            portfolios.remove(at: index)
            savePortfoliosToFile()
        }
    }

    private func parseAndSavePortfolio() {
        if let jsonData = uploadedPortfolioString.data(using: .utf8) {
            do {
                let newPortfolio = try JSONDecoder().decode(Portfolio.self, from: jsonData)
                savePortfolio(newPortfolio)
                uploadedPortfolioString = ""
            } catch {
                print("Error parsing and saving portfolio: \(error)")
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}

