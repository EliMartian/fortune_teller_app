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
    @State private var yieldCalculations: [YieldCalculation] = []
    @State private var stockData: [StockDataPoint] = []
    @State private var errorMessage: String = ""
    @State private var cancellables = Set<AnyCancellable>() // Declare cancellables as @State property
    
    // Swift working???
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack() {
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
                        
                        Spacer()
                        
                        if !stockData.isEmpty {
                            SecurityGraphView(stockData: stockData, ticker: ticker)
                                .frame(height: self.calculateGraphHeight(geometry: geometry))
                                .frame(width: self.calculateGraphHeight(geometry: geometry))
                                .padding(.top, self.calculateVerticalPaddingTop(geometry: geometry))
                                .padding(.bottom, self.calculateVerticalPaddingBottom(geometry: geometry))
                                .clipped()
                            
                        }
                        
                        Spacer()
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                    }
                    VStack {
                        // Display yield calculations
                        ForEach(yieldCalculations) { calculation in
                            if let yield = calculation.yield {
                                YieldView(calculation: calculation)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(5)
                    Spacer()
                    
                }
//                .frame(width: geometry.size.width, height: geometry.size.height * 0.90)
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.90)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Apply black color
    }
    
    private func calculateGraphHeight(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.height * 0.45 // Adjust as needed (e.g., 40% of screen height for graph)
    }
    
    private func calculateVerticalPaddingTop(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.height * 0.20 // Adjust as needed (e.g., 10% of screen height for vertical padding)
    }
    
    private func calculateVerticalPaddingBottom(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.height * 0.10 // Adjust as needed (e.g., 10% of screen height for vertical padding)
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
                
                // Calculate yield over 10 years
                let yearsToCalculate: [Int] = [10, 5, 2, 1]
                yieldCalculations = yearsToCalculate.map { years in
                    if let yield = calculateNYearsYield(yearsAgo: years, dataPoints: stockData) {
                        return YieldCalculation(years: years, yield: yield)
                    } else {
                        return YieldCalculation(years: years, yield: nil)
                    }
                }
                
                // Calculate YTD yield
                if let ytdYield = calculateYTDYield(dataPoints: stockData) {
                    yieldCalculations.append(YieldCalculation(years: 0, yield: ytdYield)) // 0 years for YTD
                }
            })
            .store(in: &cancellables) // Store cancellable in @State property
    }
    
    // Function to calculate yield over N years ago
    private func calculateNYearsYield(yearsAgo: Int, dataPoints: [StockDataPoint]) -> Double? {
        guard !dataPoints.isEmpty else { return nil }

        // Calculate date N years ago
        let calendar = Calendar.current
        let currentDate = Date()
        let startDate = calendar.date(byAdding: .year, value: -yearsAgo, to: currentDate)!

        // Find the closest data point to the start date
        guard let closestDataPoint = dataPoints.min(by: { abs($0.date.timeIntervalSince(startDate)) < abs($1.date.timeIntervalSince(startDate)) }) else {
            return nil
        }

        // Calculate yield over N years
        let initialInvestment = 10000.0
        let initialClose = closestDataPoint.adjustedClose
        let finalClose = dataPoints.last?.adjustedClose ?? 0.0 // Use last data point's close as final close

        let yield = (initialInvestment / initialClose) * finalClose
        return yield
    }
    
    private func calculateYTDYield(dataPoints: [StockDataPoint]) -> Double? {
        guard !dataPoints.isEmpty else { return nil }

        // Determine the start date of the current year
        let calendar = Calendar.current
        let currentDate = Date()
        let startOfYear = calendar.startOfDay(for: calendar.date(from: calendar.dateComponents([.year], from: currentDate))!)

        // Find the closest data point to the start of the year
        guard let closestDataPoint = dataPoints.min(by: { abs($0.date.timeIntervalSince(startOfYear)) < abs($1.date.timeIntervalSince(startOfYear)) }) else {
            return nil
        }

        // Calculate yield from start of the year to the most recent data point
        let initialInvestment = 10000.0
        let initialClose = closestDataPoint.adjustedClose
        let finalClose = dataPoints.last?.adjustedClose ?? 0.0 // Use last data point's close as final close

        let yield = (initialInvestment / initialClose) * finalClose
        return yield
    }

}


struct YieldCalculation: Identifiable {
    let id = UUID() // Unique identifier for each instance
    let years: Int
    let yield: Double?
}

struct YieldView: View {
    let calculation: YieldCalculation

    var body: some View {
        if let yield = calculation.yield {
            if calculation.years == 0 {
                // Display YTD yield
                return Text("Calculated Yield on YTD: $\(yield, specifier: "%.2f")")
                    .foregroundColor(.black)
                    .padding()
            } else {
                // Display yield for specified years
                return Text("Calculated Yield on \(calculation.years) Years: $\(yield, specifier: "%.2f")")
                    .foregroundColor(.black)
                    .padding()
            }
        } else {
            // Display failure message for the specified years
            return Text("Failed to calculate yield for \(calculation.years == 0 ? "YTD" : "\(calculation.years) Years")")
                .foregroundColor(.red)
                .padding()
        }
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

