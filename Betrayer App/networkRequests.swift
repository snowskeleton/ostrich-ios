//
//  networkRequests.swift
//  Betrayer App
//
//  Created by snow on 9/19/23.
//

import Foundation

//func reLogin() {
//    if let loginExpieryDate = UserDefaults.standard.double(forKey: "access_token_expiry") as? Double {
//        if let savedAuth = UserDefaults.standard.object(forKey: "savedAuth") as? Data {
//            if let credentials = try? JSONDecoder().decode(AuthCredentials.Response.self, from: savedAuth) {
//                let currentTimestamp = Date().timeIntervalSince1970
//                if currentTimestamp > loginExpieryDate - 10.0 { //seconds
//                    login(refreshToken: credentials.refresh_token)
//                }
//            }
//        }
//    }
//}

public func login(with username: String = "", and password: String = "", refreshToken: String = "") {
    if username == "" && password == "" && refreshToken == "" {
        fatalError("Supply either refreshToken or username and password.")
    }
    
    var creds = AuthCredentials()
    if username != "" && password != "" {
        creds.grant_type = "password"
        creds.username = username
        creds.password = password
    } else if refreshToken != "" {
        creds.grant_type = "refresh_token"
        creds.refresh_token = refreshToken
    }
    HTTPClient.shared.httpRequest(
        requestType: creds
    ) { (result: Result<AuthCredentials.Response, Error>) in
        switch result {
        case .success(let credentials):
            pickleAuthentication(credentials)
        case .failure(let error):
            print("The error we got was: \(String(describing: error))")
        }
    }
}

func pickleAuthentication(_ creds: AuthCredentials.Response) {
    print(creds)
    if let encoded = try? JSONEncoder().encode(creds) {
        UserDefaults.standard.set(encoded, forKey: "savedAuth")
        UserDefaults.standard.set(true, forKey: "loggedIn")
    }
    if let futureDate = Calendar.current.date(byAdding: DateComponents(second: creds.expires_in), to: Date()) {
        UserDefaults.standard.set(futureDate.timeIntervalSince1970, forKey: "access_token_expiry")
    }
}

public func joinEvent(with eventCode: String) {
    HTTPClient.shared.gqlRequest(joinEventWithShortCode(code: eventCode)
    ) { (result: Result<joinEventWithShortCode.Response, Error>) in
        switch result {
        case .success(let response):
            print("Joined event \(response.data.joinEventWithShortCode)")
        case .failure(let error):
            print("The error we got was: \(String(describing: error))")
        }
    }
}

