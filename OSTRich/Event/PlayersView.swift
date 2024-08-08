//
//  PlayersView.swift
//  OSTRich
//
//  Created by snow on 8/8/24.
//


import SwiftUI

struct PlayersView: View {
    @State var event: Event
    var body: some View {
        List {
            Section("Players: \(event.registeredPlayers.count)") {
                ForEach(event.registeredPlayers.sorted(by: { $0.safeName < $1.safeName }), id: \.id) { player in
                    VStack {
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
