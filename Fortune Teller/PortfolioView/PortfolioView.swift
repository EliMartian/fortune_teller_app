//
//  PortfolioView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/6/24.
//


import Foundation
import SwiftUI

struct PortfolioView: View {
    @State private var portfolios: [Portfolio] = []
    @State private var isCreatingNewPortfolio = false

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                NavigationView {
                    VStack {
                        List {
                            ForEach(portfolios) { portfolio in
                                NavigationLink(destination: PortfolioDetailedView(portfolio: portfolio, onDelete: {
                                    deletePortfolio(portfolio)
                                })) {
                                    Text(portfolio.name)
                                }
                            }
                        }
                        
                        Spacer()
                        
                    }
                    .navigationTitle("Portfolios")
                }
                .onAppear {
                    loadPortfolios()
                }
                Spacer()
                VStack {
                    Button("Create a new Portfolio") {
                        isCreatingNewPortfolio = true
                    }
                    .padding()
                    .sheet(isPresented: $isCreatingNewPortfolio) {
                        CreatePortfolioView(isPresented: $isCreatingNewPortfolio) { newPortfolio in
                            savePortfolio(newPortfolio)
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.99)
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
}


struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}

//struct PortfolioRow: View {
//    let portfolio: Portfolio
//    let onDelete: () -> Void // Closure to handle deletion
//
//    var body: some View {
//        HStack {
//            NavigationLink(destination: PortfolioDetailedView(portfolio: portfolio)) {
//                Text(portfolio.name)
//            }
//            Spacer()
//            Button(action: onDelete) {
//                Image(systemName: "trash")
//                    .foregroundColor(.red)
//            }
//        }
//        .padding()
//    }
//}
