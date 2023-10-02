//
//  SubmitMatchView.swift
//  OSTRich
//
//  Created by snow on 10/2/23.
//


import SwiftUI


struct MatchDetails: Codable {
    let draws: Int
    let eventId: String
    let isBye: Bool
    let leftTeamId: String
    let leftTeamWins: Int
    let rightTeamId: String
    let rightTeamWins: Int
    let matchId: String
}

struct SubmitMatchView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var event: Event
    var match: Match {
        return event.gameStateAtRound!.currentRound!.matches.first { match in
            match.teams.contains { team in
                team.players.contains { player in
                    player.personaId == UserDefaults.standard.string(forKey: "personaId")
                }
            }
        }!
    }
    var player1: User { return match.teams[1].players[0] }
    var player2: User { return match.teams[0].players[0] }
    
    @State private var p1Wins = 0
    @State private var p2Wins = 0
    @State private var draws = "0"
    
    var body: some View {
        Text(String(describing: match.tableNumber!)).fontWeight(.bold)
        Spacer()
        List {
            Section("\(player1.firstName) \(player1.lastName)") {
                Picker(selection: $p1Wins, label: Text("Player 1 wins")) {
                    Text("0").tag(0)
                    Text("1").tag(1)
                    Text("2").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section("\(player2.firstName) \(player2.lastName)") {
                Picker(selection: $p2Wins, label: Text("Player 2 wins")) {
                    Text("0").tag(0)
                    Text("1").tag(1)
                    Text("2").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section("Draws") {
                TextField("Draws", text: $draws).keyboardType(.numberPad)
            }
            Button("Submit") { submitMatch() }
        }
    }
    fileprivate func submitMatch() {
        Task.detached { @MainActor in
            let matchToSubmit = MatchDetails(
                draws: Int(draws) ?? 0,
                eventId: event.id,
                isBye: match.isBye,
                leftTeamId: match.teams[1].id,
                leftTeamWins: p2Wins,
                rightTeamId: match.teams[0].id,
                rightTeamWins: p1Wins,
                matchId: match.id)
            
            switch await HTOService().recordMatchResults(matchDetails: matchToSubmit) {
            case .success:
                event.updateSelf()
                dismiss()
            case .failure(let error):
                print(error)
            }
        }
    }
}
