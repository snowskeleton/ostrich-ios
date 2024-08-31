//
//  EventHeaderView.swift
//  OSTRich
//
//  Created by snow on 8/31/24.
//


import SwiftUI
import SwiftData

struct EventHeaderView: View {
    @Binding var event: Event
    
    var body: some View {
        Text(event.title)
            .font(.title)
            .bold()
            .padding(4)
        HStack {
            Spacer()
            VStack {
                Text("Round")
                    .font(.title3)
                Text((event.gameStateAtRound?.currentRoundNumber.description) ?? "0")
            }
            Spacer()
            if let timer = event.gameStateAtRound?.currentRound?.timer {
                VStack {
                    Text("Timer")
                    RoundTimerView(timer: timer)
                        .font(.title)
                        .bold()
                }
            }
            Spacer()
        }
        
        if UserDefaults.standard.bool(forKey: "showDebugValues") {
            if let round = event.gameStateAtRound?.currentRound {
                Text("Round ID: \(round.roundId)")
            }
        }
    }
}
