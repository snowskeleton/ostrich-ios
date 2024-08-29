//
//  RegisteredPlayersView.swift
//  OSTRich
//
//  Created by snow on 8/8/24.
//


import SwiftUI
import SwiftData

struct RegisteredPlayersView: View {
    @Query var players: [Registration]
    @Query var playerStats: [ScoutingResult]
    
    init(event: Event) {
        let eventId = event.id
        let playersPredicate = #Predicate<Registration> {
            $0.event?.id == eventId
        }
        let playersDescriptor = FetchDescriptor(predicate: playersPredicate)
        _players = Query(playersDescriptor)
        
        let statsPredicate = #Predicate<ScoutingResult> {
            $0.eventId == eventId
        }
        let statsDescriptor = FetchDescriptor(predicate: statsPredicate)
        _playerStats = Query(statsDescriptor)
    }
    var body: some View {
        List {
            Section("Players: \(players.count)") {
                ForEach(players.sorted(by: { $0.safeName < $1.safeName }), id: \.id) { player in
                    NavigationLink {
                        if let matchingScoutingResult = playerStats.first(where: {
                            $0.player?.personaId == player.personaId &&
                            $0.eventId == player.event?.id
                        }) {
                            CreateScoutingResultView(
                                scoutingResult: matchingScoutingResult
                            )
                        } else {
                            CreateScoutingResultView(
                                registeredPlayer: player,
                                event: player.event!
                            )
                        }
                    } label: {
                        HStack {
                            Text(player.safeName)
                            Spacer()
                            if playerStats.contains(where: {
                                $0.player?.personaId == player.personaId &&
                                $0.eventId == player.event?.id
                            }) {
                                Image(systemName: "binoculars")
                            }
                        }
                    }
                }
            }
        }
    }
}
