//
//  networkRequests.swift
//  Betrayer App
//
//  Created by snow on 9/19/23.
//

import Foundation


func pickleAuthentication(_ creds: AuthCredentials.Response) {
//        UserDefaults.standard.set(encoded, forKey: "savedAuth")
    UserDefaults.standard.removeObject(forKey: "savedAuth")
    UserDefaults.standard.set(creds.persona_id, forKey: "personaId")
    UserDefaults.standard.set(creds.refresh_token, forKey: "refreshToken")
    UserDefaults.standard.set(creds.access_token, forKey: "accessToken")
    UserDefaults.standard.set(creds.display_name, forKey: "displayName")
    if let futureDate = Calendar.current.date(byAdding: DateComponents(second: creds.expires_in), to: Date()) {
        UserDefaults.standard.set(futureDate.timeIntervalSince1970, forKey: "access_token_expiry")
    }
}
