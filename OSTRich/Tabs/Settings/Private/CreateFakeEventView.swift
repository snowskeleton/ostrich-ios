//
//  CreateFakeEventView.swift
//  OSTRich
//
//  Created by snow on 9/3/24.
// https://stackoverflow.com/questions/77992023/swiftui-stepper-exc-bad-access-crash-on-mac-designed-for-iphone-works-ok-in-io
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
    @State private var eventSeriesLength: Int = 7
    @State private var gameStoreName: String = ""

    @State private var showCreatedFakeEvent: Bool = false
    @State private var showCreatedFakeSeries: Bool = false
    @State private var showCreatedScreenshotsData: Bool = false

    var body: some View {
        Form {
            Section(header: Text("Event Details")) {
                TextField("Event Name", text: $eventName)
                TextField("Event Format", text: $eventFormat)
                TextField("Pairing Type", text: $pairingType)
                TextField("Game Store Name", text: $gameStoreName)
                if !ProcessInfo.processInfo.isiOSAppOnMac {
                    Stepper(value: $minRounds, in: 1...10) {
                        Text("Minimum Rounds: \(minRounds)")
                    }
                    Stepper(value: $requiredTeamSize, in: 1...10) {
                        Text("Required Team Size: \(requiredTeamSize)")
                    }
                }
                DatePicker("Scheduled Start Time", selection: $scheduledStartTime, displayedComponents: .date)
            }
            
            Button("Create Fake Event") {
                createFakeEvent(
                    eventName: eventName,
                    eventFormat: eventFormat,
                    pairingType: pairingType,
                    minRounds: minRounds,
                    requiredTeamSize: requiredTeamSize,
                    scheduledStartTime: scheduledStartTime,
                    gameStoreName: gameStoreName
                )
                showCreatedFakeEvent = true
            }
            .alert("Event created!", isPresented: $showCreatedFakeEvent) {
                Button("OK", role: .cancel) { }
            }
            
            Section {
                if !ProcessInfo.processInfo.isiOSAppOnMac {
                    Stepper(value: $eventSeriesLength) {
                        Text("How many events? \(eventSeriesLength)")
                    }
                }
                Button("Create Fake Series") {
                    for i in 0..<eventSeriesLength {
                        let newStartTime = Calendar.current.date(byAdding: .day, value: i * 7, to: scheduledStartTime) ?? scheduledStartTime
                        
                        createFakeEvent(
                            eventName: eventName,
                            eventFormat: eventFormat,
                            pairingType: pairingType,
                            minRounds: minRounds,
                            requiredTeamSize: requiredTeamSize,
                            scheduledStartTime: newStartTime,
                            gameStoreName: gameStoreName
                        )
                    }
                    showCreatedFakeSeries = true
                }
                .alert("Created \(eventSeriesLength) weekly events!", isPresented: $showCreatedFakeSeries) {
                    Button("OK", role: .cancel) { }
                }
                
                Button("Create Screenshots Data") {
                    createScreenshotSeries()
                    showCreatedScreenshotsData = true
                }
                .alert("Created screenshots data", isPresented: $showCreatedScreenshotsData) {
                    Button("OK", role: .cancel) { }
                }
                
            }
            
        }
    }
    
    fileprivate func createScreenshotSeries() {
        // Sunday Standard
        var newStartTime = Calendar.current.date(
            bySetting: .weekday,
            value: 1,
            of: scheduledStartTime
        ) ?? scheduledStartTime
        newStartTime = Calendar.current
            .date(
                bySetting: .hour,
                value: 15,
                of: newStartTime
            ) ?? newStartTime
        
        for i in 0..<eventSeriesLength {
            let newStartTime = Calendar.current.date(
                byAdding: .day,
                value: i * 7,
                to: newStartTime
            ) ?? newStartTime
            createFakeEvent(
                eventName: "Sunday Standard",
                eventFormat: "Standard",
                pairingType: pairingType,
                minRounds: minRounds,
                requiredTeamSize: requiredTeamSize,
                scheduledStartTime: newStartTime,
                testDecks: standardDecks,
                gameStoreName: "Channel Fireball"
            )
        }
        
        // Wednesday Pauper
        newStartTime = Calendar.current.date(bySetting: .weekday, value: 4, of: newStartTime) ?? newStartTime
        newStartTime = Calendar.current
            .date(
                bySetting: .hour,
                value: 19,
                of: newStartTime
            ) ?? newStartTime
        for i in 0..<eventSeriesLength {
            let newStartTime = Calendar.current.date(
                byAdding: .day,
                value: i * 7,
                to: newStartTime
            ) ?? newStartTime
            createFakeEvent(
                eventName: "Wednesday Pauper",
                eventFormat: "Pauper",
                pairingType: pairingType,
                minRounds: minRounds,
                requiredTeamSize: requiredTeamSize,
                scheduledStartTime: newStartTime,
                testDecks: pauperDecks,
                gameStoreName: "Joe's Kitchen"
            )
        }
        
        // Thursday Commander
        newStartTime = Calendar.current.date(bySetting: .weekday, value: 5, of: newStartTime) ?? newStartTime
        newStartTime = Calendar.current
            .date(
                bySetting: .hour,
                value: 18,
                of: newStartTime
            ) ?? newStartTime
        for i in 0..<eventSeriesLength {
            let newStartTime = Calendar.current.date(
                byAdding: .day,
                value: i * 7,
                to: newStartTime
            ) ?? newStartTime
            createFakeEvent(
                eventName: "Thursday Commander",
                eventFormat: "EDH",
                pairingType: pairingType,
                minRounds: minRounds,
                requiredTeamSize: requiredTeamSize,
                scheduledStartTime: newStartTime,
                testDecks: edhDecks,
                gameStoreName: "The Gathering Place"
            )
        }
        
        // Modern FNM
        newStartTime = Calendar.current.date(bySetting: .weekday, value: 6, of: newStartTime) ?? newStartTime
        newStartTime = Calendar.current
            .date(
                bySetting: .hour,
                value: 19,
                of: newStartTime
            ) ?? newStartTime
        for i in 0..<eventSeriesLength {
            let newStartTime = Calendar.current.date(
                byAdding: .day,
                value: i * 7,
                to: newStartTime
            ) ?? newStartTime
            createFakeEvent(
                eventName: "Modern FNM",
                eventFormat: "Modern",
                pairingType: pairingType,
                minRounds: minRounds,
                requiredTeamSize: requiredTeamSize,
                scheduledStartTime: newStartTime,
                testDecks: modernDecks,
                gameStoreName: "Face to Face Games"
            )
        }
    }
}

