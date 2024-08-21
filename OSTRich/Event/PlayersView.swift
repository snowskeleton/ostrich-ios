//
//  PlayersView.swift
//  OSTRich
//
//  Created by snow on 8/8/24.
//


import SwiftUI

struct PlayersView: View {
    @Binding var players: [Registration]
    var body: some View {
        List {
            Section("Players: \(players.count)") {
                ForEach(players.sorted(by: { $0.safeName < $1.safeName }), id: \.id) { player in
                    NavigationLink {
                        CreateScoutingResultView(
                            playerName: player.safeName,
                            playerPersonaId: player.personaId ?? "",
                            eventName: player.event?.title ?? "",
                            eventId: player.event?.id ?? ""
                        )
                    } label: {
                        HStack {
                            Text(player.safeName)
                            if player.personaId
                                == UserDefaults.standard.string(
                                    forKey: "personaId")
                            {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        }
    }
}
