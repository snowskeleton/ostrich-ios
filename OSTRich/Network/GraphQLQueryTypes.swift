//
//  GraphyQLQueryTypes.swift
//  OSTRich
//
//  Created by snow on 9/4/23.
//

import Foundation

protocol OSTRichGraphQLQuery: HTTPQuery {
    /// Values to use in query
    var variables: [String: String] { get set }
    /// Name of function
    var operationName: String { get }
    /// The full string to send in the GraphQL request
    var query: String { get set }
}

extension OSTRichGraphQLQuery {
    var query: String {
        let filename = String("\(type(of: self))".split(separator: ".").last!)
        let bundle = Bundle.main.path(forResource: filename, ofType: "query")!
        let finalAnswer = try! String(contentsOfFile: bundle)
        return finalAnswer
    }
}

struct loadEvent: OSTRichGraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: loadEventData }
}
struct loadEventData: Codable {
    let event: EventV1
}

struct getGameStateV2AtRound: OSTRichGraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data:  getGameStateV2AtRoundData }
}
struct getGameStateV2AtRoundData: Codable {
    let event: EventV1
}

struct myActiveEvents: OSTRichGraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: myActiveEventsData }
}
class myActiveEventsData: Codable {
    let myActiveEvents: [EventV1]
}

struct joinEventWithShortCode: OSTRichGraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: joinEventWithShortCodeData }
}
struct joinEventWithShortCodeData: Codable {
        let joinEventWithShortCode: String
}

struct dropSelf: OSTRichGraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: dropSelfData }
}
struct dropSelfData: Codable {
    let dropSelf: String
}

struct dropTeamV2: OSTRichGraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: dropTeamV2Data }
}
struct dropTeamV2Data: Codable {
    let dropTeam: String
}

struct submitMatch: OSTRichGraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String: String] = [:]
    struct Response: Codable { let data: submitMatchData}
}
struct submitMatchData: Codable {
    let recordMatchResult: GameState
}

struct getTimer: OSTRichGraphQLQuery {
    var operationName: String
    var query: String
    var variables: [String : String] = [:]
    struct Response: Codable { let data: getTimerData }
}
struct getTimerData: Codable {
    let timer: WotcTimer
}
