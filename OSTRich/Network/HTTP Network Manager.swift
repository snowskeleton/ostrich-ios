//
//  HTTP Network Manager.swift
//  OSTRich
//
//  Created by snow on 9/4/23.
//

import Foundation
import SwiftUI
import Aptabase


enum HTOEndpoint {
    case login(email: String, password: String)
    case refreshLogin(refreshToken: String)
    case register(displayName: String, firstName: String, lastName: String, email: String, password: String, birthday: Date)
    case changeName(firstName: String, lastName: String)
    case getProfile
    
//    case joinEventWithShortCode(code: String)
//    case dropSelf(eventId: String)

    case ostrichLogin(wotcRefreshToken: String)
    case ostrichRefreshLogin(refreshToken: String)
    case ostrichRegisterDevice(push_token: String, device_id: String)
}

extension HTOEndpoint: Endpoint {
    var path: String {
        switch self {
        case .login, .refreshLogin:
            return "/auth/oauth/token"
        case .changeName, .getProfile:
            return "/profile"
        case .register:
            return "/accounts/register"
        case .ostrichLogin, .ostrichRefreshLogin:
            return "/token"
        case .ostrichRegisterDevice:
            return "/register-device"
//        default:
//            return "/silverbeak-griffin-service/graphql"
        }
    }
    
    var host: String {
        switch self {
        case .login, .refreshLogin, .register, .changeName, .getProfile:
            return "api.platform.wizards.com"
        case .ostrichLogin, .ostrichRefreshLogin, .ostrichRegisterDevice:
            return "ostrich.snowskeleton.net"
//        default:
//            return "api.tabletop.wizards.com"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getProfile:
            return .get
        case .changeName:
            return .put
        default:
            return .post
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .login, .register, .refreshLogin:
            return [
                "Authorization": "Basic \(WotcCreds.basicCredentialsBase64)",
                "Content-Type": "application/json"
            ]
        case .ostrichLogin, .ostrichRefreshLogin:
            return [
                "Content-Type": "application/json"
            ]
        case .ostrichRegisterDevice:
            guard let accessToken = UserDefaults.standard.string(forKey: "ostrichAccessToken") else {
                print("Couldn't find key: ostrichAccessToken in UserDefaults")
                return [:]
            }
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json",
            ]
        default:
            guard let accessToken = UserManager.shared.currentUser?.token?.access_token else {
                print("Couldn't find key: accessToken in UserDefaults")
                return [:]
            }
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json"
            ]

        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .ostrichLogin(let token):
            return [
                "wotc_login_token": token
            ]
        case .ostrichRefreshLogin(let token):
            return [
                "refresh_token": token
            ]
        case .ostrichRegisterDevice(let token, let device_id):
            return [
                "device_id": device_id,
                "apns_token": token,
            ]
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
        case .changeName(let firstName, let lastName):
            return [
                "firstName": firstName,
                "lastName": lastName
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
        let path = Bundle.main.path(forResource: self.operationName, ofType: "query")
        if path != nil {
            return try! String(contentsOfFile: path!)
        } else {
            return self.operationName
        }
//        return try! String(contentsOfFile: Bundle.main.path(forResource: self.operationName, ofType: "query") ?? "")
    }
}
protocol HTOServiceable {
    func login(_ email: String, _ password: String) async -> Result<AuthCredentials.Response, RequestError>
    func refreshLogin(_ refreshToken: String) async -> Result<AuthCredentials.Response, RequestError>
    func register(displayName: String, firstName: String, lastName: String, email: String, password: String, birthday: Date) async -> Result<NewAccount.Response, RequestError>
    func changeName(firstName: String, lastName: String) async -> Result<Profile.Response, RequestError>
    func getProfile() async -> Result<Profile.Response, RequestError>
}

struct HTOService: HTTPClient, HTOServiceable {
    func getProfile() async -> Result<Profile.Response, RequestError> {
        return await sendRequest(endpoint: HTOEndpoint.getProfile, responseModel: Profile.Response.self)
    }
    
    func changeName(firstName: String, lastName: String) async -> Result<Profile.Response, RequestError> {
        Aptabase.shared.trackEvent("change_name")
        return await sendRequest(endpoint: HTOEndpoint.changeName(firstName: firstName, lastName: lastName), responseModel: Profile.Response.self)
    }
    
    func register(displayName: String, firstName: String, lastName: String, email: String, password: String, birthday: Date) async -> Result<NewAccount.Response, RequestError> {
        Aptabase.shared.trackEvent("register_new_account")
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
        Aptabase.shared.trackEvent("login")
        return await sendRequest(endpoint: HTOEndpoint.login(email: email, password: password), responseModel: AuthCredentials.Response.self)
    }
    
    func refreshLogin(_ refreshToken: String) async -> Result<AuthCredentials.Response, RequestError> {
        return await sendRequest(endpoint: HTOEndpoint.refreshLogin(refreshToken: refreshToken), responseModel: AuthCredentials.Response.self)
    }
    
    func ostrichLogin(_ wotcRefreshToken: String) async -> Result<OSTRichAuthCredentials.Response, RequestError> {
        return await sendRequest(endpoint: HTOEndpoint.ostrichLogin(wotcRefreshToken: wotcRefreshToken), responseModel: OSTRichAuthCredentials.Response.self)
    }
    
    func ostrichRefreshLogin(_ refreshToken: String) async -> Result<OSTRichAuthCredentials.Response, RequestError> {
        return await sendRequest(endpoint: HTOEndpoint.ostrichRefreshLogin(refreshToken: refreshToken), responseModel: OSTRichAuthCredentials.Response.self)
    }
    
    func ostrichRegisterDevice(_ apns_token: String, _ device_id: String) async -> Result<OSTRichRegisterDevice.Response, RequestError> {
        return await sendRequest(endpoint: HTOEndpoint.ostrichRegisterDevice(push_token: apns_token, device_id: device_id), responseModel: OSTRichRegisterDevice.Response.self)
    }
}
