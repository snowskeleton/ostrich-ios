//
//  BarChartView.swift
//  OSTRich
//
//  Created by snow on 9/7/24.
//


import SwiftUI
import Charts

struct BarChartView: View {
    var stats: [ScoutingResult]
    
    var data: [String: Int] {
        let deckCounts = stats
            .map { $0.deckName }
            .reduce(into: [String: Int]()) { counts, deck in
                counts[deck, default: 0] += 1
            }
        return deckCounts
    }
    
    private var chartData: [(name: String, count: Int)] {
        data.map { ($0.key, $0.value) }
    }
    
    var body: some View {
        VStack {
            Chart {
                ForEach(chartData, id: \.name) { item in
                    BarMark(
                        x: .value("Deck Name", item.name),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(Color.blue)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
            .padding()
        }
    }
}
