//
//  DataTypes.swift
//  OSTRich
//
//  Created by snow on 9/29/23.
//

import Foundation
import SwiftData
import CoreData


extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}


public class Event: NSManagedObject {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.shortCode, forKey: .shortCode)
        try container.encodeIfPresent(self.createdBy, forKey: .createdBy)
        try container.encodeIfPresent(self.actualStartTime, forKey: .actualStartTime)
        try container.encodeIfPresent(self.constructDraftTimerID, forKey: .constructDraftTimerID)
        try container.encodeIfPresent(self.draftTimerID, forKey: .draftTimerID)
        try container.encodeIfPresent(self.drops, forKey: .drops)
        try container.encodeIfPresent(self.eventFormat, forKey: .eventFormat)
        try container.encodeIfPresent(self.gameStateAtRound, forKey: .gameStateAtRound)
        try container.encodeIfPresent(self.gamesToWin, forKey: .gamesToWin)
        try container.encodeIfPresent(self.isOnline, forKey: .isOnline)
        try container.encodeIfPresent(self.pairingType, forKey: .pairingType)
        try container.encodeIfPresent(self.registeredPlayers, forKey: .registeredPlayers)
        try container.encodeIfPresent(self.requiredTeamSize, forKey: .requiredTeamSize)
        try container.encodeIfPresent(self.rounds, forKey: .rounds)
        try container.encodeIfPresent(self.scheduledStartTime, forKey: .scheduledStartTime)
        try container.encodeIfPresent(self.standings, forKey: .standings)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.top8DraftTimerID, forKey: .top8DraftTimerID)
        
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.actualStartTime = try container.decodeIfPresent(String.self, forKey: .actualStartTime)
        self.constructDraftTimerID = try container.decodeIfPresent(String.self, forKey: .constructDraftTimerID)
        self.createdBy = try container.decodeIfPresent(String.self, forKey: .createdBy)
        self.draftTimerID = try container.decodeIfPresent(String.self, forKey: .draftTimerID)
        self.drops = try container.decodeIfPresent([String].self, forKey: .drops) as NSSet
        self.eventFormat = try container.decodeIfPresent(EventFormat.self, forKey: .eventFormat)
        self.gameStateAtRound = try container.decodeIfPresent(GameState.self, forKey: .gameStateAtRound)
        self.gamesToWin = try container.decodeIfPresent(Int.self, forKey: .gamesToWin)
        self.isOnline = try container.decodeIfPresent(Bool.self, forKey: .isOnline)
        self.pairingType = try container.decodeIfPresent(String.self, forKey: .pairingType)
        self.registeredPlayers = try container.decodeIfPresent([Registration].self, forKey: .registeredPlayers)
        self.requiredTeamSize = try container.decodeIfPresent(Int.self, forKey: .requiredTeamSize)
        self.rounds = try container.decodeIfPresent([Round].self, forKey: .rounds)
        self.scheduledStartTime = try container.decodeIfPresent(String.self, forKey: .scheduledStartTime)
        self.shortCode = try container.decodeIfPresent(String.self, forKey: .shortCode)
        self.standings = try container.decodeIfPresent([TeamStanding].self, forKey: .standings)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.top8DraftTimerID = try container.decodeIfPresent(String.self, forKey: .top8DraftTimerID)
    }
    
    init(fromResponse event: Event) throws {
        self.id = event.id
        self.shortCode = event.shortCode
        self.createdBy = event.createdBy
        self.title = event.title
        self.scheduledStartTime = event.scheduledStartTime
        self.actualStartTime = event.actualStartTime
        self.pairingType = event.pairingType
        self.status = event.status
        self.isOnline = event.isOnline
        self.requiredTeamSize = event.requiredTeamSize
        self.drops = event.drops
        self.draftTimerID = event.draftTimerID
        self.constructDraftTimerID = event.constructDraftTimerID
        self.top8DraftTimerID = event.top8DraftTimerID
        self.gamesToWin = event.gamesToWin
        self.eventFormat = event.eventFormat
        self.registeredPlayers = event.registeredPlayers
        self.gameStateAtRound = event.gameStateAtRound
        self.rounds = event.rounds
        self.standings = event.standings
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case actualStartTime
        case constructDraftTimerID
        case createdBy
        case draftTimerID
        case drops
        case eventFormat
        case gameStateAtRound
        case gamesToWin
        case isOnline
        case pairingType
        case registeredPlayers
        case requiredTeamSize
        case rounds
        case scheduledStartTime
        case shortCode
        case standings
        case status
        case title
        case top8DraftTimerID
    }
    
}

