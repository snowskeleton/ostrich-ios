//
//  DataTypes.swift
//  OSTRich
//
//  Created by snow on 9/29/23.
//

import Foundation


extension Event {
    func updateSelf() { }
}

class Event: Codable, Identifiable {
    
    var id: String?
    var shortCode: String?
    var createdBy: String?
    var title: String?
    var scheduledStartTime: String?
    var actualStartTime: String?
    var eventFormat: EventFormat?
    
    var pairingType: String?
    var status: String?
    var isOnline: Bool?
    var requiredTeamSize: Int?
    var registeredPlayers: [Registration]? = []
    var gameStateAtRound: GameState?
    var rounds: [Round]?
    var standings: [TeamStanding]?
    var drops: [String]?
    var draftTimerID: String?
    var constructDraftTimerID: String?
    var top8DraftTimerID: String?
    var gamesToWin: Int?
}
class EventFormat: Codable {
    
    let id: String
    let name: String
    let includesDraft: Bool
    let includesDeckbuilding: Bool
}

class Registration: Codable {
    let id: String
    let status: String
    let personaId: String
    let displayName: String
    let firstName: String
    let lastName: String
}

class GameState: Codable {
    let id: String
    let minRounds: Int?
    let pods: String? // Replace with the actual data type if available
    let top8Pods: String? // Replace with the actual data type if available
    let constructedSeats: String? // Replace with the actual data type if available
    let currentRoundNumber: Int?
    let currentRound: Round?
    let rounds: [Round]?
    let standings: [Standing]?
    let drops: [Drop]?
    let draftTimerId: String?
    let constructDraftTimerID: String?
    let top8DraftTimerID: String?
    let gamesToWin: Int?
    let canRollback: Bool?
    let timerID: String?
}

class Standing: Codable { }
class Drop: Codable { }

class Round: Codable {
    let id: String
    let number: Int
    let isFinalRound: Bool
    let isCertified: Bool
    let matches: [Match]
    let canRollback: Bool?
    let timerID: String?
}

class Match: Codable {
    let id: String
    let isBye: Bool
    let teams: [Team]
    let leftTeamWins: Int?
    let rightTeamWins: Int?
    let tableNumber: Int?
}

class Team: Codable {
    let id: String
    let name: String?
    let players: [User]
    let results: [TeamResult]?
}

class User: Codable {
    let personaId: String
    let displayName: String
    let firstName: String
    let lastName: String
}

class TeamResult: Codable {
    let draws: Int
    let isPlayoffResult: Bool
    let submitter: String
    let isFinal: Bool
    let isTO: Bool
    let isBye: Bool
    let wins: Int
    let losses: Int
    let teamId: String
}

class TeamStanding: Codable {
    let team: Team
    let rank: Int
    let wins: Int
    let losses: Int
    let draws: Int
    let byes: Int
    let matchPoints: Int
    let gameWinPercent: Double
    let opponentGameWinPercent: Double
    let opponentMatchWinPercent: Double
}
