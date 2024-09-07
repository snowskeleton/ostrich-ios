//
//  ScoutingHistoryAllPlayersView.swift
//  OSTRich
//
//  Created by snow on 8/21/24.
//

import SwiftUI
import SwiftData

struct ScoutingHistoryAllPlayersView: View {
    @State private var isPresented: Bool = true
    
    var stats: [ScoutingResult]
    
    private var players: [LocalPlayer] {
        let uniquePlayers = Array(Set(stats.compactMap { $0.player }))
        return uniquePlayers.sorted { $0.safeName < $1.safeName }
    }
    var body: some View {
        List {
            ForEach(players, id: \.personaId) { player in
                Section(player.safeName) {
                    ScoutingHistoryCollapsableView(player: player)
                }
            }
        }
        .onAppear {
            Analytics.track(.openedScoutingHistoryAllPlayersView)
        }
    }
}
