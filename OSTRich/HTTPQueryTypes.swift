//
//  HTTPQueryTypes.swift
//  OSTRich
//
//  Created by snow on 9/29/23.
//

import Foundation


protocol HTTPQuery: Codable {
    /// The format of the response to expect from the GraphQL request
    associatedtype Response: Decodable
    
    /**
     Decode a `Data` object from the GraphQL endpoint into our expected `Response` type.
     
     - Parameter data: `Data` - bytes from the network
     */
    static func decodeResponse(_ data: Data) throws -> Response
}

extension HTTPQuery {
    static func decodeResponse(_ data: Data) throws -> Response {
        try JSONDecoder().decode(Response.self, from: data)
    }
}

struct NewAccount: HTTPQuery {
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

struct AuthCredentials: HTTPQuery {
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

struct Profile: HTTPQuery {
    var firstName: String
    var lastName: String
    var displayName: String
    
    struct Response: Codable {
        let ccpaProtectData: Bool
        let dataOptIn: Bool
        let displayName: String
        let emailOptIn: Bool
        let emailVerified: Bool
        let firstName: String
        let lastName: String
        let targetedAnalyticsOptOut: Bool
    }
}


