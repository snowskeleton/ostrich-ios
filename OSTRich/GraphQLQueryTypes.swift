//
//  GraphyQLQueryTypes.swift
//  OSTRich
//
//  Created by snow on 9/4/23.
//

import Foundation

protocol GraphQLQuery: Query {
    /// Values to use in query
    var variables: [String: String] { get set }
    /// Name of function
    var operationName: String { get }
    /// The full string to send in the GraphQL request
    var query: String { get set }
}

extension GraphQLQuery {
    var query: String {
        let filename = String("\(type(of: self))".split(separator: ".").last!)
        let bundle = Bundle.main.path(forResource: filename, ofType: "query")!
        let finalAnswer = try! String(contentsOfFile: bundle)
        return finalAnswer
    }
}


struct loadEvent: GraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: loadEventData }
}

struct loadEventData: Codable {
    let event: Event
}


struct myActiveEvents: GraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: myActiveEventsData }
}
struct myActiveEventsData: Codable {
    let myActiveEvents: [Event]
}
class Event: Codable, Hashable, Identifiable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(shortCode)
        hasher.combine(createdBy)
        hasher.combine(title)
        hasher.combine(scheduledStartTime)
        hasher.combine(actualStartTime)
        hasher.combine(eventFormat)
    }
    
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
struct EventFormat: Codable, Hashable {
    static func == (lhs: EventFormat, rhs: EventFormat) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(includesDraft)
        hasher.combine(includesDeckbuilding)
    }
    
    let id: String
    let name: String
    let includesDraft: Bool
    let includesDeckbuilding: Bool
}


struct joinEventWithShortCode: GraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: joinEventWithShortCodeData }
}
struct joinEventWithShortCodeData: Codable {
        let joinEventWithShortCode: String
}

struct dropSelf: GraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: dropSelfData }
}
struct dropSelfData: Codable {
    let dropSelf: String
}

struct dropTeamV2: GraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    init(eventId: String, teamId: String) {
        self.operationName = String("\(type(of: self))".split(separator: ".").last!)
        self.query = try! String(contentsOfFile: Bundle.main.path(forResource: self.operationName, ofType: "query")!)
        self.variables = [ "eventId": eventId , "teamId": teamId]
    }
    struct Response: Codable { let data: dropTeamV2Data }
}
struct dropTeamV2Data: Codable {
    let dropTeam: String
}

struct submitMatch: GraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: submitMatchData}
}
struct submitMatchData: Codable {
    let recordMatchResult: GameState
}

struct Registration: Codable, Hashable {
    let id: String
    let status: String
    let personaId: String
    let displayName: String
    let firstName: String
    let lastName: String
}

struct GameState: Codable {
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

struct Standing: Codable { }
struct Drop: Codable { }

struct Round: Codable {
    let id: String
    let number: Int
    let isFinalRound: Bool
    let isCertified: Bool
    let matches: [Match]
    let canRollback: Bool?
    let timerID: String?
}

struct Match: Codable {
    let id: String
    let isBye: Bool
    let teams: [Team]
    let leftTeamWins: Int?
    let rightTeamWins: Int?
    let tableNumber: Int?
}

struct Team: Codable {
    let id: String
    let name: String?
    let players: [User]
    let results: [TeamResult]?
}

struct User: Codable {
    let personaId: String
    let displayName: String
    let firstName: String
    let lastName: String
}

struct TeamResult: Codable {
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

struct TeamStanding: Codable {
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
