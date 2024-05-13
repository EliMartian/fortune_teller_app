//
//  SecurityGraphView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/6/24.
//

import Foundation
import SwiftUI

struct SecurityGraphView: View {
    var stockData: [StockDataPoint]
    var ticker: String // Ticker symbol

    @State private var selectedOptionIndex = 0 // Index for selected option (e.g., 0 for 10 years, 1 for 5 years)
    private let optionRanges = [120, 60, 36, 24, 12, 6, 3, 1, 0.25] // Number of months for each option (e.g., 10 years = 120 months)

    @State private var isHovering = false
    @State private var hoveredDataPoint: StockDataPoint?

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(ticker.uppercased()) // Display ticker symbol as title in all caps

                if !stockData.isEmpty {
                    GraphContent(stockData: filteredStockData(), geometry: geometry, isHovering: $isHovering, hoveredDataPoint: $hoveredDataPoint)
                        .padding(.bottom, 50) // Add bottom padding to make space for the overlay
                } else {
                    Text("No security data available")
                        .foregroundColor(.gray)
                        .padding()
                }

                Picker(selection: $selectedOptionIndex, label: Text("Select Option")) {
                    Text("10Y").tag(0)
                    Text("5Y").tag(1)
                    Text("3Y").tag(2)
                    Text("2Y").tag(3)
                    Text("1Y").tag(4)
                    Text("6M").tag(5)
                    Text("3M").tag(6)
                    Text("1M").tag(7)
                    Text("1W").tag(8)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
            .overlay(
                hoveredDataView(geometry: geometry) // Pass geometry to the overlay
                    .opacity(isHovering ? 1.0 : 0.0) // Show/hide the overlay based on hover state
                    .animation(.easeInOut(duration: 0.2)) // Apply animation to the opacity change
                    .frame(width: geometry.size.width, height: 50, alignment: .top) // Set frame size and alignment
                    .offset(y: -0.35 * geometry.size.width) // Adjust vertical offset as needed
            )
        }
    }
    
    private func filteredStockData() -> [StockDataPoint] {
            guard selectedOptionIndex < optionRanges.count else {
                return stockData
            }

            let maxMonths = optionRanges[selectedOptionIndex]
            let currentDate = Date()
            var startDate: Date?
            
            if (maxMonths >= 1 && maxMonths <= 120) {
                // Calculate the start date by subtracting maxMonths from the current date
                startDate = Calendar.current.date(byAdding: .month, value: -Int(maxMonths), to: currentDate)
            } else if (maxMonths == 0.25) {
                startDate = Calendar.current.date(byAdding: .day, value: -Int(7), to: currentDate)
            } else {
                // Handle invalid maxMonths value (out of range)
                print("Error: Invalid value for maxMonths.")
                return []
            }
        
            guard let validStartDate = startDate else {
                    print("Error: Failed to calculate start date.")
                    return []
            }
            

            // Get the year, month, and day components of the start date
            let startComponents = Calendar.current.dateComponents([.year, .month, .day], from: validStartDate)
            guard let startYear = startComponents.year,
                  let startMonth = startComponents.month,
                  let startDay = startComponents.day else {
                print("Error: Failed to extract start date components.")
                return []
            }

            // Find the start index using SecurityRatingView.findEntry
            let startIndex = SecurityRatingView.findEntry(year: startYear, month: startMonth, day: startDay, response: stockData)
            guard let validStartIndex = startIndex else {
                print("Error: Start index not found.")
                return []
            }

            // Filter stockData based on the start index
            let filteredStockData = Array(stockData[validStartIndex..<stockData.count])
            print("filteredStockData")
            print(filteredStockData)

            return filteredStockData
        }




    private func hoveredDataView(geometry: GeometryProxy) -> some View {
        if let dataPoint = hoveredDataPoint {
            let formattedDateString = formattedDate(dataPoint.date) // Use formattedDate directly

            return AnyView(
                VStack {
                    Text("Date: \(formattedDateString)")
                    Text("Adjusted Close: $\(String(format: "%.2f", dataPoint.adjustedClose))")
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(5)
                .shadow(radius: 5)
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func extractDateComponents(_ date: Date) -> [Int] {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        return [Int(year), Int(month), Int(day)]
    }

}

struct GraphContent: View {
    var stockData: [StockDataPoint]
    var geometry: GeometryProxy
    @Binding var isHovering: Bool
    @Binding var hoveredDataPoint: StockDataPoint?

    var body: some View {
        ZStack(alignment: .topLeading) {
            graphPath
            dataPointCircles
        }
        .frame(height: 200)
        .padding()
    }

    private var graphPath: some View {
        Path { path in
            for (index, dataPoint) in stockData.enumerated() {
                let x = CGFloat(index) / CGFloat(stockData.count - 1) * (geometry.size.width - 20)
                let y = normalizedY(for: dataPoint.adjustedClose, in: geometry)

                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        .stroke(Color.green, lineWidth: 2)
    }

    private var dataPointCircles: some View {
        ForEach(stockData.indices, id: \.self) { index in
            if index < stockData.count {
                let dataPoint = stockData[index]
                let x = CGFloat(index) / CGFloat(stockData.count - 1) * (geometry.size.width - 20)
                let y = normalizedY(for: dataPoint.adjustedClose, in: geometry)

                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                    .position(x: x, y: y)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                hoveredDataPoint = dataPoint
                                isHovering = true
                            }
                    )
            }
        }
    }

    private func normalizedY(for value: Double, in geometry: GeometryProxy) -> CGFloat {
        guard let maxValue = stockData.map({ $0.adjustedClose }).max() else {
            return 0
        }
        let padding: CGFloat = 50 // Adjust padding as needed
        let scaledValue = CGFloat(value / maxValue) * (geometry.size.height - 2 * padding)
        return geometry.size.height - scaledValue - padding
    }
}
