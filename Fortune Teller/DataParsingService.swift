//
//  DataParsingService.swift
//  Fortune Teller
//
//  Created by E Martin on 4/27/24.
//

import Foundation
import Combine

class DataParsingService: ObservableObject {
    @Published var parsedPortfolio: Portfolio?
    @Published var parsingError: Error?
    
    func parseSharedPortfolio(from text: String) {
        guard let data = text.data(using: .utf8) else {
            self.parsingError = NSError(domain: "DataParsingService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let sharedData = try decoder.decode(SharedPortfolioData.self, from: data)
            let parsedPortfolio = Portfolio(name: sharedData.name, tickerSymbols: sharedData.tickerSymbols, costBasis: sharedData.costBasis)
            self.parsedPortfolio = parsedPortfolio
        } catch {
            self.parsingError = error
        }
    }
}

// Struct representing shared portfolio data format
struct SharedPortfolioData: Codable {
    let name: String
    let tickerSymbols: [String]
    let costBasis: [String]
}
