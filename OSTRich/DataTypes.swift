//
//  DataTypes.swift
//  OSTRich
//
//  Created by snow on 9/29/23.
//

import Foundation
import SwiftData

extension Event {

    func update(with data: Gamestateschema.LoadEventHostV2Query.Data.Event) {
        var existingPlayers = Dictionary(uniqueKeysWithValues: self.registeredPlayers.map { ($0.id, $0) })
        
        for player in data.registeredPlayers! {
            if let existingPlayer = existingPlayers[player.id] {
                existingPlayer.status = player.status?.rawValue
                existingPlayer.personaId = player.personaId
                existingPlayer.displayName = player.displayName
                existingPlayer.firstName = player.firstName
                existingPlayer.lastName = player.lastName
            } else {
                let newPlayer = Registration(
                    id: player.id,
                    status: player.status?.rawValue,
                    personaId: player.personaId,
                    displayName: player.displayName,
                    firstName: player.firstName,
                    lastName: player.lastName
                )
                self.registeredPlayers.append(newPlayer)
                existingPlayers[newPlayer.id] = newPlayer
            }
        }
        
        self.registeredPlayers = Array(existingPlayers.values)
    }
    
    func update(
        with data: Gamestateschema.MyActiveEventsQuery.Data.MyActiveEvent
    ) {
        self.actualStartTime = data.actualStartTime
        self.createdBy = data.createdBy
        self.scheduledStartTime = data.scheduledStartTime
        self.shortCode = data.shortCode
        self.title = data.title
        if let eventFormatData = data.eventFormat {
            self.eventFormat = EventFormat(
                id: eventFormatData.id,
                name: eventFormatData.name,
                includesDraft: eventFormatData.includesDraft,
                includesDeckbuilding: eventFormatData
                    .includesDeckbuilding
            )
        }
    }

    func update(with data: Gamestateschema.LoadEventJoinV2Query.Data.Event) {
        self.title = data.title
        self.pairingType = data.pairingType.rawValue
        self.status = data.status.rawValue
        self.isOnline = data.isOnline
        self.createdBy = data.createdBy
        self.requiredTeamSize = data.requiredTeamSize

        // Initialize eventFormat
        self.eventFormat = data.eventFormat.map {
            EventFormat(
                id: $0.id,
                name: $0.name,
                includesDraft: $0.includesDraft,
                includesDeckbuilding: $0.includesDeckbuilding
            )
        }

        // Update teams
        self.teams = data.teams.map { teamData in
            let registrations = teamData.registrations?.map {
                Registration(
                    id: $0.id,
                    status: $0.status?.rawValue,
                    personaId: $0.personaId,
                    displayName: $0.displayName,
                    firstName: $0.firstName,
                    lastName: $0.lastName
                )
            }

            let reservations = teamData.reservations?.map {
                Reservation(
                    personaId: $0.personaId,
                    displayName: $0.displayName,
                    firstName: $0.firstName,
                    lastName: $0.lastName
                )
            }

            return Team(
                eventId: teamData.eventId,
                teamCode: teamData.teamCode,
                isLocked: teamData.isLocked,
                isRegistered: teamData.isRegistered,
                registrations: registrations,
                reservations: reservations,
                teamId: teamData.id,
                players: [] as [Player]
            )
        }
    }

    //    convenience init(from data: Gamestateschema.LoadEventJoinV2Query.Data) {
    //        let event = data.event!
    //
    //        // Initialize eventFormat
    //        let eventFormat = event.eventFormat.map {
    //            EventFormat(
    //                id: $0.id,
    //                name: $0.name,
    //                includesDraft: $0.includesDraft,
    //                includesDeckbuilding: $0.includesDeckbuilding
    //            )
    //        }
    //
    //        // Initialize teams
    //        let teams = event.teams.map { teamData in
    //            // Initialize registrations
    //            let registrations = teamData.registrations?.map {
    //                Registration(
    //                    id: $0.id,
    //                    status: $0.status?.rawValue,
    //                    personaId: $0.personaId,
    //                    displayName: $0.displayName,
    //                    firstName: $0.firstName,
    //                    lastName: $0.lastName
    //                )
    //            }
    //
    //            // Initialize reservations
    //            let reservations = teamData.reservations?.map {
    //                Reservation(
    //                    personaId: $0.personaId,
    //                    displayName: $0.displayName,
    //                    firstName: $0.firstName,
    //                    lastName: $0.lastName
    //                )
    //            }
    //
    //            return Team(
    //                eventId: teamData.eventId,
    //                teamCode: teamData.teamCode,
    //                isLocked: teamData.isLocked,
    //                isRegistered: teamData.isRegistered,
    //                registrations: registrations,
    //                reservations: reservations,
    //                teamId: teamData.id,
    //                players: []
    //            )
    //        }
    //
    //        self.init(
    //            id: event.id,
    //            title: event.title,
    //            pairingType: event.pairingType.rawValue,
    //            status: event.status.rawValue,
    //            isOnline: event.isOnline,
    //            createdBy: event.createdBy,
    //            requiredTeamSize: event.requiredTeamSize,
    //            eventFormat: eventFormat,
    //            teams: teams,
    //            shortCode: nil,
    //            scheduledStartTime: nil,
    //            actualStartTime: nil
    //        )
    //    }

