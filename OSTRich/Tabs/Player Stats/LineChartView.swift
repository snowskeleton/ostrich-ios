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
        let groupedStats = Dictionary(grouping: stats) { result in
            Calendar.current.startOfDay(for: result.date)
        }
        
        return groupedStats.keys.sorted().map { date in
            (date, groupedStats[date]?.count ?? 0)
        }
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
