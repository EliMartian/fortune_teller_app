//
//  Portfolio.swift
//  Fortune Teller
//
//  Created by E Martin on 4/27/24.
//

import Foundation

struct Portfolio: Identifiable, Codable {
    var id = UUID()
    var name: String
    var tickerSymbols: [String]

    // Static method to load portfolios from file
    static func loadPortfoliosFromFile() -> [Portfolio] {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("portfolios.json")

        // Check if the file exists before loading
        if FileManager.default.fileExists(atPath: fileURL?.path ?? "") {
            do {
                let data = try Data(contentsOf: fileURL!)
                let portfolios = try JSONDecoder().decode([Portfolio].self, from: data)
                return portfolios
            } catch {
                print("Error loading portfolios from file: \(error)")
                return []
            }
        } else {
            print("File does not exist at path: \(fileURL?.path ?? "")")
            return []
        }
    }

    // Instance method to save portfolio to file
    func saveToFile() {
        var portfolios = Portfolio.loadPortfoliosFromFile()
        portfolios.append(self)

        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("portfolios.json")

        do {
            let data = try JSONEncoder().encode(portfolios)
            try data.write(to: fileURL!)
        } catch {
            print("Error saving portfolio to file: \(error)")
        }
    }
}
