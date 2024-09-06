//
//  DeckStatsView.swift
//  OSTRich
//
//  Created by snow on 9/6/24.
//

import SwiftUI
import SwiftData
import Charts

struct DeckStatsView: View {
    @Query var stats: [ScoutingResult]
    var format: String
    var deckName: String
    
    var players: [LocalPlayer] {
        return stats.map { $0.player! }
    }
    init(deckName: String, format: String) {
        let predicate = #Predicate<ScoutingResult> {
            $0.deckName == deckName &&
            $0.format == format
        }
        _stats = Query(filter: predicate, sort: \.date)
        self.format = format
        self.deckName = deckName
    }
    
    var body: some View {
        VStack {
            let groupedStats = Dictionary(grouping: stats) { result in
                Calendar.current.startOfDay(for: result.date)
            }
            
            let sortedStats = groupedStats.keys.sorted().map { date in
                (date, groupedStats[date]?.count ?? 0)
            }
            
            Chart(sortedStats, id: \.0) { date, count in
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
            
            ScoutingHistoryByPlayerView(players: players, format: format)
        }
    }
    
}
