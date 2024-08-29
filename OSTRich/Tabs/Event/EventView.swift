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

                if let gs = event.gameStateAtRound, !gs.currentMatches.isEmpty {
                    Text("Pairings").tag("Pairings")
                }

                if !(event.standings.isEmpty) {
                    Text("Standings").tag("Standings")
                }
                
            }.pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedTab) {
                    Analytics.track(.changedEventViewTab, with: ["to": selectedTab])
                }

            TabView(selection: $selectedTab) {
                RegisteredPlayersView(event: event).tag("Players")

                if let gs = event.gameStateAtRound, !gs.currentMatches.isEmpty {
                    PairingsView(from: gs.id).tag("Pairings")
                }

                if !(event.standings.isEmpty) {
                    StandingsView(event: event).tag("Standings")
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            Section {
                Button(
                    role: .destructive,
                    action: {
                        dropSelfFromEvent(eventId: event.id)
                    },
                    label: {
                        Text("Drop")
                    })
            }
        }
        .refreshable {
            updateEvent()
            Analytics.track(.manuallyRefreshedEventView)
        }
        .onAppear {
            if let gs = event.gameStateAtRound, !gs.currentMatches.isEmpty {
                selectedTab = "Pairings"
            }
            updateEvent()
            Analytics.track(.openedEventView)
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
        GQLNetwork.getEventAsHost(event: event)
        GQLNetwork.getGameState(event: event)
        getTime()
    }

    fileprivate func getTime() {
        if let timer = event.gameStateAtRound?.currentRound?.timer {
            timer.update()
            if timer.state == .running {
                Notifications.scheduleRoundTimerNotifications(for: timer)
            }
        } else {
            Analytics.track(.noTimerForEvent)
        }
    }

    fileprivate func dropSelfFromEvent(eventId: String) {
        GQLNetwork.shared.dropSelfFromEvent(eventId: eventId) { results in
            switch results {
            case .success(let response):
                print(response)
                Analytics.track(.playerDroppedFromEvent)
            case .failure(let error):
                print("The error we got was: \(String(describing: error))")
                Analytics.track(.playerDropFromEventFailure)
            }
        }
        
    }
}


