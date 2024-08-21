//
//  PlayerStatsView.swift
//  OSTRich
//
//  Created by snow on 8/21/24.
//

import SwiftUI
import SwiftData

struct PlayerStatsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \ScoutingResult.id, order: .reverse) private var playerStats: [ScoutingResult]
    
    var body: some View {
        List {
            ForEach(playerStats, id: \.id) { stat in
                VStack(alignment: .leading) {
                    Section("Name") {
                        Text(stat.playerName ?? "")
                            .font(.headline)
                    }
                    
                    Section("Deck Name") {
                        Text(stat.deckName)
                    }
                    
                    Section("Notes") {
                        Text(stat.deckNotes ?? "")
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Player Stats")
        }
    }
}