public class Match: NSManagedObject {
    
}

public class GameState: NSManagedObject {
    
}

public class WotcTimer: NSManagedObject {
    
}

extension Event {
    func updateSelf() async {
        //        Task {
        //        Task(priority: .high) {
        switch await HTOService().getEvent(eventId: self.id.debugDescription) {
        case .success(let response):
            Task { @MainActor in
                let event = response.data.event
                self.registeredPlayers = event.registeredPlayers
                //                if let gs = event.gameStateAtRound {
                //                    print(gs)
                self.gameStateAtRound = event.gameStateAtRound
                //                }
                
                self.shortCode = event.shortCode
                self.createdBy = event.createdBy
                self.title = event.title
                self.scheduledStartTime = event.scheduledStartTime
                self.actualStartTime = event.actualStartTime
                self.pairingType = event.pairingType
                self.status = event.status
                self.isOnline = event.isOnline
                self.requiredTeamSize = event.requiredTeamSize
                self.drops = event.drops
                self.draftTimerID = event.draftTimerID
                self.constructDraftTimerID = event.constructDraftTimerID
                self.top8DraftTimerID = event.top8DraftTimerID
                self.gamesToWin = event.gamesToWin
                self.eventFormat = event.eventFormat
                self.registeredPlayers = event.registeredPlayers
                self.gameStateAtRound = event.gameStateAtRound
                self.rounds = event.rounds
                self.standings = event.standings
            }
        case .failure(let error):
            print(error.localizedDescription)
            //            }
        }
    }
    
    var currentMatches: [Match] {
        guard let gameState = self.gameStateAtRound else { return [] }
        guard let matches = gameState.currentRound?.wrappedMatches else { return [] }
        return matches
    }
}

extension Round {
    public var wrappedMatches: [Match] {
        let set = matches as? Set<Match> ?? []
        return set.sorted {
            $0.tableNumber < $1.tableNumber
        }
    }
}