    convenience init(
        from event: Gamestateschema.MyActiveEventsQuery.Data.MyActiveEvent
    ) {
        self.init(
            id: event.id,
            title: event.title,
            pairingType: nil,
            status: nil,
            isOnline: nil,
            createdBy: event.createdBy ?? "",
            requiredTeamSize: 0,  // Replace with actual requiredTeamSize value
            eventFormat: nil,
            teams: [] as [Team],
            shortCode: event.shortCode,
            scheduledStartTime: event.scheduledStartTime,
            actualStartTime: event.actualStartTime
        )
    }
}

@Model
class Event: Identifiable {
    @Attribute(.unique)
    var id: String
    var title: String
    var pairingType: String?
    var status: String?
    var isOnline: Bool?
    var createdBy: String?
    var requiredTeamSize: Int
    @Relationship(deleteRule: .cascade)
    var eventFormat: EventFormat?
    var teams: [Team]
    var shortCode: String?
    var scheduledStartTime: Gamestateschema.DateTime?
    var actualStartTime: Gamestateschema.DateTime?
    //    var registeredPlayers: [Registration]
    @Relationship(deleteRule: .cascade)
    var registeredPlayers: [Registration]

    let created: Date = Date.now

    init(
        id: String, title: String, pairingType: String?, status: String?,
        isOnline: Bool?, createdBy: String?, requiredTeamSize: Int,
        eventFormat: EventFormat?, teams: [Team], shortCode: String?,
        scheduledStartTime: Gamestateschema.DateTime?,
        actualStartTime: Gamestateschema.DateTime?,
        registeredPlayers: [Registration] = []
    ) {
        self.id = id
        self.title = title
        self.pairingType = pairingType
        self.status = status
        self.isOnline = isOnline
        self.createdBy = createdBy
        self.requiredTeamSize = requiredTeamSize
        self.eventFormat = eventFormat
        self.teams = teams
        self.shortCode = shortCode
        self.scheduledStartTime = scheduledStartTime
        self.actualStartTime = actualStartTime
        self.registeredPlayers = registeredPlayers
    }

}
@Model
class EventFormat: Identifiable {
    @Attribute(.unique)
    let id: String?
    let name: String = ""
    let includesDraft: Bool = false
    let includesDeckbuilding: Bool = false

    init(
        id: String, name: String, includesDraft: Bool,
        includesDeckbuilding: Bool
    ) {
        self.id = id
        self.name = name
        self.includesDraft = includesDraft
        self.includesDeckbuilding = includesDeckbuilding
    }
}

private func safeNameExpander(
    _ firstName: String?, _ lastName: String?, _ displayName: String?
) -> String {
    if firstName == nil
        && lastName == nil
        && displayName == nil
    {
        return "Unknown player"
    } else if firstName == nil
        && lastName == nil
        && displayName != nil
    {
        return displayName!
    } else if firstName != nil
        && lastName == nil
    {
        return firstName!
    } else if firstName == nil
        && lastName != nil
    {
        return lastName!
    } else {
        return "\(firstName!) \(lastName!)"
    }
}

@Model
class Registration: Identifiable {
    @Attribute(.unique)
    var id: String?
    var status: String?
    var personaId: String?
    var displayName: String?
    var firstName: String?
    var lastName: String?
    var safeName: String {
        return safeNameExpander(self.firstName, self.lastName, self.displayName)
    }

    init(
        id: String, status: String?, personaId: String?,
        displayName: String?, firstName: String?, lastName: String?
    ) {
        self.id = id
        self.status = status
        self.personaId = personaId
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        //        self.event = event
    }
}

@Model
class Reservation: Identifiable {
    @Attribute(.unique)
    let personaId: String?
    let displayName: String?
    let firstName: String?
    let lastName: String?

    init(
        personaId: String?, displayName: String?, firstName: String?,
        lastName: String?
    ) {
        self.personaId = personaId
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
    }
}

