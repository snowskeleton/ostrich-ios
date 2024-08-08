//
//  StandingsView.swift
//  OSTRich
//
//  Created by snow on 5/30/24.
//

import SwiftUI

struct TeamStandingView: View {
    let teamStandings: [Standing]
    
    var body: some View {
        Grid {
            GridRow {
                Text("Rank")
                Text("Name")
                Text("W-L-D")
                Text("GW")
                Text("OGW")
                Text("OMW")
            }.font(.title2)
            Divider()
            ForEach(teamStandings, id: \.teamId) { teamStanding in
                GridRow {
                    Text("\(teamStanding.rank).")
                        .font(.headline)
                    Text("\(teamStanding.team.fullName)")
                        .font(.subheadline)
                    Text("\(teamStanding.wins) - \(teamStanding.losses) - \(teamStanding.draws) = \(teamStanding.matchPoints)")
                        .font(.footnote)
                    Text("GW:\n\(String(format: "%.2f", teamStanding.gameWinPercent * 100))%")
                        .font(.footnote)
                    Text("OGW:\n\(String(format: "%.2f", teamStanding.opponentGameWinPercent * 100))%")
                        .font(.footnote)
                    Text("OMW:\n\(String(format: "%.2f", teamStanding.opponentMatchWinPercent * 100))%")
                        .font(.footnote)
                    
                }
            }
            Spacer()
        }
    }
}
