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
        return "\(fpName)\nvs.\n\(spName)"
    }
    
    var body: some View {
        HStack {
            if match.tableNumber != nil {
                Text("Table: \(String(describing: match.tableNumber!))")
                Text(longString)
                Spacer()
                if match.leftTeamWins != nil && match.rightTeamWins != nil {
                    // this "-" character makes things look weird. Find something else
                    Text("\(match.leftTeamWins!)\n–\n\(match.rightTeamWins!)")
                }
            } else {
                Text("Bye:")
                Text(longString)
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
                        NavigationLink {
                            SubmitMatchView(event: event, notMyMatch: match)
                        } label: {
                            MatchLineItem(match: match)
                        }
                    }
                }
            }
        }
    }
}
struct EventView: View {
    @Bindable var event: Event
    @State private var targetDate: Date = Date()
    @State private var timeRemaining: String = ""
    
    var body: some View {
        Text(event.shortCode ?? "" )
        Text(event.status ?? "")
        Text(timeRemaining)
            .onAppear { getTime() }
        Text(event.gameStateAtRound?.currentRoundNumber?.description ?? "no round number")
        List {
            NavigationLink {
                if !event.currentMatches.isEmpty {
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
        .refreshable { Task { await event.updateSelf() } }
        .onAppear {
        Task.detached { @MainActor in
             await event.updateSelf() }
//            Task { await event.updateSelf() }
        }
        .onReceive(Timer.publish(every: 10, on: .main, in: .common).autoconnect(), perform: { _ in
            Task.detached { @MainActor in await event.updateSelf() }
        })
        .onReceive(Timer.publish(every: 0.2, on: .main, in: .common).autoconnect(), perform: { _ in
            Task.detached { @MainActor in
                let now = Date()
                let remainingTime = self.targetDate.timeIntervalSince(now)
                
                if remainingTime > 0 {
                    self.timeRemaining = self.formatTimeInterval(remainingTime)
                } else {
                    self.timeRemaining = "00:00"
                }
            }
        })
        .navigationTitle(Text(event.title ?? ""))
    }
    
    fileprivate func getTime() {
        Task { @MainActor in
            guard let timerId = event.gameStateAtRound?.timerID else {
                print("can't get a timer ID")
                return
            }
//            switch await HTOService().getTimer("some_timer_id") {
            switch await HTOService().getTimer(timerId) {
            case .success(let response):
                let timer = response.data.timer
                let isoDate = timer.durationStartTime
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                guard var realDate = dateFormatter.date(from: isoDate) else {
                    return
                }
                realDate.addTimeInterval(Double(timer.durationMs) / 1000)
                self.targetDate = realDate

            case .failure(let error):
                print("The error we got was: \(String(describing: error))")
            }
        }
    }
    
    fileprivate func formatTimeInterval(_ interval: TimeInterval) -> String {
        let seconds = Int(interval) % 60
        let minutes = (Int(interval) / 60)
        return String(format: "%02d:%02d", minutes, seconds)
//        return "\(minutes):\(seconds)"
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
