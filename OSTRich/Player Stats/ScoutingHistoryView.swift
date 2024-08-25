//
//  ScoutingHistory.swift
//  OSTRich
//
//  Created by snow on 8/21/24.
//

import SwiftUI
import SwiftData

struct ScoutingHistoryAllPlayersView: View {
    @Environment(\.modelContext) private var context
    @Query var players: [LocalPlayer]

    init() {
        let predicate = #Predicate<LocalPlayer> { !$0.stats.isEmpty }
        let descriptor = FetchDescriptor<LocalPlayer>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.firstName)]
        )
        _players = Query(descriptor)
    }

    var body: some View {
        List {
            ForEach(players, id: \.personaId) { player in
                Section(player.safeName) {
                    ScoutingHistoryCollapsableView(player: player)
                }
            }
        }
    }
}
