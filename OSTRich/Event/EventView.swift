//
//  EventView.swift
//  OSTRich
//
//  Created by snow on 9/17/23.
//

import SwiftUI
import SwiftData


struct EventView: View {
    @Bindable var event: Event
    @State private var selectedTab = "Players"
    @State private var showEventDetails = false

    var round: Round? {
        event.gameStateAtRound?.currentRound
    }
    
    var body: some View {
        Text(event.shortCode ?? "")
        Text(event.status ?? "")
        if let timer = event.gameStateAtRound?.currentRound?.timer {
            RoundTimerView(timer: timer)
        }
        Text((event.gameStateAtRound?.currentRoundNumber.description) ?? "0")
        
        if UserDefaults.standard.bool(forKey: "showDebugValues") {
            if round != nil {
                Text("Round ID: \(round!.roundId)")
            }
        }

        VStack {
            Picker(selection: $selectedTab, label: Text("")) {
                Text("Players").tag("Players")

                if event.gameStateAtRound != nil {
                    Text("Pairings").tag("Pairings")
                }

                if !(event.standings.isEmpty) {
                    Text("Standings").tag("Standings")
                }
                
            }.pickerStyle(SegmentedPickerStyle())

            TabView(selection: $selectedTab) {
                PlayersView(players: Binding<[Registration]>.constant(event.registeredPlayers)).tag("Players")

                if event.gameStateAtRound != nil {
                    PairingsView(matches: Binding<[Match]>.constant(event.gameStateAtRound!.currentMatches)).tag("Pairings")
                }

                if !(event.standings.isEmpty) {
                    StandingsView(teamStandings: Binding<[Standing]>.constant(event.standings)).tag("Standings")
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            Section {
                Button(
                    role: .destructive,
                    action: {
                        //                    dropSelfFromEvent(eventId: event.id)
                    },
                    label: {
                        Text("Drop")
                    })
            }
        }
        .refreshable {
            updateEvent()
        }
        .onAppear {
            if event.gameStateAtRound != nil {
                selectedTab = "Pairings"
            }
            getTime()
            updateEvent()
        }
        .onReceive(
            Timer.publish(every: 10, on: .main, in: .common).autoconnect(),
            perform: { _ in
                updateEvent()
            }
        )
        .sheet(isPresented: $showEventDetails) {
            EventDetail(event: event)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: { showEventDetails = true },
                    label: {
                        Image(systemName: "info.circle")
                            .font(.largeTitle)
                            .foregroundColor(Color.secondary)
                    }
                ).accessibilityLabel(("Event Details"))
            }
        }

        .navigationTitle(Text(event.title))
    }
    
    fileprivate func updateEvent() {
        Network.getEventAsHost(event: event)
        Network.getGameState(event: event)
    }

    fileprivate func getTime() {
        if let timer = event.gameStateAtRound?.currentRound?.timer {
            timer.update()
        }
    }

    //    fileprivate func dropSelfFromEvent(eventId: String) {
    //        Task {
    //            switch await HTOService().dropEvent(eventId: eventId) {
    //            case .success(let response):
    //                print(response)
    //            case .failure(let error):
    //                print("The error we got was: \(String(describing: error))")
    //            }
    //        }
    //
    //    }
}


