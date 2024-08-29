//
//  StandingsView.swift
//  OSTRich
//
//  Created by snow on 5/30/24.
//

import SwiftUI
import SwiftData

struct StandingsView: View {
    @Environment(\.modelContext) private var context

    @Query var teamStandings: [Standing]
    
    init(event: Event) {
        let currentRoundId = event.gameStateAtRound?.currentRound?.roundId
        let predicate = #Predicate<Standing> {
            $0.round.roundId == currentRoundId ?? ""
        }
        let descriptor = FetchDescriptor<Standing>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.rank)]
        )
        _teamStandings = Query(descriptor)
        
    }
    
    var body: some View {
        ScrollView {
            Grid {
                GridRow {
                    Text("Rank")
                    Text("Name")
                    Text("W-L-D")
                    //                Text("GW")
                    //                Text("OGW")
                    Text("OMW")
                }.font(.title2)
                Divider()
                ForEach(teamStandings, id: \.teamId) { teamStanding in
                    GridRow {
                        Text("\(teamStanding.rank).")
                            .font(.headline)
                        Text("\(teamStanding.team.fullName)")
                            .font(.subheadline)
                        Text("\(teamStanding.wins)-\(teamStanding.losses)-\(teamStanding.draws)")
                            .font(.footnote)
                        //                    Text("GW:\n\(String(format: "%.2f", teamStanding.gameWinPercent * 100))%")
                        //                        .font(.footnote)
                        //                    Text("OGW:\n\(String(format: "%.2f", teamStanding.opponentGameWinPercent * 100))%")
                        //                        .font(.footnote)
                        Text("\(String(format: "%.2f", teamStanding.opponentMatchWinPercent * 100))%")
                            .font(.footnote)
                        
                    }
                }
                Spacer()
            }
        }
    }
}
