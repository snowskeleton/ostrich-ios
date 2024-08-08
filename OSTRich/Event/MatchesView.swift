//
//  MatchesView.swift
//  OSTRich
//
//  Created by snow on 8/8/24.
//


import SwiftUI

struct MatchesView: View {
    @State var event: Event
    var matches: [Match] {
        let gs = event.gameStateAtRound
        if gs == nil { return [] }
        if let currentRound = gs?.currentRound {
            return currentRound.matches
        } else {
            return []
        }
    }
    
    var match: Match? {
        return event.gameStateAtRound?.currentMatches.first { match in
            match.teams.contains { team in
                team.players.contains { player in
                    player.personaId == UserDefaults.standard.string(forKey: "personaId")!
                }
            }
        }
    }

    var body: some View {
        List {
            if match != nil {
                Section("My Match") {
                    NavigationLink {
                        SubmitMatchView(match: match!)
                    } label: {
                        MatchLineItem(match: match!)
                    }
                }
            }
            Section("All Matches") {
                ForEach(matches, id: \.matchId) { match in
                    MatchLineItem(match: match)
                }
            }
        }
    }
}

struct MatchLineItem: View {
    let match: Match
    var vsString: String {
        if match.teams.isEmpty {
            return "Unknown match"
        }
        if match.isBye {
            return "\(match.teams.first!.fullName)"
        }
        return "\(match.teams[0].fullName)\nvs.\n\(match.teams[1].fullName)"
    }
    var matchResultString: String {
        guard let results = match.results else {
            return "No results available"
        }
        
        var resultStrings: [String] = []
        for result in results {
            if let team = match.teams.first(where: { $0.teamId == result.teamId }) {
                let resultString = "\(team.fullName): W\(result.wins) - L\(result.losses) - D\(result.draws)"
                resultStrings.append(resultString)
            }
        }
        
        return resultStrings.joined(separator: "\n")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let tableNumber = match.tableNumber {
                    Text("Table: \(tableNumber)")
                } else {
                    Text("Bye")
                }
                Spacer()
            }
            
            if !match.teams.isEmpty {
                ForEach(match.teams, id: \.teamId) { team in
                    HStack {
                        Text(team.fullName)
                        Spacer()
                        if let result = match.results?.first(where: { $0.teamId == team.teamId }) {
                            Text("W\(result.wins) - L\(result.losses)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            Text("No result")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            } else {
                Text("Unknown match")
            }
        }
        .padding(.vertical, 8)
    }
    //    var body: some View {
    //        HStack {
    //            if match.tableNumber != nil {
    //                Text("Table: \(match.tableNumber!)")
    //            } else {
    //                Text("Bye")
    //            }
    //            Spacer()
    //            Text(vsString)
    //            Spacer()
    //            if match.results != nil {
    //                Text(matchResultString)
    //                    .font(.subheadline)
    //                    .foregroundColor(.gray)
    //                    .padding(.top, 4)
    //            }
    //        }
    //    }
}
