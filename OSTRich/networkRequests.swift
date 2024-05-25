//
//  networkRequests.swift
//  OSTRich
//
//  Created by snow on 9/19/23.
//

import Foundation


func refreshLogin() async {
    if let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") {
        switch await HTOService().refreshLogin(refreshToken) {
        case .success(let creds):
            await pickleAuthentication(creds)
        case .failure(let error):
            print(error)
        }
    }
}

func ostrichRefreshLogin() async {
    if let refreshToken = UserDefaults.standard.string(forKey: "ostrichRefreshToken") {
        switch await HTOService().ostrichRefreshLogin(refreshToken) {
        case .success(let creds):
            await pickleOSTRichAuthentication(creds)
        case .failure(let error):
            print(error)
        }
    }
}

func pickleAuthentication(_ creds: AuthCredentials.Response) async {
    UserDefaults.standard.removeObject(forKey: "savedAuth")
    UserDefaults.standard.set(creds.persona_id, forKey: "personaId")
    UserDefaults.standard.set(creds.refresh_token, forKey: "refreshToken")
    UserDefaults.standard.set(creds.access_token, forKey: "accessToken")
    UserDefaults.standard.set(creds.display_name, forKey: "displayName")
    switch await HTOService().getProfile() {
    case .success(let profile):
        UserDefaults.standard.set(profile.firstName, forKey: "firstName")
        UserDefaults.standard.set(profile.lastName, forKey: "lastName")
    case .failure(let failure):
        print(String(describing: failure))
    }
    if let futureDate = Calendar.current.date(byAdding: DateComponents(second: creds.expires_in), to: Date()) {
        UserDefaults.standard.set(futureDate.timeIntervalSince1970, forKey: "access_token_expiry")
    }
}

func pickleOSTRichAuthentication(_ creds: OSTRichAuthCredentials.Response) async {
    UserDefaults.standard.removeObject(forKey: "ostrichSavedAuth")
    UserDefaults.standard.set(creds.refresh_token, forKey: "ostrichRefreshToken")
    UserDefaults.standard.set(creds.access_token, forKey: "ostrichAccessToken")
    if let futureDate = Calendar.current.date(byAdding: DateComponents(second: creds.expires_in), to: Date()) {
        UserDefaults.standard.set(futureDate.timeIntervalSince1970, forKey: "ostrichAccessTokenExpiry")
    }
}