@Model
class GameStateV2: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var eventId: String
    var minRounds: Int?
    var draft: Draft?
    var top8Draft: Top8Draft?
    var deckConstruction: DeckConstruction?
    var currentRoundNumber: Int
    @Relationship(inverse: \Round.gameState) var rounds: [Round] = []
    @Relationship(inverse: \Team.gameState) var teams: [Team] = []
    @Relationship(inverse: \Drop.gameState) var drops: [Drop] = []
    var podPairingType: String?
    var gamesToWin: Int?

    init(
        eventId: String, minRounds: Int? = nil, draft: Draft? = nil,
        top8Draft: Top8Draft? = nil, deckConstruction: DeckConstruction? = nil,
        currentRoundNumber: Int, rounds: [Round] = [], teams: [Team] = [],
        drops: [Drop] = [], podPairingType: String? = nil,
        gamesToWin: Int? = nil
    ) {
        self.eventId = eventId
        self.minRounds = minRounds
        self.draft = draft
        self.top8Draft = top8Draft
        self.deckConstruction = deckConstruction
        self.currentRoundNumber = currentRoundNumber
        self.rounds = rounds
        self.teams = teams
        self.drops = drops
        self.podPairingType = podPairingType
        self.gamesToWin = gamesToWin
    }
}

@Model
class Draft: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    @Relationship(inverse: \Pod.draft) var pods: [Pod]
    var timerId: String?

    init(pods: [Pod], timerId: String? = nil) {
        self.pods = pods
        self.timerId = timerId
    }
}

@Model
class Top8Draft: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    @Relationship(inverse: \Pod.top8Draft) var pods: [Pod]
    var timerId: String?

    init(pods: [Pod], timerId: String? = nil) {
        self.pods = pods
        self.timerId = timerId
    }
}

@Model
class DeckConstruction: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var timerId: String?
    @Relationship(inverse: \Seat.deckConstruction) var seats: [Seat]

    init(timerId: String? = nil, seats: [Seat]) {
        self.timerId = timerId
        self.seats = seats
    }
}

@Model
class Round: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var roundId: String
    var roundNumber: Int
    var isFinalRound: Bool?
    var isPlayoff: Bool?
    var isCertified: Bool?
    @Relationship(inverse: \Match.round) var matches: [Match]
    var pairingStrategy: String?
    var canRollback: Bool?
    var timerId: String?
    @Relationship(inverse: \Standing.round) var standings: [Standing]
    var gameState: GameStateV2?

    init(
        roundId: String, roundNumber: Int, isFinalRound: Bool? = nil,
        isPlayoff: Bool? = nil, isCertified: Bool? = nil, matches: [Match],
        pairingStrategy: String? = nil, canRollback: Bool? = nil,
        timerId: String? = nil, standings: [Standing],
        gameState: GameStateV2? = nil
    ) {
        self.roundId = roundId
        self.roundNumber = roundNumber
        self.isFinalRound = isFinalRound
        self.isPlayoff = isPlayoff
        self.isCertified = isCertified
        self.matches = matches
        self.pairingStrategy = pairingStrategy
        self.canRollback = canRollback
        self.timerId = timerId
        self.standings = standings
        self.gameState = gameState
    }
}

@Model
class Team: Identifiable {
    @Attribute(.unique)
    let eventId: String
    let teamCode: String
    let isLocked: Bool?
    let isRegistered: Bool?
    let registrations: [Registration]?
    let reservations: [Reservation]?
    var teamId: String
    var teamName: String?
    @Relationship(inverse: \Player.team) var players: [Player]
    var gameState: GameStateV2?

    init(
        eventId: String, teamCode: String, isLocked: Bool?,
        isRegistered: Bool?, registrations: [Registration]?,
        reservations: [Reservation]?,
        teamId: String, teamName: String? = nil, players: [Player],
        gameState: GameStateV2? = nil
    ) {
        self.eventId = eventId
        self.teamCode = teamCode
        self.isLocked = isLocked
        self.isRegistered = isRegistered
        self.registrations = registrations
        self.reservations = reservations
        self.teamId = teamId
        self.teamName = teamName
        self.players = players
        self.gameState = gameState
    }
}

@Model
class Player: Identifiable {
    @Attribute(.unique)
    let id: String
    var team: Team?
    var personaId: String?
    var displayName: String?
    var firstName: String?
    var lastName: String?

    var safeName: String {
        return safeNameExpander(self.firstName, self.lastName, self.displayName)
    }

    init(
        id: String, personaId: String, displayName: String?,
        firstName: String?, lastName: String?, team: Team?
    ) {
        self.id = id
        self.personaId = personaId
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.team = team
    }
}

