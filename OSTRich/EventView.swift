//
//  EventView.swift
//  OSTRich
//
//  Created by snow on 9/17/23.
//

import SwiftUI

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
                Text("\(match.rightTeamWins!) – \(match.leftTeamWins!)")
            }
        }
    }
}

struct MatchesView: View {
    @State var event: Event
    var matches: [Match] {
        return event.gameStateAtRound?.currentRound?.matches ?? []
    }
    var match: Match? {
        return event.gameStateAtRound!.currentRound!.matches.first { match in
            match.teams.contains { team in
                team.players.contains { player in
                    player.personaId == UserDefaults.standard.string(forKey: "personaId")
                }
            }
        }
    }
//    var personaId = UserDefaults.standard.string(forKey: "some garbage") ?? ""
    
    var body: some View {
        List {
            if match != nil {
                Section("My Match") {
                    NavigationLink {
                        SubmitMatchView(event: event)
                    } label: {
                        MatchLineItem(match: match!)
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
}
struct EventView: View {
    @Bindable var event: Event
    
    var body: some View {
        Text(event.shortCode ?? "" )
        Text(event.status ?? "")
        List {
            NavigationLink {
                if let _ = event.gameStateAtRound?.currentRound?.matches {
                    MatchesView(event: event)
                }
            } label: {
                Text("Matches")
            }
            ForEach((event.registeredPlayers) ?? [], id: \.id) { player in
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
                    dropSelfFromEvent(eventId: event.id)
                }, label: {
                    Text("Drop")
                })
            }
        }
        .refreshable { event.updateSelf() }
        .onAppear {
            event.updateSelf()
        }
        .onReceive(Timer.publish(every: 10, on: .main, in: .common).autoconnect(), perform: { _ in
            event.updateSelf()
        })
        .navigationTitle(Text(event.title ?? ""))
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
