//
//  SubmitMatchView.swift
//  OSTRich
//
//  Created by snow on 10/2/23.
//


import SwiftUI


struct SubmitMatchView: View {
    @State var match: Match
    
    @State private var wins: Int = 0
    @State private var losses: Int = 0
    
    @State private var showProgressView = false

    private var ableToSubmitMatch: Bool {
        match.results.isEmpty
    }
    
    var body: some View {
        VStack {
            Form {
                
                if UserDefaults.standard.bool(forKey: "showDebugValues") {
                    Text(
                        "Match ID: \(match.matchId)\nRound ID: \(match.round.roundId)"
                    )
                }
                if match.isBye {
                    Text("Goodbye!")
                } else {
                    
                    Section(match.myTeam!.fullName) {
                        Picker(selection: $wins, label: Text("Your wins")) {
                            Text("0").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(match.myOpponentTeams.first!.fullName) {
                        Picker(
                            selection: $losses,
                            label: Text("Opponent wins")
                        ) {
                            Text("0").tag(0)
                            Text("1").tag(1)
                            Text("2").tag(2)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section {
                        Button(action: submitMatchResult) {
                            Text("Submit Match Result")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .disabled(!ableToSubmitMatch)
                        }
                    }
                }
                
            }
            .navigationTitle("Submit Match Result")
        }
        .overlay {
            if showProgressView {
                ProgressView()
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
                    .background(Color.gray)
                    .opacity(0.5)
            }
        }
    }
    
    private func submitMatchResult() {
        guard let team = match.myTeam else {
            return
        }
        
        let matchResult = Gamestateschema.TeamResultInputV2(
            matchId: match.matchId,
            //            submitter: "User", //  blank unless submitted by the TO
            isBye: false, // if isBye, then match is auto submitted when the round is started and we never get here
            wins: wins,
            losses: losses,
            draws: 0, // draws don't matter. We decide based on first to 2 wins, not best out of 3
            teamId: team.teamId
        )
        
        showProgressView = true
        saveTeamResultInput(matchResult)
        showProgressView = false
    }
    
    private func saveTeamResultInput(
        _ teamResultInput: Gamestateschema.TeamResultInputV2
    ) {
        let results = [teamResultInput]
        Network.shared.submitMatchResults(
            eventId: match.round.gameState.eventId,
            results: results
        ) { result in
            switch result {
            case .success:
                print("Match result submitted successfully")
            case .failure(let error):
                print(
                    "Failed to submit match result: \(error.localizedDescription)"
                )
            }
        }
    }
}
