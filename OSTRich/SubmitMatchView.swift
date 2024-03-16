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
    @State var match: Match
//    var match: Match {
//        return event.gameStateAtRound!.currentRound!.matches.first { match in
//            match.teams.contains { team in
//                team.players.contains { player in
//                    player.personaId == UserDefaults.standard.string(forKey: "personaId")
//                }
//            }
//        }!
//    }
    var player1: User { return match.teams[1].players[0] }
    var player2: User { return match.teams[0].players[0] }
    
    @State private var leftTeamWins: Int
    @State private var rightTeamWins: Int
    @State private var ableToSubmitMatch = true
    
    init(event: Event) {
        self.event = event
        let someMatch = event.gameStateAtRound!.currentRound!.matches.first { match in
            match.teams.contains { team in
                team.players.contains { player in
                    player.personaId == UserDefaults.standard.string(forKey: "personaId")
                }
            }
        }!
        _match = State(initialValue: someMatch)
        if someMatch.leftTeamWins != nil && someMatch.rightTeamWins != nil {
            _leftTeamWins = State(initialValue: someMatch.leftTeamWins!)
            _rightTeamWins = State(initialValue: someMatch.rightTeamWins!)
            _ableToSubmitMatch = State(initialValue: false)
        } else {
            _leftTeamWins = State(initialValue: 0)
            _rightTeamWins = State(initialValue: 0)
        }
//        _leftTeamWins = State(initialValue: someMatch.leftTeamWins != nil ? someMatch.leftTeamWins! : 0)
//        _rightTeamWins = State(initialValue: someMatch.rightTeamWins != nil ? someMatch.rightTeamWins! : 0)
//        self.leftTeamWins = match.leftTeamWins != nil ? match.leftTeamWins! : leftTeamWins
//        self.rightTeamWins = match.rightTeamWins != nil ? match.rightTeamWins! : rightTeamWins
    }
    
    var body: some View {
        Text(String(describing: match.tableNumber!)).fontWeight(.bold)
        Spacer()
        List {
            Section("\(player1.firstName) \(player1.lastName)") {
                Picker(selection: $leftTeamWins, label: Text("Player 1 wins")) {
                    Text("0").tag(0)
                    Text("1").tag(1)
                    Text("2").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section("\(player2.firstName) \(player2.lastName)") {
                Picker(selection: $rightTeamWins, label: Text("Player 2 wins")) {
                    Text("0").tag(0)
                    Text("1").tag(1)
                    Text("2").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
            }
            Button("Submit") { submitMatch() }.disabled(ableToSubmitMatch)
        }
    }
    fileprivate func submitMatch() {
        Task.detached { @MainActor in
            let matchToSubmit = MatchDetails(
                draws: 0,
                eventId: event.id,
                isBye: match.isBye,
                leftTeamId: match.teams[1].id,
                leftTeamWins: leftTeamWins,
                rightTeamId: match.teams[0].id,
                rightTeamWins: rightTeamWins,
                matchId: match.id)
            
            switch await HTOService().recordMatchResults(matchDetails: matchToSubmit) {
            case .success:
                await event.updateSelf()
                dismiss()
            case .failure(let error):
                print(error)
            }
        }
    }
}
