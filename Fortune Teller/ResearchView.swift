//
//  ResearchView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/6/24.
//

import Foundation
import SwiftUI
import Combine

struct ResearchView: View {
    @State private var ticker: String = ""
    @State private var stockData: [StockDataPoint] = []
    @State private var errorMessage: String = ""
    @State private var cancellables = Set<AnyCancellable>() // Declare cancellables as @State property
    
    // Swift working???

    var body: some View {
        VStack {
            TextField("Enter Stock Symbol", text: $ticker)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Search") {
                if !ticker.isEmpty {
//                    print("The stock the user put was: \(ticker)")
                    doResearch()
                }
            }
            .padding()

            if !stockData.isEmpty {
                SecurityGraphView(stockData: stockData, ticker: ticker)
                    .frame(height: 400)
                    .padding()
                    .clipped()

            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()
        }
        .navigationBarTitle("Research")
        .tabItem {
            Image(systemName: "magnifyingglass")
            Text("Search")
        }
    }

    private func doResearch() {
        let apiKey = "WJ2S8Y8BM204TYD6"
        let ticker = ticker.uppercased()
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_WEEKLY_ADJUSTED&symbol=\(ticker)&apikey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid Ticker, please try again"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data -> [StockDataPoint] in
                // Attempt to parse JSON data dynamically
                guard let res = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let timeSeries = res["Weekly Adjusted Time Series"] as? [String: [String: String]] else {
                    throw NSError(domain: "Invalid JSON", code: 0, userInfo: nil)
                }
                print("API Response: \(timeSeries)")
                
                // Convert API response to array of StockDataPoint objects
                var dataPoints: [StockDataPoint] = []
                for (dateString, priceData) in timeSeries {
                    if let adjustedClose = Double(priceData["5. adjusted close"] ?? "0.0"),
                       let date = DateFormatter.iso8601.date(from: dateString) {
                        dataPoints.append(StockDataPoint(date: date, adjustedClose: adjustedClose))
                    }
                }
                // Sort dataPoints array by date
                dataPoints.sort { $0.date < $1.date }
                print("what is a datapoint: \(dataPoints)")
                return dataPoints
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    errorMessage = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                // Handle successful response
                stockData = response
            })
            .store(in: &cancellables) // Store cancellable in @State property
    }
}

// Custom StockDataPoint struct representing a data point in the stock time series
struct StockDataPoint {
    var date: Date
    var adjustedClose: Double
}

// Extension to parse ISO8601 date format
extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}
