//
//  ResponseTypes.swift
//  Betrayer App
//
//  Created by snow on 9/4/23.
//

import Foundation

//class WrappedStruct<T>: ObservableObject {
//    @Published var item: T
//
//    init(withItem item:T) {
//        self.item = item
//    }
//}


protocol Query: Codable {
    /// The format of the response to expect from the GraphQL request
    associatedtype Response: Decodable
    
    /**
     Decode a `Data` object from the GraphQL endpoint into our expected `Response` type.
     
     - Parameter data: `Data` - bytes from the network
     */
    static func decodeResponse(_ data: Data) throws -> Response
}

extension Query {
    static func decodeResponse(_ data: Data) throws -> Response {
        try JSONDecoder().decode(Response.self, from: data)
    }
}

struct NewAccount: Query {
    let displayName: String
    let dateOfBirth: String
    let firstName: String
    let email: String
    let password: String
    let country: String
    let lastName: String
    var acceptedTC = true
    var dataShareOptIn = true
    var emailOptIn = false
    
    struct Response: Codable {
        let accountID: String
        let email: String
        let displayName: String
        let domainID: String
        let externalID: String
        let tokens: AuthCredentials.Response
        let persona: Persona
    }
}
struct Persona: Codable {
    let personaID: String
    let accountID: String
    let gameID: String
    let domainID: String
}

struct AuthCredentials: Query {
    var grant_type: String?
    var username: String?
    var password: String?
    var refresh_token: String?
    
    struct Response: Codable {
        let access_token: String
        let account_id: String?
        let client_id: String
        let display_name: String?
        let domain_id: String
        let expires_in: Int
        let game_id: String
        let persona_id: String
        let refresh_token: String
        let token_type: String
    }
}


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


//struct APIResponse<T: Decodable>: Decodable {
//    let data: T
//}

struct loadEvent: GraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    init(eventId: String) {
        self.operationName = String("\(type(of: self))".split(separator: ".").last!)
        self.query = try! String(contentsOfFile: Bundle.main.path(forResource: self.operationName, ofType: "query")!)
        self.variables = [ "eventId": eventId ]
    }
    struct Response: Codable { let data: loadEventData }
}

struct loadEventData: Codable {
    let event: Event
}


struct myActiveEvents: GraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    init() {
        self.operationName = String("\(type(of: self))".split(separator: ".").last!)
        self.query = try! String(contentsOfFile: Bundle.main.path(forResource: self.operationName, ofType: "query")!)
    }
    struct Response: Codable { let data: myActiveEventsData }
}
struct myActiveEventsData: Codable {
    let myActiveEvents: [Event]
}
struct Event: Codable, Hashable, Identifiable {
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
    
    let id: String?
    let shortCode: String?
    let createdBy: String?
    let title: String?
    let scheduledStartTime: String?
    let actualStartTime: String?
    let eventFormat: EventFormat?
    
    let pairingType: String?
    let status: String?
    let isOnline: Bool?
    let requiredTeamSize: Int?
    var registeredPlayers: [Registration]? = []
    let gameStateAtRound: GameState?
    let rounds: [Round]?
    let standings: [TeamStanding]?
    let drops: [String]?
    let draftTimerID: String?
    let constructDraftTimerID: String?
    let top8DraftTimerID: String?
    let gamesToWin: Int?
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
    init(code: String) {
        self.operationName = String("\(type(of: self))".split(separator: ".").last!)
        self.query = try! String(contentsOfFile: Bundle.main.path(forResource: self.operationName, ofType: "query")!)
        self.variables = [ "shortCode": code ]
    }
    struct Response: Codable { let data: joinEventWithShortCodeData }
}
struct joinEventWithShortCodeData: Codable {
        let joinEventWithShortCode: String
}

struct dropSelf: GraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    init(eventId: String) {
        self.operationName = String("\(type(of: self))".split(separator: ".").last!)
        self.query = try! String(contentsOfFile: Bundle.main.path(forResource: self.operationName, ofType: "query")!)
        self.variables = [ "eventId": eventId ]
    }
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
    let minRounds: Int
    let pods: String? // Replace with the actual data type if available
    let top8Pods: String? // Replace with the actual data type if available
    let constructedSeats: String? // Replace with the actual data type if available
    let currentRoundNumber: Int?
    let currentRound: Round?
    let canRollback: Bool?
    let timerID: String?
}

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
    let leftTeamWins: Int
    let rightTeamWins: Int
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
