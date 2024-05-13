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
                            
                            VStack(spacing: 10) {
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
                                    
                                
                                
                                VStack {
                                    Text("Investment Amount: $\(Int(investmentAmount))")
                                        .foregroundColor(.white)
                                        .padding(.top, 10) // Add bottom padding to separate from the Slider
                                    
                                    Slider(value: $investmentAmount, in: 1000...100000, step: 1000)
                                        .padding(.horizontal)
                                        .accentColor(.green)
                                }
                                .padding(.top, self.calculatePercentageHeight(geometry: geometry, percentage: 0.70)) // Adjust the top padding
                            }
                        }
                        
                        // Display yield calculations
                        ForEach(yieldCalculations) { calculation in
                            if let yield = calculation.yield {
                                YieldView(calculation: calculation, investmentAmount: investmentAmount)
                            }
                        }
                        .padding(10)
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
            return geometry.size.height * 0.05
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
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }

    var body: some View {
        Group {
            if let yield = calculation.yield {
                let calculatedYield = calculateYield(investmentAmount: investmentAmount, yield: yield)
                let formattedYield = numberFormatter.string(from: NSNumber(value: calculatedYield)) ?? "\(calculatedYield)"
                
                HStack(spacing: 0) {
                    Text(calculation.years == 0 ? "Calculated Yield on YTD: " : "Calculated Yield on \(calculation.years) Years: ")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                        .padding(.vertical, 8)
                        .fixedSize(horizontal: true, vertical: false) // Prevent wrapping
                    
                    Text("$\(formattedYield)")
                        .foregroundColor(calculatedYield >= investmentAmount ? .green : .red)
                        .bold()
                        .font(.system(size: 18))
                        .padding(.vertical, 8)
                        .lineLimit(1) // Limit to one line
                        .fixedSize(horizontal: true, vertical: false) // Prevent wrapping
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity) // Optional: Add a transition effect
            } else {
                Text("Failed to calculate yield for \(calculation.years == 0 ? "YTD" : "\(calculation.years) Years")")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 18))
                    .padding(.vertical, 8)
                    .lineLimit(1) // Limit to one line
                    .fixedSize(horizontal: true, vertical: false) // Prevent wrapping
                    .transition(.opacity) // Optional: Add a transition effect
            }
        }
    }
    
    private func calculateYield(investmentAmount: Double, yield: Double) -> Double {
        return yield * (investmentAmount / 10000.0) // Assuming 10000.0 is the initial investment for yield calculation
    }
}

struct YieldView_Previews: PreviewProvider {
    static var previews: some View {
        YieldView(calculation: YieldCalculation(years: 5, yield: 0.075), investmentAmount: 10000.0)
    }
}



struct StockDataPoint: Equatable {
    var date: Date
    var adjustedClose: Double
    
    // Implement the == function to compare StockDataPoint instances for equality
    static func == (lhs: StockDataPoint, rhs: StockDataPoint) -> Bool {
        // Compare the date and adjustedClose properties for equality
        return lhs.date == rhs.date && lhs.adjustedClose == rhs.adjustedClose
    }
}


extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

