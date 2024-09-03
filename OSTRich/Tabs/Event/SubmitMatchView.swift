//
//  SubmitMatchView.swift
//  OSTRich
//
//  Created by snow on 10/2/23.
//


import SwiftUI
import SwiftData
import RevenueCat
import RevenueCatUI

struct SubmitMatchView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var match: Match
    
    @State private var showProgressView = false
    
    @State private var teamWins: [String: Int] = [:]
    
    @State private var showScoutingResults: Bool = true
    @State private var showPaywall: Bool = false
    @State private var timer: Timer?
    
    private var ableToSubmitMatch: Bool {
        // if we're the TO, we can submit any match regardless of whether or not it's already been submitted
        if match.round.gameState.event?.createdBy == UserManager.shared.currentUser?.personaId {
            Analytics.track(.openedSubmitMatchView, with: ["as": "TO"])
            return true
        }
        // otherwise we can only submit matches that we're in
        if !match.teams.contains(where: { $0.players.contains(
            where: { $0.personaId == UserManager.shared.currentUser?.personaId }
        )}) {
            Analytics.track(.openedSubmitMatchView, with: ["as": "spectator"])
            return false
        }
        Analytics.track(.openedSubmitMatchView, with: ["as": "self"])

        // and that haven't been submitted yet
        return match.results.isEmpty
    }
    
    init(match: Binding<Match>) {
        _match = match
        var initialWins = [String: Int]()
        for team in match.wrappedValue.teams {
            initialWins[team.teamId] = 0
        }
        
        for result in match.results.wrappedValue {
            initialWins[result.teamId] = result.wins
        }
        
        _teamWins = State(initialValue: initialWins)
        _showProgressView = .init(initialValue: false)
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
                    
                    ForEach(match.teams.sorted(by: { $0.teamId < $1.teamId }), id: \.teamId) { team in
                        Section(team.fullName) {
                            Picker(selection: $teamWins[team.teamId], label: Text("Wins")) {
                                Text("0").tag(0)
                                Text("1").tag(1)
                                Text("2").tag(2)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    
                    Section {
                        Button(action: submitMatchResult) {
                            Text("Submit Match Result")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .disabled(!ableToSubmitMatch)
                    }
                }
                
                if showScoutingResults {
                    ForEach(match.teams.sorted(by: { $0.teamId < $1.teamId }), id: \.teamId) { team in
                        ScoutingResultsForTeamView(team: team)
                    }
                } else {
                    VStack {
                        Text("Scouting results are only available to Pro users.")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button {
                            showPaywall = true
                        } label: {
                            Text("Subscribe to Pro")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                        .sheet(isPresented: $showPaywall) {
                            PaywallView()
                        }
                    }
                    .padding()
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
        .onAppear {
            calculatePaywall()
            startPaywallTimer()
        }
    }
    
    private func submitMatchResult() {
        let totalWins = teamWins.values.reduce(0, +)
        var teamResults = [Gamestateschema.TeamResultInputV2]()
        
        for team in match.teams {
            let wins = teamWins[team.teamId]!
            let losses = totalWins - wins // Calculate losses implicitly
            
            let teamResult = Gamestateschema.TeamResultInputV2(
                matchId: match.matchId,
                submitter: UserManager.shared.currentUser?.personaId ?? nil,
                isBye: match.isBye,
                wins: wins,
                losses: losses,
                draws: 0,
                teamId: team.teamId
            )
            
            teamResults.append(teamResult)
        }
        
        showProgressView = true
        saveTeamResultInputs(teamResults)
        showProgressView = false
        dismiss()
    }
    
    private func saveTeamResultInputs(_ teamResults: [Gamestateschema.TeamResultInputV2]) {
        GQLNetwork.shared.submitMatchResults(
            eventId: match.round.gameState.eventId,
            results: teamResults
        ) { result in
            switch result {
            case .success:
                print("Match result submitted successfully")
                Analytics.track(.matchSubmittedWithoutError)
            case .failure(let error):
                Analytics.track(.matchSubmittedWithError, with: ["error": error.localizedDescription])
                print("Failed to submit match result: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func calculatePaywall() {
        Task {
            do {
                let customerInfo = try await Purchases.shared.customerInfo()
                self.showScoutingResults = customerInfo.entitlements["pro"]?.isActive == true ? true : false
            } catch {
                print("\(error)")
            }
        }
    }
    
    private func startPaywallTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if !showScoutingResults {
                calculatePaywall()
            } else {
                stopPaywallTimer()
            }
        }
    }
    
    private func stopPaywallTimer() {
        timer?.invalidate()
        timer = nil
    }

}


