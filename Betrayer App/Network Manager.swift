//
//  Network Manager.swift
//  Betrayer App
//
//  Created by snow on 9/4/23.
//

import Foundation


enum HTOEndpoint {
    case login(email: String, password: String)
    case refreshLogin(refreshToken: String)
    case register(displayName: String, firstName: String, lastName: String, email: String, password: String, birthday: Date)
    
    case myActiveEvents
    case loadEvent(eventID: String)
    case joinEventWithShortCode(code: String)
}

extension HTOEndpoint: Endpoint {
    var path: String {
        switch self {
        case .login, .refreshLogin:
            return "/auth/oauth/token"
        case .register:
            return "/accounts/register"
        default:
            return "/silverbeak-griffin-service/graphql"
        }
    }
    
    var host: String {
        switch self {
        case .login, .refreshLogin, .register:
            return "api.platform.wizards.com"
        default:
            return "api.tabletop.wizards.com"
        }
    }
    
    var method: RequestMethod {
        switch self {
        default:
            return .post
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .login, .register, .refreshLogin:
            return [
                "Authorization": "Basic \(basicCredentialsBase64)",
                "Content-Type": "application/json"
            ]
        default:
            var headers: [String: String] = [:]
            if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
                headers = [
                    "Authorization": "Bearer \(accessToken)",
                    "Content-Type": "application/json"
                ]
            }
            return headers
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return [
                "grant_type": "password",
                "username": email,
                "password": password
            ]
        case .refreshLogin(let refreshToken):
            return [
                "grant_type": "refresh_token",
                "refresh_token": refreshToken
            ]
        case .register(let displayName, let firstName, let lastName, let email, let password, let birthday):
            return [
                "dateOfBirth": birthday.ISO8601Format().replacingOccurrences(of: "T.*Z", with: "", options: .regularExpression), // yyyy-MM-dd
                "displayName": displayName,
                "email": email,
                "firstName": firstName,
                "lastName": lastName,
                "password": password,
                "country": "US",
                "acceptedTC": true,
                "emailOptIn": false,
                "dataShareOptIn": true
            ]
        case .loadEvent(let eventID):
            return [
                "operationName": self.operationName,
                "query": self.query!,
                "variables": ["eventId": eventID]
            ]
        case .joinEventWithShortCode(let shortcode):
            return [
                "operationName": self.operationName,
                "query": self.query!,
                "variables": ["shortCode": shortcode]
            ]
        default:
            return [
                "operationName": self.operationName,
                "query": self.query!,
                "variables": [:] as [String: String]
            ]
        }
    }
    var operationName: String {
        return String("\(self)".split(separator: "(").first!)
    }
    var query: String? {
        return try! String(contentsOfFile: Bundle.main.path(forResource: self.operationName, ofType: "query")!)
    }
}
protocol HTOServiceable {
    func login(_ email: String, _ password: String) async -> Result<AuthCredentials.Response, RequestError>
    func refreshLogin(_ refreshToken: String) async -> Result<AuthCredentials.Response, RequestError>
    func register(displayName: String, firstName: String, lastName: String, email: String, password: String, birthday: Date) async -> Result<NewAccount.Response, RequestError>
    
    func joinEvent(_ shortcode: String) async -> Result<joinEventWithShortCode.Response, RequestError>
    
    func getActiveEvents() async -> Result<myActiveEvents.Response, RequestError>
    func getEvent(eventID: String) async -> Result<loadEvent.Response, RequestError>
    
}

struct HTOService: HTTPClient, HTOServiceable {
    func getEvent(eventID: String) async -> Result<loadEvent.Response, RequestError> {
        return await sendRequest(endpoint: HTOEndpoint.loadEvent(eventID: eventID), responseModel: loadEvent.Response.self)
    }
    
    func getActiveEvents() async -> Result<myActiveEvents.Response, RequestError> {
        return await sendRequest(endpoint: HTOEndpoint.myActiveEvents, responseModel: myActiveEvents.Response.self)
    }
    
    func joinEvent(_ shortcode: String) async -> Result<joinEventWithShortCode.Response, RequestError> {
        return await sendRequest(endpoint: HTOEndpoint.joinEventWithShortCode(code: shortcode), responseModel: joinEventWithShortCode.Response.self)
    }
    
    func register(displayName: String, firstName: String, lastName: String, email: String, password: String, birthday: Date) async -> Result<NewAccount.Response, RequestError> {
        return await sendRequest(
            endpoint: HTOEndpoint.register(
                displayName: displayName,
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                birthday: birthday),
            responseModel: NewAccount.Response.self)
    }
    
    func login(_ email: String, _ password: String) async -> Result<AuthCredentials.Response, RequestError> {
        return await sendRequest(endpoint: HTOEndpoint.login(email: email, password: password), responseModel: AuthCredentials.Response.self)
    }
    
    func refreshLogin(_ refreshToken: String) async -> Result<AuthCredentials.Response, RequestError> {
        return await sendRequest(endpoint: HTOEndpoint.refreshLogin(refreshToken: refreshToken), responseModel: AuthCredentials.Response.self)
    }
}

let basicCredentials = "REDACTED"
let basicCredentialsBase64 = "REDACTED"
