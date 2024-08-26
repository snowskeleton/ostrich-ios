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
//                            playerName: player.safeName,
//                            playerPersonaId: player.personaId ?? "",
                            registeredPlayer: player,
                            event: player.event!
//                            eventName: player.event?.title ?? "",
//                            eventId: player.event?.id ?? "",
//                            formatName: player.event?.eventFormat?.name ?? ""
                        )
                    } label: {
                        HStack {
                            Text(player.safeName)
                            if player.personaId == UserManager.shared.currentUser?.personaId {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        }
    }
}
