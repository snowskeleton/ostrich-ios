//
//  EventView.swift
//  OSTRich
//
//  Created by snow on 9/17/23.
//

import SwiftUI

struct EventView: View {
    @Bindable var event: Event
    @State private var targetDate: Date = Date()
    @State private var timeRemaining: String = ""
    @State private var selectedTab = "Players"
    @State private var showEventDetails = false

    var round: Round? {
        event.gameStateAtRound?.currentRound
    }
    
    var body: some View {
        Text(event.shortCode ?? "")
        Text(event.status ?? "")
        Text(timeRemaining)
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
            //                getTime()
            updateEvent()
        }
        .onReceive(
            Timer.publish(every: 10, on: .main, in: .common).autoconnect(),
            perform: { _ in
                updateEvent()
            }
        )
        .onReceive(
            Timer.publish(every: 0.2, on: .main, in: .common).autoconnect(),
            perform: { _ in
                Task.detached { @MainActor in
                    let now = Date()
                    let remainingTime = self.targetDate.timeIntervalSince(now)

                    if remainingTime > 0 {
                        self.timeRemaining = self.formatTimeInterval(
                            remainingTime)
                    } else {
                        self.timeRemaining = "00:00"
                    }
                }
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
        Network.getEvent(event: event)
        Network.getEventAsHost(event: event)
        Network.getGameState(event: event)
    }

    //    fileprivate func getTime() {
    //        Task { @MainActor in
    //            guard let timerId = $event.gameStateAtRound.timerID else {
    //                print("can't get a timer ID")
    //                return
    //            }
    ////            switch await HTOService().getTimer("some_timer_id") {
    //            switch await HTOService().getTimer(timerId) {
    //            case .success(let response):
    //                let timer = response.data.timer
    //                let isoDate = timer.durationStartTime
    //                let dateFormatter = ISO8601DateFormatter()
    //                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    //                guard var realDate = dateFormatter.date(from: isoDate) else {
    //                    return
    //                }
    //                realDate.addTimeInterval(Double(timer.durationMs) / 1000)
    //                self.targetDate = realDate
    //
    //            case .failure(let error):
    //                print("The error we got was: \(String(describing: error))")
    //            }
    //        }
    //    }

    fileprivate func formatTimeInterval(_ interval: TimeInterval) -> String {
        let seconds = Int(interval) % 60
        let minutes = (Int(interval) / 60)
        return String(format: "%02d:%02d", minutes, seconds)
        //        return "\(minutes):\(seconds)"
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


