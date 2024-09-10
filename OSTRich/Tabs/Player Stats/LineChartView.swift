//
//  LineChartView.swift
//  OSTRich
//
//  Created by snow on 9/7/24.
//


import SwiftUI
import Charts

struct LineChartView: View {
    var stats: [ScoutingResult]
    
    private var sortedStats: [(date: Date, count: Int)] {
        // Group stats by day
        let groupedStats = Dictionary(grouping: stats) { result in
            Calendar.current.startOfDay(for: result.date)
        }
        
        // Sort the dates
        let sortedDates = groupedStats.keys.sorted()
        
        // Initialize result array
        var result: [(date: Date, count: Int)] = []
        
        // Iterate through the sorted dates, checking for gaps > 7 days
        for (index, date) in sortedDates.enumerated() {
            // Get the count for this date
            let count = groupedStats[date]?.count ?? 0
            
            // Add the current day to the result
            result.append((date, count))
            
            // If there's a next date, check the gap
            if index < sortedDates.count - 1 {
                let nextDate = sortedDates[index + 1]
                let gap = Calendar.current.dateComponents([.day], from: date, to: nextDate).day ?? 0
                
                // If the gap is greater than 7 days, fill with 0-count entries
                if gap > 7 {
                    // Create an entry 7 days after the current date, with count 0
                    let gapFillerDate = Calendar.current.date(byAdding: .day, value: 7, to: date)!
                    result.append((gapFillerDate, 0))
                }
            }
        }
        
        return result
    }
    
    var body: some View {
        Chart(sortedStats, id: \.date) { date, count in
            LineMark(
                x: .value("Date", date, unit: .day),
                y: .value("Decks Played", count)
            )
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 7)) { value in
                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .padding()
    }
}