@MainActor
func createFakeEvent(
    eventName: String,
    eventFormat: String,
    pairingType: String = "Swiss",
    minRounds: Int = 3,
    requiredTeamSize: Int = 1,
    scheduledStartTime: Date = Date(),
    testDecks: [String] = modernDecks,
    gameStoreName: String
    
) {
    let creatorPersonaId = gameStoreName + "-persona"
    var playerNames:  [[String: String]] = [
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
    if let userPersonaId = UserManager.shared.currentUser?.personaId! {
        playerNames.append(
            [
                "firstName": "You,",
                "lastName": "You Beautiful Animal",
                "persona": userPersonaId,
                "displayName": "beautifulAnimal"
            ]
        )
    }
    
    playerNames = playerNames.shuffled()
    
    let players = playerNames.map {
        Player(
            personaId: $0["persona"]!,
            displayName: $0["displayName"]!,
            firstName: $0["firstName"]!,
            lastName: $0["lastName"]!
        )
    }
    let _ = players.map {
        SwiftDataManager.shared.container.mainContext.insert($0)
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
    let _ = registeredPlayers.map {
        SwiftDataManager.shared.container.mainContext.insert($0)
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
    let _ = teams.map {
        SwiftDataManager.shared.container.mainContext.insert($0)
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
        createdBy: creatorPersonaId,
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
        var matches = stride(from: 0, to: teams.count - (teams.count % 2), by: 2).map { index in
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
        
        // Handle the odd team (if any) by giving them a Bye
        if teams.count % 2 != 0 {
            let byeTeam = teams.last!
            
            let byeMatch = Match(
                matchId: "testMatchId_\(roundNumber)_\(matches.count + 1)",
                isBye: true,
                teamIds: [byeTeam.teamId],
                tableNumber: nil,  // No table number for a Bye
                round: round
            )
            
            let byeResult = MatchResult(
                matchId: byeMatch.matchId,
                submitter: byeTeam.teamId,
                isBye: true,
                wins: 2,
                losses: 0,
                draws: 0,
                teamId: byeTeam.teamId,
                match: byeMatch
            )
            
            byeMatch.results = [byeResult]
            matches.append(byeMatch)
        }
        
        round.matches = matches
        return round
    }
    
    gameState.rounds = rounds
    
    gameState.event = event
    event.explicitDoNotUpdate = true
    SwiftDataManager.shared.container.mainContext.insert(event)
    
    players.forEach { player in
        let newPlayer = LocalPlayer.createOrUpdate(from: player)
        
        let scoutingResult = ScoutingResult(
            deckName: testDecks.randomElement()!,
            eventName: eventName,
            eventId: event.id,
            createdBy: creatorPersonaId,
            format: eventFormat.name,
            player: newPlayer,
            date: scheduledStartTime
        )
        
        let gameStore = GameStore.createOrUpdate(from: creatorPersonaId)
        gameStore.userGivenName = gameStoreName
        scoutingResult.gameStore = gameStore
        
        SwiftDataManager.shared.container.mainContext.insert(scoutingResult)
    }
}

extension Date {
    var iso8601: String {
        return ISO8601DateFormatter().string(from: self)
    }
}

fileprivate var modernDecks: [String] = [
    "Merfolk",
    "Mono B Control",
    "Rakdos Scam",
    "Tron",
    "Nadu",
    "Domain Zoo",
    "Jeskai Control",
    "Storm"
]

fileprivate var standardDecks: [String] = [
    "Gruul Prowess",
    "Dimir Midrange",
    "Domain",
    "Rakdos Lizards",
    "Golgari Midrange",
    "Domain Boros Mice",
    "Graveyard Beans",
    "Rakdos Fling"
]

fileprivate var pauperDecks: [String] = [
    "Grixis Affinity",
    "Broodscale",
    "Mono Red",
    "Gruul Ramp",
    "Mono White Aggro",
    "Bogles",
    "Jeskai Ephemerate",
    "Familiars",
    "Elves"
]

fileprivate var edhDecks: [String] = [
    "The Locust God",
    "Odric",
    "Flubs, the Fool",
    "The Ur-Dragon",
    "Krenko, Mob Boss",
    "Atraxa",
    "Chatterfang",
    "Edgar Markov",
    "Niv-Mizzet"
]

