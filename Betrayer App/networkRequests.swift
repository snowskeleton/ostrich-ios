//
//  networkRequests.swift
//  Betrayer App
//
//  Created by snow on 9/19/23.
//

import Foundation


func pickleAuthentication(_ creds: AuthCredentials.Response) {
    if let encoded = try? JSONEncoder().encode(creds) {
        UserDefaults.standard.set(encoded, forKey: "savedAuth")
        UserDefaults.standard.set(true, forKey: "loggedIn")
    }
    if let futureDate = Calendar.current.date(byAdding: DateComponents(second: creds.expires_in), to: Date()) {
        UserDefaults.standard.set(futureDate.timeIntervalSince1970, forKey: "access_token_expiry")
    }
}
