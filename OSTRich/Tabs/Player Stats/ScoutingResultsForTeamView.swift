//
//  ScoutingResultsForTeamView.swift
//  OSTRich
//
//  Created by snow on 8/25/24.
//


import SwiftUI
import SwiftData

struct ScoutingResultsForTeamView: View {
    @State var team: Team
    var body: some View {
        List {
            ForEach(team.players, id: \.personaId) { player in
                if let event = player.team?.gameState?.event {
                    Section(player.safeName) {
                        ScoutingHistoryByFormatView(
                            player: player,
                            format: event.eventFormat?.name ?? "Other",
                            fetchLimit: 5
                        )
                        NavigationLink {
                            CreateScoutingResultView(
                                playingPlayer: player,
                                event: event
                            )
                        } label: {
                            Text("New...")
                        }
                    }
                }
            }
        }
    }
}