@Model
class Pod: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var podNumber: Int
    @Relationship(inverse: \Seat.pod) var seats: [Seat]
    var draft: Draft?
    var top8Draft: Top8Draft?

    init(
        podNumber: Int, seats: [Seat], draft: Draft? = nil,
        top8Draft: Top8Draft? = nil
    ) {
        self.podNumber = podNumber
        self.seats = seats
        self.draft = draft
        self.top8Draft = top8Draft
    }
}

@Model
class Seat: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var seatNumber: Int
    var teamId: String
    var pod: Pod?
    var deckConstruction: DeckConstruction?

    init(
        seatNumber: Int, teamId: String, pod: Pod? = nil,
        deckConstruction: DeckConstruction? = nil
    ) {
        self.seatNumber = seatNumber
        self.teamId = teamId
        self.pod = pod
        self.deckConstruction = deckConstruction
    }
}

@Model
class Match: Identifiable {
    @Attribute(.unique)
    var matchId: String
    var isBye: Bool?
    var teamIds: [String]
    @Relationship(inverse: \MatchResult.match) var results: [MatchResult]?
    var tableNumber: Int?
    var round: Round?

    var teams: [Team] {
        return self.round?.gameState?.teams.filter {
            $0.teamId == self.teamIds[0] || $0.teamId == self.teamIds[1]
        } ?? []
    }

    init(
        matchId: String, isBye: Bool? = nil, teamIds: [String],
        results: [MatchResult]? = nil, tableNumber: Int? = nil,
        round: Round? = nil
    ) {
        self.matchId = matchId
        self.isBye = isBye
        self.teamIds = teamIds
        self.results = results
        self.tableNumber = tableNumber
        self.round = round
    }
}

@Model
class MatchResult: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var matchId: String
    var submitter: String
    var isBye: Bool
    var wins: Int
    var losses: Int
    var draws: Int
    var teamId: String
    var match: Match?

    init(
        matchId: String, submitter: String, isBye: Bool, wins: Int, losses: Int,
        draws: Int, teamId: String, match: Match? = nil
    ) {
        self.matchId = matchId
        self.submitter = submitter
        self.isBye = isBye
        self.wins = wins
        self.losses = losses
        self.draws = draws
        self.teamId = teamId
        self.match = match
    }
}

@Model
class Standing: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var teamId: String
    var rank: Int
    var wins: Int
    var losses: Int
    var draws: Int
    var matchPoints: Int
    var gameWinPercent: Double
    var opponentGameWinPercent: Double
    var opponentMatchWinPercent: Double
    var round: Round?

    init(
        teamId: String, rank: Int, wins: Int, losses: Int, draws: Int,
        matchPoints: Int, gameWinPercent: Double,
        opponentGameWinPercent: Double, opponentMatchWinPercent: Double,
        round: Round? = nil
    ) {
        self.teamId = teamId
        self.rank = rank
        self.wins = wins
        self.losses = losses
        self.draws = draws
        self.matchPoints = matchPoints
        self.gameWinPercent = gameWinPercent
        self.opponentGameWinPercent = opponentGameWinPercent
        self.opponentMatchWinPercent = opponentMatchWinPercent
        self.round = round
    }
}

@Model
class Drop: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var teamId: String
    var reason: String
    var timestamp: Date
    var gameState: GameStateV2?

    init(
        teamId: String, reason: String, timestamp: Date,
        gameState: GameStateV2? = nil
    ) {
        self.teamId = teamId
        self.reason = reason
        self.timestamp = timestamp
        self.gameState = gameState
    }
}

class EventV1: Codable, Identifiable {
}

//struct EventFormat: Codable {
//}

struct GameState: Codable {
}

extension Team {
    var fullName: String {
        let firstPlayer = self.players[0]
        let fpName =
            "\(String(describing: firstPlayer.firstName)) \(String(describing: firstPlayer.lastName))"
        if self.players.count == 1 {
            return fpName
        }

        let secondPlayer = self.players[1]
        let spName =
            "\(String(describing: secondPlayer.firstName)) \(String(describing: secondPlayer.lastName))"
        var combinedName = "\(fpName) \(spName)"
        if self.players.count == 2 {
            return combinedName
        }

        let thirdPlayer = self.players[2]
        let tpName =
            "\(String(describing: thirdPlayer.firstName)) \(String(describing: thirdPlayer.lastName))"
        combinedName = "\(fpName), \(spName), and \(tpName)"
        return combinedName
    }
}

struct User: Codable {
}

struct TeamResult: Codable {
}

struct TeamStanding: Codable {
}

struct WotcTimer: Codable {
}
