//
//  GraphyQLQueryTypes.swift
//  OSTRich
//
//  Created by snow on 9/4/23.
//

import Foundation

protocol GraphQLQuery: HTTPQuery {
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
class myActiveEventsData: Codable {
    let myActiveEvents: [Event]
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
