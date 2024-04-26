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
    @State private var calculatedYield: Double?
    @State private var stockData: [StockDataPoint] = []
    @State private var errorMessage: String = ""
    @State private var cancellables = Set<AnyCancellable>() // Declare cancellables as @State property
    
    // Swift working???

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    TextField("Enter Stock Symbol", text: $ticker)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Search") {
                        if !ticker.isEmpty {
        //                    print("The stock the user put was: \(ticker)")
                            doResearch()
                        }
                    }
                    Spacer()
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

            }
            
            if let yield = calculatedYield {
                Text("Calculated Yield on 10 Years: $\(yield, specifier: "%.2f")")
                    .foregroundColor(.green)
                    .padding()
            }
            
            Spacer()
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Apply background color to outer VStack
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
                print("oldest datapoint?")
//                print("what is a datapoint: \(dataPoints)")
                print((dataPoints[0]))
                print(dataPoints[0].date)
                print(dataPoints[0].adjustedClose)
                let dataLength = dataPoints.count - 1
                
                print("newest datapoint?")
                print(dataPoints[dataLength])
                print(dataPoints[dataLength].date)
                print(dataPoints[dataLength].adjustedClose)
                
                let date = dataPoints[dataLength].date
                // Get the current calendar
                var calendar = Calendar.current
                calendar.timeZone = TimeZone(identifier: "UTC")!

                // Extract components from the date
                let components = calendar.dateComponents([.year, .month, .day], from: date)

                if let year = components.year, let month = components.month, let day = components.day {

                    
                    // Call findEntry method with unwrapped non-optional Int values and prepared response
                    if let closestIndex = SecurityRatingView.findEntry(year: year - 10, month: month, day: day, response: dataPoints) {
                        
                        // Use closestIndex or handle the result accordingly
                        print("Closest index in API response to 10 years ago today: \(closestIndex)")
                        print((dataPoints[closestIndex]))
                        print(dataPoints[closestIndex].date)
                        print(dataPoints[closestIndex].adjustedClose)
                        
                        print("trying to calculate yield on 10 years")
                        print(10000 / dataPoints[closestIndex].adjustedClose * dataPoints[dataLength].adjustedClose)
                        
                        let initialInvestment = 10000.0
                        let initialClose = dataPoints[closestIndex].adjustedClose
                        let finalClose = dataPoints[dataLength].adjustedClose

                        // Calculate the yield over 10 years
                        let yield = (initialInvestment / initialClose) * finalClose

                        // Update the state property with the calculated yield
                        calculatedYield = yield
                    } else {
                        print("no index found")
                    }
                    
                } else {
                    // Handle the case where any of year, month, or day is nil
                    print("Failed to extract year, month, or day from DateComponents")
                }

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
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