extension Match {
    public var wrappedTeams: [Team] {
        let set = teams as? Set<Team> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
}



//
//@Model
//class Event: Codable, Identifiable {
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(self.id, forKey: .id)
//        try container.encodeIfPresent(self.shortCode, forKey: .shortCode)
//        try container.encodeIfPresent(self.createdBy, forKey: .createdBy)
//        try container.encodeIfPresent(self.actualStartTime, forKey: .actualStartTime)
//        try container.encodeIfPresent(self.constructDraftTimerID, forKey: .constructDraftTimerID)
//        try container.encodeIfPresent(self.draftTimerID, forKey: .draftTimerID)
//        try container.encodeIfPresent(self.drops, forKey: .drops)
//        try container.encodeIfPresent(self.eventFormat, forKey: .eventFormat)
//        try container.encodeIfPresent(self.gameStateAtRound, forKey: .gameStateAtRound)
//        try container.encodeIfPresent(self.gamesToWin, forKey: .gamesToWin)
//        try container.encodeIfPresent(self.isOnline, forKey: .isOnline)
//        try container.encodeIfPresent(self.pairingType, forKey: .pairingType)
//        try container.encodeIfPresent(self.registeredPlayers, forKey: .registeredPlayers)
//        try container.encodeIfPresent(self.requiredTeamSize, forKey: .requiredTeamSize)
//        try container.encodeIfPresent(self.rounds, forKey: .rounds)
//        try container.encodeIfPresent(self.scheduledStartTime, forKey: .scheduledStartTime)
//        try container.encodeIfPresent(self.standings, forKey: .standings)
//        try container.encodeIfPresent(self.status, forKey: .status)
//        try container.encodeIfPresent(self.title, forKey: .title)
//        try container.encodeIfPresent(self.top8DraftTimerID, forKey: .top8DraftTimerID)
//
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.actualStartTime = try container.decodeIfPresent(String.self, forKey: .actualStartTime)
//        self.constructDraftTimerID = try container.decodeIfPresent(String.self, forKey: .constructDraftTimerID)
//        self.createdBy = try container.decodeIfPresent(String.self, forKey: .createdBy)
//        self.draftTimerID = try container.decodeIfPresent(String.self, forKey: .draftTimerID)
//        self.drops = try container.decodeIfPresent([String].self, forKey: .drops)
//        self.eventFormat = try container.decodeIfPresent(EventFormat.self, forKey: .eventFormat)
//        self.gameStateAtRound = try container.decodeIfPresent(GameState.self, forKey: .gameStateAtRound)
//        self.gamesToWin = try container.decodeIfPresent(Int.self, forKey: .gamesToWin)
//        self.isOnline = try container.decodeIfPresent(Bool.self, forKey: .isOnline)
//        self.pairingType = try container.decodeIfPresent(String.self, forKey: .pairingType)
//        self.registeredPlayers = try container.decodeIfPresent([Registration].self, forKey: .registeredPlayers)
//        self.requiredTeamSize = try container.decodeIfPresent(Int.self, forKey: .requiredTeamSize)
//        self.rounds = try container.decodeIfPresent([Round].self, forKey: .rounds)
//        self.scheduledStartTime = try container.decodeIfPresent(String.self, forKey: .scheduledStartTime)
//        self.shortCode = try container.decodeIfPresent(String.self, forKey: .shortCode)
//        self.standings = try container.decodeIfPresent([TeamStanding].self, forKey: .standings)
//        self.status = try container.decodeIfPresent(String.self, forKey: .status)
//        self.title = try container.decodeIfPresent(String.self, forKey: .title)
//        self.top8DraftTimerID = try container.decodeIfPresent(String.self, forKey: .top8DraftTimerID)
//    }
//
//    init(fromResponse event: Event) throws {
//        self.id = event.id
//        self.shortCode = event.shortCode
//        self.createdBy = event.createdBy
//        self.title = event.title
//        self.scheduledStartTime = event.scheduledStartTime
//        self.actualStartTime = event.actualStartTime
//        self.pairingType = event.pairingType
//        self.status = event.status
//        self.isOnline = event.isOnline
//        self.requiredTeamSize = event.requiredTeamSize
//        self.drops = event.drops
//        self.draftTimerID = event.draftTimerID
//        self.constructDraftTimerID = event.constructDraftTimerID
//        self.top8DraftTimerID = event.top8DraftTimerID
//        self.gamesToWin = event.gamesToWin
//        self.eventFormat = event.eventFormat
//        self.registeredPlayers = event.registeredPlayers
//        self.gameStateAtRound = event.gameStateAtRound
//        self.rounds = event.rounds
//        self.standings = event.standings
//    }
//
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case actualStartTime
//        case constructDraftTimerID
//        case createdBy
//        case draftTimerID
//        case drops
//        case eventFormat
//        case gameStateAtRound
//        case gamesToWin
//        case isOnline
//        case pairingType
//        case registeredPlayers
//        case requiredTeamSize
//        case rounds
//        case scheduledStartTime
//        case shortCode
//        case standings
//        case status
//        case title
//        case top8DraftTimerID
//    }
//
//    @Attribute(.unique) var id: String
//    var actualStartTime: String?
//    var constructDraftTimerID: String?
//    var createdBy: String?
//    var draftTimerID: String?
//    var drops: [String]?
//    var eventFormat: EventFormat?
//    var gameStateAtRound: GameState?
//    var gamesToWin: Int?
//    var isOnline: Bool?
//    var pairingType: String?
//    var registeredPlayers: [Registration]?
//    var requiredTeamSize: Int?
//    var rounds: [Round]?
//    var scheduledStartTime: String?
//    var shortCode: String?
//    var standings: [TeamStanding]?
//    var status: String?
//    var title: String?
//    var top8DraftTimerID: String?
//}
//
//struct EventFormat: Codable {
//    let id: String
//    let name: String
//    let includesDraft: Bool
//    let includesDeckbuilding: Bool
//}
//
//struct Registration: Codable {
//    let id: String
//    let status: String
//    let personaId: String
//    let displayName: String
//    let firstName: String
//    let lastName: String
//}
//
//struct GameState: Codable {
//    let id: String
//    let minRounds: Int?
//    let pods: String? // Replace with the actual data type if available
//    let top8Pods: String? // Replace with the actual data type if available
//    let constructedSeats: String? // Replace with the actual data type if available
//    let currentRoundNumber: Int?
//    let currentRound: Round?
//    let rounds: [Round]?
//    let standings: [TeamStanding]?
//    let drops: [Drop]?
//    let draftTimerID: String?
//    let constructDraftTimerID: String?
//    let top8DraftTimerID: String?
//    let gamesToWin: Int?
//    let canRollback: Bool?
//    let timerID: String?
//}
//
////struct Standing: Codable { }
//struct Drop: Codable { }
//
//struct Round: Codable {
//    let id: String
//    let number: Int
//    let isFinalRound: Bool
//    let isCertified: Bool
//    let matches: [Match]
//    let canRollback: Bool?
//    let timerID: String?
//}
//
//struct Match: Codable {
////@Observable class Match: Codable {
//    let id: String
//    let isBye: Bool
//    let teams: [Team]
//    let leftTeamWins: Int?
//    let rightTeamWins: Int?
//    let tableNumber: Int?
//}
//
//struct Team: Codable {
//    let id: String
//    let name: String?
//    let players: [User]
//    let results: [TeamResult]?
//}
//
//extension Team {
//    var fullName: String {
//        let firstPlayer = self.players[0]
//        let fpName = "\(firstPlayer.firstName) \(firstPlayer.lastName)"
//        if self.players.count == 1 {
//            return fpName
//        }
//
//        let secondPlayer = self.players[1]
//        let spName = "\(secondPlayer.firstName) \(secondPlayer.lastName)"
//        var combinedName = "\(fpName) \(spName)"
//        if self.players.count == 2 {
//            return combinedName
//        }
//
//        let thirdPlayer = self.players[2]
//        let tpName = "\(thirdPlayer.firstName) \(thirdPlayer.lastName)"
//        combinedName = "\(fpName), \(spName), and \(tpName)"
//        return combinedName
//    }
//}
//
//struct User: Codable {
//    let personaId: String
//    let displayName: String
//    let firstName: String
//    let lastName: String
//}
//
//struct TeamResult: Codable {
//    let draws: Int
//    let isPlayoffResult: Bool
//    let submitter: String
//    let isFinal: Bool
//    let isTO: Bool
//    let isBye: Bool
//    let wins: Int
//    let losses: Int
//    let teamId: String
//}
//
//struct TeamStanding: Codable {
//    let team: Team
//    let rank: Int
//    let wins: Int
//    let losses: Int
//    let draws: Int
//    let byes: Int
//    let matchPoints: Int
//    let gameWinPercent: Double
//    let opponentGameWinPercent: Double
//    let opponentMatchWinPercent: Double
//}
//
//struct WotcTimer: Codable {
//    let id: String
//    let state: String
//    let durationMs: Int
//    let durationStartTime: String
//    let serverTime: String
//}
