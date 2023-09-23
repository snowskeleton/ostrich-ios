//
//  EventView.swift
//  Betrayer App
//
//  Created by snow on 9/17/23.
//

import SwiftUI

struct MatchesViwe: View {
    var matches: [Match]
    var personaId = UserDefaults.standard.string(forKey: "personaId")
    
    var body: some View {
        List {
            ForEach(matches, id: \.tableNumber) { match in
                if match.isBye {
                    Text("Name: \(match.teams[0].players[0].firstName) – Bye" )
                } else {
                    if match.teams[0].players[0].personaId == personaId || match.teams[1].players[0].personaId == personaId {
                        Text(String(describing: match))
                        Text(match.teams[0].players[0].displayName)
                        Text(match.teams[0].players[0].firstName)
                        Text(match.teams[0].players[0].lastName)
                    }
                }
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
                    Text(player.displayName)
                    Text(player.firstName)
                    Text(player.lastName)
                    if player.personaId == UserDefaults.standard.string(forKey: "personaId") {
                        Text("This is YOU")
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
                print(response.data.event)
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
