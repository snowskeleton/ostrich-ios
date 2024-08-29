//
//  RegisteredPlayersView.swift
//  OSTRich
//
//  Created by snow on 8/8/24.
//


import SwiftUI

struct RegisteredPlayersView: View {
    @Binding var players: [Registration]
    var body: some View {
        List {
            Section("Players: \(players.count)") {
                ForEach(players.sorted(by: { $0.safeName < $1.safeName }), id: \.id) { player in
                    NavigationLink {
                        CreateScoutingResultView(
                            registeredPlayer: player,
                            event: player.event!
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
