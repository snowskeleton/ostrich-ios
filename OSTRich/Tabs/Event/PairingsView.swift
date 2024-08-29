//
//  PairingsView.swift
//  OSTRich
//
//  Created by snow on 8/8/24.
//


import SwiftUI
import SwiftData

struct PairingsView: View {
    @Environment(\.modelContext) private var context

    @Query var matches: [Match]
    
    init(from gameStateId: UUID) {
        let predicate = #Predicate<Match> {
            $0.round.gameState.id == gameStateId
        }
        let resultDescriptor = FetchDescriptor<Match>(predicate: predicate, sortBy: [SortDescriptor(\.matchId)])
        _matches = Query(resultDescriptor)
    }
    
    var myMatch: Match? {
        return matches.first { match in
            match.teams.contains { team in
                team.players.contains { player in
                    player.personaId == UserManager.shared.currentUser?.personaId
                }
            }
        }
    }
    
    var body: some View {
        List {
            if myMatch != nil {
                Section("My Match") {
                    NavigationLink {
                        SubmitMatchView(match: Binding<Match>.constant(myMatch!))
                    } label: {
                        PairingItem(match: myMatch!)
                    }
                }
            }
            Section("All Matches") {
                ForEach(matches, id: \.matchId) { match in
                    NavigationLink {
                        SubmitMatchView(match: Binding<Match>.constant(match))
                    } label: {
                        PairingItem(match: match)
                    }
                }
            }
        }
    }
}


struct PairingItem: View {
    
    @Query var teams: [Team]
    @Query var matchResults: [MatchResult]
    var match: Match
    
    
    private var sortedTeams: [Team] {
        let teamIds = match.teamIds
        return teams.filter { teamIds.contains($0.teamId) }
            .sorted(by: { teamIds.firstIndex(of: $0.teamId)! < teamIds.firstIndex(of: $1.teamId)! })
    }
    
    private func wins(for team: Team) -> Int {
        if let result = matchResults.first(where: { $0.teamId == team.teamId }) {
            return result.wins
        }
        return 0
    }
    
//    private func losses(for team: Team) -> Int {
//        if let result = matchResults.first(where: { $0.teamId == team.teamId }) {
//            return result.losses
//        }
//        return 0
//    }
    
    init(match: Match) {
        self.match = match
        
        // Query for teams
        let matchGameStateId = match.round.gameState.id
        let matchTeamIds = match.teamIds
        let teamPredicate = #Predicate<Team> {
            $0.gameState.id == matchGameStateId  &&
            matchTeamIds .contains($0.teamId)
        }
        let teamDescriptor = FetchDescriptor<Team>(predicate: teamPredicate, sortBy: [SortDescriptor(\.teamId)])
        _teams = Query(teamDescriptor)
        
        // Query for match results
        let matchId = match.matchId
        let resultPredicate = #Predicate<MatchResult> {
            $0.matchId == matchId
        }
        let resultDescriptor = FetchDescriptor<MatchResult>(predicate: resultPredicate)
        _matchResults = Query(resultDescriptor)
    }
    
    var body: some View {
        
        HStack {
            if match.isBye {
                Text("Bye")
            } else {
                Text("Table: \(match.tableNumber ?? 0)")
            }
            Spacer()
            
            VStack {
                ForEach(sortedTeams, id: \.teamId) { team in
                    HStack {
                        Spacer()
                        Text(team.fullName)
                        Spacer()
                        if !matchResults.isEmpty {
                            Text(String(wins(for: team)))
                        }
                    }
                    if team != sortedTeams.last {
                        Text("vs.")
                    }
                }
            }
        }
    }
}
