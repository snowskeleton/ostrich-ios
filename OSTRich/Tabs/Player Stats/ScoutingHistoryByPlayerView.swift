//
//  ScoutingHistoryByPlayerView.swift
//  OSTRich
//
//  Created by snow on 9/6/24.
//


import SwiftUI
import SwiftData
import Charts

struct ScoutingHistoryByPlayerView: View {
    @State var players: [LocalPlayer]
    @State var format: String
    
    var body: some View {
        List(players) { player in
            NavigationLink {
                List {
                    ScoutingHistoryByFormatView(player: player, format: format)
                }
            } label: {
                Text(player.safeName)
                    .font(.body)
            }
            .padding(.vertical, 2)
        }
    }
}
