//
//  CreateFakeEventView.swift
//  OSTRich
//
//  Created by snow on 9/3/24.
//

import SwiftUI
import Foundation

struct CreateFakeEventView: View {
    @State private var eventName: String = "Test Event"
    @State private var eventFormat: String = "Modern"
    @State private var pairingType: String = "Swiss"
    @State private var minRounds: Int = 3
    @State private var requiredTeamSize: Int = 1
    @State private var scheduledStartTime: Date = Date()
    
    var body: some View {
        Form {
            Section(header: Text("Event Details")) {
                TextField("Event Name", text: $eventName)
                TextField("Event Format", text: $eventFormat)
                TextField("Pairing Type", text: $pairingType)
                Stepper(value: $minRounds, in: 1...10) {
                    Text("Minimum Rounds: \(minRounds)")
                }
                Stepper(value: $requiredTeamSize, in: 1...10) {
                    Text("Required Team Size: \(requiredTeamSize)")
                }
                DatePicker("Scheduled Start Time", selection: $scheduledStartTime, displayedComponents: .date)
            }
            
            Button("Create Fake Event") {
                createFakeEvent(
                    eventName: eventName,
                    eventFormat: pairingType,
                    minRounds: minRounds,
                    requiredTeamSize: requiredTeamSize,
                    scheduledStartTime: scheduledStartTime
                )
            }
            
            Button("Create event series with scouting results") {
                // do that
            }
        }
        .padding()
    }
    
}

@MainActor
func createFakeEvent(
    eventName: String,
    eventFormat: String,
    pairingType: String = "Swiss",
    minRounds: Int = 3,
    requiredTeamSize: Int = 1,
    scheduledStartTime: Date = Date()
    
) {
    let playerNames:  [[String: String]] = [
        [
            "firstName": "Todd",
            "lastName": "Anderson",
            "persona": "ToddAnderson",
            "displayName": "tanderson"
        ],
        [
            "firstName": "Fabrizio",
            "lastName": "Anteri",
            "persona": "FabrizioAnteri",
            "displayName": "fanteri"
        ],
        [
            "firstName": "Jose",
            "lastName": "Barbero",
            "persona": "JoseBarbero",
            "displayName": "jbarbero"
        ],
        [
            "firstName": "Frederico",
            "lastName": "Bastos",
            "persona": "FredericoBastos",
            "displayName": "fbastos"
        ],
        [
            "firstName": "Chris",
            "lastName": "Benafel",
            "persona": "ChrisBenafel",
            "displayName": "cbenafel"
        ],
        [
            "firstName": "Samuel",
            "lastName": "Black",
            "persona": "SamuelBlack",
            "displayName": "sblack"
        ]
    ]
    
    
    let players = playerNames.map {
        Player(
            personaId: $0["persona"]!,
            displayName: $0["displayName"]!,
            firstName: $0["firstName"]!,
            lastName: $0["lastName"]!
        )
    }
    
    let registeredPlayers = playerNames.map {
        Registration(
            id: $0["persona"]!,
            status: "FOUND",
            personaId: $0["persona"]!,
            displayName: $0["displayName"]!,
            firstName: $0["firstName"]!,
            lastName: $0["lastName"]!
        )
    }
    
    let teams = players.map { player in
        let team = Team(
            teamId: "\(player.firstName!)\(player.lastName!)",
            teamName: "\(player.firstName!) \(player.lastName!)",
            players: [player]
        )
        player.team = team
        return team
    }
    
    let eventFormat = EventFormat(
        id: UUID().uuidString,
        name: eventFormat
    )
    
    let event = Event(
        id: UUID().uuidString,
        title: eventName,
        pairingType: pairingType,
        status: "ROUNDACTIVE",
        isOnline: false,
        createdBy: "OSTRichTester",
        requiredTeamSize: requiredTeamSize,
        eventFormat: eventFormat,
        teams: teams,
        shortCode: "TESTEVENT",
        scheduledStartTime: scheduledStartTime.iso8601,
        actualStartTime: scheduledStartTime.iso8601,
        registeredPlayers: registeredPlayers
    )
    event.teams = teams
    event.registeredPlayers = registeredPlayers
    
    let gameState = GameStateV2(
        eventId: event.id,
        minRounds: minRounds,
        currentRoundNumber: 1,
        gamesToWin: 2
    )
    gameState.teams = teams
    teams.forEach { $0.gameState = gameState }
    event.gameStateAtRound = gameState
    
    let rounds = (1...minRounds).map { roundNumber in
        let round = Round(
            roundId: UUID().uuidString,
            roundNumber: roundNumber,
            isFinalRound: roundNumber == minRounds,
            gameState: gameState
        )
        let matches = stride(from: 0, to: teams.count, by: 2).map { index in
            let team1 = teams[index]
            let team2 = teams[index + 1]
            
            let match = Match(
                matchId: "testMatchId_\(roundNumber)_\(index / 2 + 1)",
                isBye: false,
                teamIds: [team1.teamId, team2.teamId],
                tableNumber: index / 2 + 1,
                round: round
            )
            
            let m1wins = Int.random(in: 0...2)
            let matchResult1 = MatchResult(
                matchId: match.matchId,
                submitter: team1.teamId,
                isBye: false,
                wins: m1wins,
                losses: 2 - m1wins,
                draws: 0,
                teamId: team1.teamId,
                match: match
            )
            
            let matchResult2 = MatchResult(
                matchId: match.matchId,
                submitter: team2.teamId,
                isBye: false,
                wins: 2 - matchResult1.wins,
                losses: matchResult1.wins,
                draws: 0,
                teamId: team2.teamId,
                match: match
            )
            
            match.results = [matchResult1, matchResult2]
            return match
        }
        round.matches = matches
        return round
    }
    
    gameState.rounds = rounds
    
    gameState.event = event
    event.explicitDoNotUpdate = true
    SwiftDataManager.shared.container.mainContext.insert(event)
}

extension Date {
    var iso8601: String {
        return ISO8601DateFormatter().string(from: self)
    }
}
