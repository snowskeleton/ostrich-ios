//
//  PairingsView.swift
//  OSTRich
//
//  Created by snow on 8/8/24.
//


import SwiftUI
import SwiftData

struct PairingsView: View {
    @Binding var matches: [Match]
    
    var myMatch: Match? {
        return matches.first { match in
            match.teams.contains { team in
                team.players.contains { player in
                    player.personaId == UserDefaults.standard.string(forKey: "personaId")!
                }
            }
        }
    }

    var body: some View {
        List {
            if myMatch != nil {
                Section("My Match") {
                    NavigationLink {
                        SubmitMatchView(match: myMatch!)
                    } label: {
                        PairingItem(match: Binding<Match>.constant(myMatch!))
                    }
                }
            }
            Section("All Matches") {
                ForEach(matches, id: \.matchId) { match in
                    PairingItem(match: Binding<Match>.constant(match))
                }
            }
        }
    }
}


struct PairingItem: View {
    @Binding var match: Match
    
    var firstTeam: Team {
        match.teams.first!
    }
    
    var lastTeam: Team {
        match.teams.last!
    }
    
    var firstTeamWins: Int {
        let result = match.results.first!
        if result.teamId == firstTeam.teamId {
            return result.wins
        } else {
            return result.losses
        }
    }
    var lastTeamWins: Int {
        let result = match.results.first!
        if result.teamId == firstTeam.teamId {
            return result.losses
        } else {
            return result.wins
        }
    }

    var body: some View {
        
        HStack {
            if match.isBye {
                Text("Bye")
            } else {
                Text("Table: \(match.tableNumber!)")
            }
            Spacer()
            
            VStack {
                
                HStack {
                    Spacer()
                    Text(firstTeam.fullName)
                    Spacer()
                    if !match.results.isEmpty {
                        Text(String(firstTeamWins))
                    }
                }
                
                if !match.isBye {
                    Text("vs.")
                    
                    HStack {
                        Spacer()
                        Text(lastTeam.fullName)
                        Spacer()
                        if !match.results.isEmpty {
                            Text(String(lastTeamWins))
                        }
                    }
                }
            }
        }
    }
}
