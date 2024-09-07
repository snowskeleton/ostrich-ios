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

    @State private var selectedPlayer: LocalPlayer?
    
    var chartTitle: String {
        if let selectedPlayer = selectedPlayer {
            return selectedPlayer.safeName
        } else {
            return "All Players"
        }
    }
    
    var players: [(player: LocalPlayer, lastPlayed: Date)] {
        let uniquePlayers = Set(stats.compactMap { $0.player })
        return uniquePlayers.map { player in
            let lastPlayedDate = stats.filter { $0.player == player }
                .max(by: { $0.date < $1.date })?.date
            return (player: player, lastPlayed: lastPlayedDate ?? Date.distantPast)
        }
        .sorted {
            $0.lastPlayed > $1.lastPlayed &&
            $0.player.safeName < $1.player.safeName
        }
    }

    var filteredStats: [ScoutingResult] {
        if let player = selectedPlayer {
            return stats.filter { $0.player == player }
        }
        return stats
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
            let groupedStats = Dictionary(grouping: filteredStats) { result in
                Calendar.current.startOfDay(for: result.date)
            }
            
            let sortedStats = groupedStats.keys.sorted().map { date in
                (date, groupedStats[date]?.count ?? 0)
            }
            
            Text(chartTitle)
            
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
            
            List(players, id: \.player) { player, lastPlayed in
                HStack {
                    Text(player.safeName)
                    Spacer()
                    Text(lastPlayed, style: .date)
                }
                .contentShape(Rectangle())
                .background(selectedPlayer == player ? Color.blue.opacity(0.2) : Color.clear)
                .foregroundColor(selectedPlayer == player ? Color.blue : Color.primary)
                .onTapGesture {
                    if selectedPlayer == player {
                        selectedPlayer = nil // Deselect player
                    } else {
                        selectedPlayer = player // Select player
                    }
                }
            }
        }
    }
}
