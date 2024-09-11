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
        data.map { ($0.key, $0.value) }.sorted { $0.name > $1.name }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            Chart {
                ForEach(chartData, id: \.name) { item in
                    BarMark(
                        x: .value("Count", item.count),
                        y: .value("Deck Name", item.name)
                    )
                    .foregroundStyle(Color.blue)
                }
            }
            .chartXAxis {
                AxisMarks(position: .top)
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: CGFloat(chartData.count * 40))
            .padding()
        }
    }
}
