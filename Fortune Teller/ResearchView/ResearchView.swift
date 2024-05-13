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
    @State private var investmentAmount: Double = 10000.0 // Initial investment amount
    @State private var showSlider: Bool = false
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    ZStack {
                        Color.black.edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 20) {
                            TextField("Enter Stock Symbol", text: $ticker)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            Button("Search") {
                                if !ticker.isEmpty {
                                    doResearch()
                                    showSlider = true // Show slider after search
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        
                        if !stockData.isEmpty {
                            SecurityGraphView(stockData: stockData, ticker: ticker)
                                .frame(height: self.calculateGraphHeight(geometry: geometry))
                                .padding(.top, self.calculateVerticalPaddingTop(geometry: geometry))
                                .padding(.bottom, self.calculateVerticalPaddingBottom(geometry: geometry))
                                .clipped()
                        }
                        
                        if showSlider {
                            VStack {
                                Text("Investment Amount: $\(Int(investmentAmount))")
                                    .foregroundColor(.white)
                                    .padding(.bottom, 10) // Add bottom padding to separate from the Slider
                                
                                Slider(value: $investmentAmount, in: 1000...100000, step: 1000)
                                    .padding(.horizontal)
                                    .accentColor(.green)
                            }
                            .padding(.top, self.calculatePercentageHeight(geometry: geometry, percentage: 0.65)) // Adjust the top padding
                        }
                    }
                    
                    // Display yield calculations
                    ForEach(yieldCalculations) { calculation in
                        if let yield = calculation.yield {
                            YieldView(calculation: calculation, investmentAmount: investmentAmount)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(5)
                    
                    Spacer() // Add Spacer to push content to the top
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height * 0.90)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    private func calculatePercentageHeight(geometry: GeometryProxy, percentage: CGFloat) -> CGFloat {
        return geometry.size.height * percentage
    }

    private func calculateGraphHeight(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.height * 0.45
    }
    
    private func calculateVerticalPaddingTop(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.height * 0.20
    }
    
    private func calculateVerticalPaddingBottom(geometry: GeometryProxy) -> CGFloat {
        return geometry.size.height * 0.10
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
                guard let res = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let timeSeries = res["Weekly Adjusted Time Series"] as? [String: [String: String]] else {
                    throw NSError(domain: "Invalid JSON", code: 0, userInfo: nil)
                }
                
                var dataPoints: [StockDataPoint] = []
                for (dateString, priceData) in timeSeries {
                    if let adjustedClose = Double(priceData["5. adjusted close"] ?? "0.0"),
                       let date = DateFormatter.iso8601.date(from: dateString) {
                        dataPoints.append(StockDataPoint(date: date, adjustedClose: adjustedClose))
                    }
                }
                dataPoints.sort { $0.date < $1.date }
                
                return dataPoints
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    errorMessage = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { response in
                stockData = response
                
                let yearsToCalculate: [Int] = [10, 5, 2, 1]
                yieldCalculations = yearsToCalculate.map { years in
                    if let yield = calculateNYearsYield(yearsAgo: years, dataPoints: stockData) {
                        return YieldCalculation(years: years, yield: yield)
                    } else {
                        return YieldCalculation(years: years, yield: nil)
                    }
                }
                
                if let ytdYield = calculateYTDYield(dataPoints: stockData) {
                    yieldCalculations.append(YieldCalculation(years: 0, yield: ytdYield))
                }
            })
            .store(in: &cancellables)
    }
    
    private func calculateNYearsYield(yearsAgo: Int, dataPoints: [StockDataPoint]) -> Double? {
        guard !dataPoints.isEmpty else { return nil }

        let calendar = Calendar.current
        let currentDate = Date()
        let startDate = calendar.date(byAdding: .year, value: -yearsAgo, to: currentDate)!

        guard let closestDataPoint = dataPoints.min(by: { abs($0.date.timeIntervalSince(startDate)) < abs($1.date.timeIntervalSince(startDate)) }) else {
            return nil
        }

        let initialInvestment = investmentAmount
        let initialClose = closestDataPoint.adjustedClose
        let finalClose = dataPoints.last?.adjustedClose ?? 0.0

        let yield = (initialInvestment / initialClose) * finalClose
        return yield
    }
    
    private func calculateYTDYield(dataPoints: [StockDataPoint]) -> Double? {
        guard !dataPoints.isEmpty else { return nil }

        let calendar = Calendar.current
        let currentDate = Date()
        let startOfYear = calendar.startOfDay(for: calendar.date(from: calendar.dateComponents([.year], from: currentDate))!)

        guard let closestDataPoint = dataPoints.min(by: { abs($0.date.timeIntervalSince(startOfYear)) < abs($1.date.timeIntervalSince(startOfYear)) }) else {
            return nil
        }

        let initialInvestment = investmentAmount
        let initialClose = closestDataPoint.adjustedClose
        let finalClose = dataPoints.last?.adjustedClose ?? 0.0

        let yield = (initialInvestment / initialClose) * finalClose
        return yield
    }
}

struct YieldCalculation: Identifiable {
    let id = UUID()
    let years: Int
    let yield: Double?
}

struct YieldView: View {
    let calculation: YieldCalculation
    let investmentAmount: Double

    var body: some View {
        if let yield = calculation.yield {
            if calculation.years == 0 {
                return Text("Calculated Yield on YTD: $\(calculateYield(investmentAmount: investmentAmount, yield: yield), specifier: "%.2f")")
                    .foregroundColor(.black)
                    .padding()
            } else {
                return Text("Calculated Yield on \(calculation.years) Years: $\(calculateYield(investmentAmount: investmentAmount, yield: yield), specifier: "%.2f")")
                    .foregroundColor(.black)
                    .padding()
            }
        } else {
            return Text("Failed to calculate yield for \(calculation.years == 0 ? "YTD" : "\(calculation.years) Years")")
                .foregroundColor(.red)
                .padding()
        }
    }
    
    private func calculateYield(investmentAmount: Double, yield: Double) -> Double {
        return yield * (investmentAmount / 10000.0) // Assuming 10000.0 is the initial investment for yield calculation
    }
}

struct StockDataPoint {
    var date: Date
    var adjustedClose: Double
}

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
