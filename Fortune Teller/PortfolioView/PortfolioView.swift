//
//  PortfolioView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/6/24.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var dataParsingService: DataParsingService
    @State private var portfolios: [Portfolio] = []
    @State private var isCreatingNewPortfolio = false
    @State private var isUploadingPortfolio = false
    @State private var uploadedPortfolioString = ""
    @State private var parsingError: String?

    var body: some View {
        NavigationView {
            VStack {
                Text("Current Portfolios")
                    .font(.title)
                    .foregroundColor(.green)

                if portfolios.isEmpty {
                    Text("No portfolios available")
                        .foregroundColor(.white)
                } else {
                    List(portfolios, id: \.id) { portfolio in
                        NavigationLink(destination: PortfolioDetailedView(
                            portfolio: Binding(
                                get: { portfolio },
                                set: { updatePortfolio($0) }
                            ),
                            onUpdate: { updatedPortfolio in
                                updatePortfolio(updatedPortfolio)
                            },
                            onDelete: {
                                deletePortfolio(portfolio)
                            }
                        ).environmentObject(dataParsingService)) {
                            Text(portfolio.name)
                        }
                    }
                    .listStyle(InsetGroupedListStyle()) // Apply list style
                }

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
                        }
                        .padding()
                        .disabled(uploadedPortfolioString.isEmpty)

                        if let error = parsingError {
                            Text(error)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                }
                .padding(.bottom) // Add padding to the buttons
                Spacer()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all)) // Apply black color
        }
        .onAppear {
            print("PortfolioView appeared. Loading portfolios...")
            loadPortfolios()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Apply black color
    }

    private func savePortfolio(_ newPortfolio: Portfolio) {
        portfolios.append(newPortfolio)
        savePortfoliosToFile()
    }
    
    private func updatePortfolio(_ updatedPortfolio: Portfolio) {
        if let index = portfolios.firstIndex(where: { $0.id == updatedPortfolio.id }) {
            portfolios[index] = updatedPortfolio
            savePortfoliosToFile()
        }
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

    private func deletePortfolio(_ portfolio: Portfolio) {
        if let index = portfolios.firstIndex(where: { $0.id == portfolio.id }) {
            portfolios.remove(at: index)
            savePortfoliosToFile()
        }
    }

    private func parseAndSavePortfolio() {
        if let jsonData = uploadedPortfolioString.data(using: .utf8) {
            do {
                var newPortfolio = try JSONDecoder().decode(Portfolio.self, from: jsonData)
                
                // Generate a new unique ID for the new portfolio
                newPortfolio.id = UUID()
                
                portfolios.append(newPortfolio)
                savePortfoliosToFile()
                loadPortfolios() // Reload portfolios to update the list

                uploadedPortfolioString = ""
                isUploadingPortfolio = false
                parsingError = nil
            } catch {
                parsingError = "Error parsing and saving portfolio: \(error.localizedDescription)"
                print(parsingError!)
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(DataParsingService())
    }
}

