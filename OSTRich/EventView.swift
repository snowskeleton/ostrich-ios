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

    var body: some View {
        Text(event.shortCode ?? "")
        Text(event.status ?? "")
        Text(timeRemaining)
        //        Text(event.gameStateAtRound?.currentRoundNumber?.description ?? "no round number")
        VStack {
            Picker(selection: $selectedTab, label: Text("")) {
                Text("Players").tag("Players")

                //                if !event.currentMatches.isEmpty {
                //                    Text("Pairings").tag("Pairings")
                //                }

                //                if !(event.gameStateAtRound?.standings?.isEmpty ?? true) {
                //                    Text("Standings").tag("Standings")
                //                }
            }.pickerStyle(SegmentedPickerStyle())

            TabView(selection: $selectedTab) {
                PlayersView(event: event).tag("Players")

                //                if !event.currentMatches.isEmpty {
                //                    MatchesView(event: event).tag("Pairings")
                //                }

                //                if !(event.gameStateAtRound?.standings?.isEmpty ?? true) {
                //                    TeamStandingView(teamStandings: event.gameStateAtRound!.standings!).tag("Standings")
                //                }
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
        Network.getEvenAsHost(event: event)
//        Network.getGameState(event: event)
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

//struct MatchesView: View {
//    @State var event: Event
//    var matches: [Match] {
//        return event.gameStateAtRound?.currentRound?.matches ?? []
//    }
//    var match: Match? {
//        return event.gameStateAtRound.currentRound.matches.first { match in
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
//            if match != nil {
//                Section("My Match") {
//                    NavigationLink {
//                        SubmitMatchView(event: event)
//                    } label: {
//                        MatchLineItem(match: match!)
//                    }
//                }
//            }
//            Section("All Matches") {
//                ForEach(matches, id: \.tableNumber) { match in
//                    HStack {
//                        NavigationLink {
//                            SubmitMatchView(event: event, notMyMatch: match)
//                        } label: {
//                            MatchLineItem(match: match)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

struct PlayersView: View {
    @State var event: Event
    var body: some View {
        List {
            Section("Players: \(event.registeredPlayers.count)") {
                ForEach(event.registeredPlayers.sorted(by: { $0.safeName < $1.safeName }), id: \.id) { player in
                    VStack {
                        HStack {
                            Text(player.safeName)
                            if player.personaId
                                == UserDefaults.standard.string(
                                    forKey: "personaId")
                            {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MatchLineItem: View {
    let match: Match
    var longString: String {
        if match.isBye! { return "\(match.teams[0].fullName)" }
        return "\(match.teams[0].fullName)\nvs.\n\(match.teams[1].fullName)"
    }

    var body: some View {
        HStack {
            if match.tableNumber != nil {
                Text("Table: \(String(describing: match.tableNumber!))")
                Text(longString)
                Spacer()
                //                if match.leftTeamWins != nil && match.rightTeamWins != nil {
                //                    // this "-" character makes things look weird. Find something else
                //                    Text("\(match.leftTeamWins!)\n–\n\(match.rightTeamWins!)")
                //                }
            } else {
                Text("Bye:")
                Text(longString)
            }
        }
    }
}
