//
//  ResponseTypes.swift
//  Betrayer App
//
//  Created by snow on 9/4/23.
//

import Foundation

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


struct AuthCredentials: Query {
    let grant_type: String
    let username: String
    let password: String
    
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


struct APIResponse<T: Decodable>: Decodable {
    let data: T
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
struct Event: Codable, Hashable {
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
    
    let id: String
    let shortCode: String
    let createdBy: String
    let title: String
    let scheduledStartTime: String
    let actualStartTime: String?
    let eventFormat: EventFormat
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

