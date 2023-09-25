//
//  EventView.swift
//  OSTRich
//
//  Created by snow on 9/17/23.
//

import SwiftUI


struct SubmitMatchView: View {
    let match: Match
    var player1: User { return match.teams[1].players[0] }
    var player2: User { return match.teams[0].players[0] }
//    var players: [User] { return [match.teams[0].players[0], match.teams[1].players[0] ]}
    
    @State private var p1Wins = 0
    @State private var p2Wins = 0
    
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
            Button("Submit") {
                print("Submit")
            }
        }
    }
}

struct MatchLineItem: View {
    let match: Match
    var longString: String {
        let firstPlayer = match.teams[0].players[0]
        let fpName = "\(firstPlayer.firstName) \(firstPlayer.lastName)"
        if match.isBye { return "\(fpName)" }
        let secondPlayer = match.teams[1].players[0]
        let spName = "\(secondPlayer.firstName) \(secondPlayer.lastName)"
        return "\(fpName) vs. \(spName)"
    }
    
    var body: some View {
        HStack {
            Text(match.tableNumber != nil ? "Table: \(String(describing: match.tableNumber!))" : "Bye:")
            Text(longString)
            Spacer()
            if match.leftTeamWins != nil && match.rightTeamWins != nil {
                Text("\(match.leftTeamWins!) – \(match.rightTeamWins!)")
            }
        }
    }
}

struct MatchesViwe: View {
    var matches: [Match]
    var personaId = UserDefaults.standard.string(forKey: "personaId") ?? ""
    
    var body: some View {
        List {
            Section("My Match") {
                ForEach(matches, id: \.tableNumber) { match in
                    if playerInMatch(personaId: personaId, match: match) {
                        NavigationLink {
                            SubmitMatchView(match: match)
                        } label: {
                             MatchLineItem(match: match)
                        }
                    }
                }
            }
            Section("All Matches") {
                ForEach(matches, id: \.tableNumber) { match in
                    HStack {
                        MatchLineItem(match: match)
                    }
                }
            }
        }
    }
    fileprivate func playerInMatch(personaId: String, match: Match) -> Bool {
        return match.teams.contains { team in
            team.players.contains { player in
                player.personaId == personaId
            }
        }
    }
}
struct EventView: View {
    @State var someEvent: Event
    @State private var event: Event?
    
    var body: some View {
        Text(event?.shortCode ?? "")
        Text(event?.status ?? "")
        List {
            NavigationLink {
                if let matches = event?.gameStateAtRound?.currentRound?.matches {
                    MatchesViwe(matches: matches)
                }
            } label: {
                Text("Matches")
            }
            ForEach((event?.registeredPlayers) ?? [], id: \.self) { player in
                VStack {
                    HStack {
                        Text("\(player.firstName) \(player.lastName) | \(player.displayName)")
                        if player.personaId == UserDefaults.standard.string(forKey: "personaId") {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            Section {
                Button(role: .destructive, action: {
                    dropSelfFromEvent(eventId: someEvent.id)
                }, label: {
                    Text("Drop")
                })
            }
        }
        .onAppear {
            getEvent()
        }
        //        .onReceive(Timer.publish(every: 10, on: .main, in: .common).autoconnect(), perform: { _ in
        //            Task { await getEvent() }
        //        })
        .navigationTitle(Text(event?.title ?? ""))
    }
    func getEvent() {
        Task {
            switch await HTOService().getEvent(eventId: someEvent.id) {
            case .success(let response):
                event = response.data.event
//                print(response.data.event)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func dropSelfFromEvent(eventId: String) {
        Task {
            switch await HTOService().dropEvent(eventId: eventId) {
            case .success(let response):
                print(response)
            case .failure(let error):
                print("The error we got was: \(String(describing: error))")
            }
        }
        
    }
}
