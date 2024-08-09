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
                        SubmitMatchView(match: Binding<Match>.constant(myMatch!))
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


//struct PairingsView: View {
//    
//    @Binding var matches: [Match]
//    
//    var myMatch: Match? {
//        return matches.first { match in
//            match.teams.contains { team in
//                team.players.contains { player in
//                    player.personaId == UserDefaults.standard.string(forKey: "personaId")!
//                }
//            }
//        }
//    }
//
//    var body: some View {
//        List {
//            if myMatch != nil {
//                Section("My Match") {
//                    NavigationLink {
//                        SubmitMatchView(match: Binding<Match>.constant(myMatch!))
//                    } label: {
//                        PairingItem(viewModel: Binding<PairingItem.ViewModel>.constant(PairingItem.ViewModel(match: myMatch!)))
//                    }
//                }
//            }
//            Section("All Matches") {
//                ForEach(matches, id: \.matchId) { match in
//                    PairingItem(viewModel: Binding<PairingItem.ViewModel>.constant(PairingItem.ViewModel(match: match)))
//                }
//            }
//        }
//    }
//}
//
//
//extension PairingItem {
//    
//    class ViewModel {
//        let tableNumber: Int?
//        let team1Name: String
//        let team2Name: String?
//        let team1Wins: Int?
//        let team2Wins: Int?
//        var isBye: Bool = false
//        
//        init(match: Match) {
//            self.tableNumber = match.tableNumber
//            self.isBye = match.isBye
//            
//            if match.teams.count > 2 {
//                print("More than 2 teams in match. Undefined results")
//            }
//            
//            guard match.teams.count > 1 && !match.isBye else {
//                self.team1Name = match.teams.first!.fullName
//                self.team2Name = nil
//                self.team1Wins = nil
//                self.team2Wins = nil
//                return
//            }
//            
//            let firstTeam = match.teams.first!
//            let lastTeam = match.teams.last!
//            
//            self.team1Name = firstTeam.fullName
//            self.team2Name = lastTeam.fullName
//            
//            var team1Wins: Int? = nil
//            var team2Wins: Int? = nil
//            
//            if !match.results.isEmpty {
//                for result in match.results {
//                    if result.teamId == firstTeam.teamId {
//                        team1Wins = result.wins
//                        team2Wins = result.losses
//                    } else if result.teamId == lastTeam.teamId {
//                        team1Wins = result.losses
//                        team2Wins = result.wins
//                    } else {
//                        print("Undefined MatchResults")
//                    }
//                }
//            }
//            
//            self.team1Wins = team1Wins
//            self.team2Wins = team2Wins
//        }
//    }
//}
//
//struct PairingItem: View {
//    @Binding var viewModel: ViewModel
//
//    var body: some View {
//        HStack {
//            if viewModel.isBye {
//                Text("Bye")
//            } else {
//                Text("Table: \(viewModel.tableNumber!)")
//            }
//            Spacer()
//            
//            VStack {
//                
//                HStack {
//                    Spacer()
//                    Text(viewModel.team1Name)
//                    Spacer()
//                    if viewModel.team1Wins != nil {
//                        Text(String(viewModel.team1Wins!))
//                    }
//                }
//                
//                if viewModel.team2Name != nil {
//                    Text("vs.")
//                    
//                    HStack {
//                        Spacer()
//                        Text(viewModel.team2Name!)
//                        Spacer()
//                        if viewModel.team2Wins != nil {
//                            Text(String(viewModel.team2Wins!))
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
