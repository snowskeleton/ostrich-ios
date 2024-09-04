//
//  createFakeEvent.swift
//  OSTRich
//
//  Created by snow on 9/3/24.
//

import Foundation

@MainActor func createFakeEvent() {
    // Create players
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
        id: "testEventFormatId",
        name: "Modern"
    )
    
    let event = Event(
        id: "testEventId",
        title: "Test Event",
        pairingType: "Swiss",
        status: "ROUNDACTIVE",
        isOnline: false,
        createdBy: "OSTRichTester",
        requiredTeamSize: 1,
        eventFormat: eventFormat,
        teams: teams,
        shortCode: "TESTEVENT",
        scheduledStartTime: Date().iso8601,
        actualStartTime: Date().iso8601,
        registeredPlayers: registeredPlayers
    )
    event.teams = teams
    event.registeredPlayers = registeredPlayers
    
    
    let gameState = GameStateV2(
        eventId: event.id,
        minRounds: 3,
        currentRoundNumber: 1,
        gamesToWin: 2
    )
    gameState.teams = teams
    teams.forEach { $0.gameState = gameState }
    event.gameStateAtRound = gameState
    
    
    // Create rounds, matches, and standings
    let rounds = (1...3).map { roundNumber in
        let round = Round(
            roundId: "testRoundId_\(roundNumber)",
            roundNumber: roundNumber,
            isFinalRound: roundNumber == 3,
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
            
            let matchResult1 = MatchResult(
                matchId: match.matchId,
                submitter: team1.teamId,
                isBye: false,
                wins: Int.random(in: 0...2),
                losses: Int.random(in: 0...2),
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
    
    // Assign the event to the game state
    gameState.event = event
    event.explicitDoNotUpdate = true
    SwiftDataManager.shared.container.mainContext.insert(event)
}

extension Date {
    var iso8601: String {
        return ISO8601DateFormatter().string(from: self)
    }
}
