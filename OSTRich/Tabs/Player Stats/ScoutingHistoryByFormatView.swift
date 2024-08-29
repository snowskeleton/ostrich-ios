//
//  ScoutingHistoryForPlayerView.swift
//  OSTRich
//
//  Created by snow on 8/24/24.
//


import SwiftUI
import SwiftData

struct ScoutingHistoryByFormatView: View {
    @Environment(\.modelContext) private var context

    @Query var playerStats: [ScoutingResult]
    private var format: String

    init(player: Player, format: String, fetchLimit: Int = 0) {
        let localPlayer = LocalPlayer.createOrUpdate(from: player)
        self.init(player: localPlayer, format: format, fetchLimit: fetchLimit)
    }
    
    init(player: LocalPlayer, format: String, fetchLimit: Int = 0) {
        self.format = format
        
        let searchPersona = player.personaId!
        let predicate = #Predicate<ScoutingResult> {
            $0.player?.personaId == searchPersona &&
            $0.format == format
        }
        var descriptor = FetchDescriptor<ScoutingResult>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date)]
        )
        descriptor.fetchLimit = fetchLimit
        _playerStats = Query(descriptor)
    }
    
    var body: some View {
        ForEach(playerStats, id: \.id) { stat in
            NavigationLink {
                CreateScoutingResultView(scoutingResult: stat)
            } label: {
                HStack {
                    Text(stat.deckName)
                    Spacer()
                    Text(stat.date, style: .date)
                }
            }
        }
    }
}
