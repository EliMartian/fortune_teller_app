//
//  SecurityRatingView.swift
//  Fortune Teller
//
//  Created by E Martin on 4/25/24.
//

import Foundation

struct SecurityRatingView {
    
    // Finds the closest entry in the API week list based upon a provided year, month, and date.
    // Returns: The index of the closest entry in the API response to the given date.
    static func findEntry(year: Int, month: Int, day: Int, response: [StockDataPoint]) -> Int? {

        var minIndex: Int?
        var minDifference = Double.infinity

        for (index, dataPoint) in response.enumerated() {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: dataPoint.date)

            guard let dataYear = components.year,
                  let dataMonth = components.month,
                  let dataDay = components.day else {
                continue
            }

            if dataYear == year && dataMonth == month {
                let dayDifference = abs(dataDay - day)

                // Check if the day is within 7 days of the requested day
                if dataDay >= day || (day > dataDay && dayDifference <= 7) {
                    let weekDifference = abs(Double(dataDay) / 7.0 - Double(day) / 7.0)

                    if weekDifference < minDifference {
                        minDifference = weekDifference
                        minIndex = index
                    }
                }
            }
        }

        return minIndex
    }

}
