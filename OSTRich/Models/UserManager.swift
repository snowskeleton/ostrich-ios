//
//  UserManager.swift
//  OSTRich
//
//  Created by snow on 8/25/24.
//

import Foundation
import SwiftData

actor AsyncUserManager {
    static let shared = AsyncUserManager()
    
    private var refreshTask: Task<Bool, Never>? = nil
    
    func refreshTokenIfNeeded() async -> Bool {
        if let refreshTask = refreshTask {
            return await refreshTask.value
        }
        
        let task = Task { () -> Bool in
            defer { refreshTask = nil }
            
            guard let user = UserManager.shared.currentUser, user.tokenExpired else {
                return false // No need to refresh
            }
            
            await UserManager.shared.refreshToken()
            
            // Ensure the user state is re-evaluated after the refresh.
//            let user = UserManager.shared.currentUser
            return user.loggedIn == true && !user.tokenExpired
        }
        
        self.refreshTask = task
        return await task.value
    }
}

class UserManager {
    static let shared = UserManager()
     let userDefaultsKey = "user"

    private(set) var currentUser: User?

    private init() {
        loadUser()
    }

    func loadUser() {
        guard
            let userData = UserDefaults.standard.data(forKey: userDefaultsKey),
            let user = try? JSONDecoder().decode(User.self, from: userData)
        else {
            self.currentUser = User()
            return
        }
        self.currentUser = user
    }

    func saveUser() {
        if let user = UserManager.shared.currentUser {
            UserManager.shared.saveUser(user)
        }
    }
    
    func saveUser(_ user: User) {
        guard let userData = try? JSONEncoder().encode(user) else { return }
        UserDefaults.standard.set(userData, forKey: userDefaultsKey)
        self.currentUser = user
    }
    
    func refresh() async {
        if let user = UserManager.shared.currentUser {
            await self.refreshToken()
            if user.loggedIn, !user.tokenExpired {
                await self.refreshProfile()
            }
        }
    }
    
    func refreshToken() async {
        if let token = UserManager.shared.currentUser?.token {
            switch await HTOService().refreshLogin(token.refresh_token) {
            case .success(let creds):
                UserManager.shared.updateToken(creds)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshProfile() async {
        if let user = self.currentUser {
            switch await HTOService().getProfile() {
            case .success(let profile):
                user.firstName = profile.firstName
                user.lastName = profile.lastName
                user.displayName = profile.displayName
                UserManager.shared.saveUser(user)
                UserManager.shared.loadUser()
            case .failure(let failure):
                print(String(describing: failure))
            }
        } else {
            print("We couldn't get the user for some reason")
        }
    }
    
    func updateToken(_ creds: AuthCredentials.Response) {
        if let user = UserManager.shared.currentUser {
            user.token = Token(
                access_token: creds.access_token,
                refresh_token: creds.refresh_token,
                expires_in: creds.expires_in
            )
            user.displayName = creds.display_name
            user.personaId = creds.persona_id
            UserManager.shared.saveUser(user)
            UserManager.shared.loadUser()
        }
    }
    
    func logout() {
        if let user = UserManager.shared.currentUser {
            user.token = nil
            user.displayName = nil
            user.personaId = nil
            user.firstName = nil
            user.lastName = nil
            UserManager.shared.saveUser(user)
            UserManager.shared.loadUser()
        }
        Analytics.track(.logout)
    }
}

class User: Codable {
    var personaId: String?
    var displayName: String?

    // these two come from a separate endpoint
    var firstName: String?
    var lastName: String?
    
    // these two are only set if UserDefaeults key saveLoginCreds is true
    var email: String?
    var password: String?

    var token: Token?

    init() { }
    init(from response: AuthCredentials.Response) {
        self.personaId = response.persona_id
        self.token = Token(
            access_token: response.access_token,
            refresh_token: response.refresh_token,
            expires_in: response.expires_in
        )
    }
    
    var tokenExpired: Bool {
        return Date().timeIntervalSince1970 > (self.token?.expiresOn ?? 0) - 10
    }
    
    var loggedIn: Bool {
        return self.token != nil
    }
    
}

class Token: Codable {
    var access_token: String
    var refresh_token: String
    var expires_in: Int
    var expiresOn: Double?

    init(
        access_token: String,
        refresh_token: String,
        expires_in: Int
    ) {
        self.access_token = access_token
        self.expires_in = expires_in
        self.refresh_token = refresh_token
        
        if let futureDate = Calendar.current.date(byAdding: DateComponents(second: expires_in), to: Date()) {
            self.expiresOn = futureDate.timeIntervalSince1970
        }
    }
}
