//
//  PullupSheets.swift
//  OSTRich
//
//  Created by snow on 9/19/23.
//

import SwiftUI


struct LoginView: View {
//    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var email: String
    @State private var password: String
    @State private var firstName: String
    @State private var lastName: String
    @State private var displayName: String
    @State private var showRegistration: Bool = false
    @State private var birthday = Date()
    @State private var someStatus: Image?
    
    init() {
        if UserDefaults.standard.bool(forKey: "saveLoginCreds") {
            _email = State(initialValue: UserDefaults.standard.string(forKey: "email") ?? "" )
            _password = State(initialValue: UserDefaults.standard.string(forKey: "password") ?? "")
        } else {
            _email = State(initialValue: "")
            _password = State(initialValue: "")
        }
        
        _firstName = State(initialValue: UserDefaults.standard.string(forKey: "firstName") ?? "")
        _lastName = State(initialValue: UserDefaults.standard.string(forKey: "lastName") ?? "")
        var someDisplayName = UserDefaults.standard.string(forKey: "displayName") ?? ""
        someDisplayName = someDisplayName.components(separatedBy: ("#"))[0]
        _displayName = State(initialValue: someDisplayName)
    }
    
    var body: some View {
        if let displayName = UserDefaults.standard.string(forKey: "displayName") {
            Text("Magic Companion login")
            Text("Logged in as \(displayName)")
        }
        List {
            Section {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
            } header: {
                Text("Email and password")
            } footer: {
                Text("Magic Companion login")
            }

            if showRegistration {
                Section("Username") {
                    TextField("Display Name", text: $displayName)
                }
                Section("First Name") {
                    TextField("First Name", text: $firstName)
                }
                Section("Last Name") {
                    TextField("Last Name", text: $lastName)
                }
                Section("Birthday") {
                    DatePicker("Birth Date", selection: $birthday, displayedComponents: .date)
                }
                Section("Privacy Policy") {
                    Text(
                        "By creating an account with Wizards of the Coast, you agree to abide by their [Terms and Conditions](https://company.wizards.com/en/legal/terms), [Code of Conduct](https://company.wizards.com/en/legal/code-conduct), and [Privacy Policy](https://company.wizards.com/en/legal/wizards-coasts-privacy-policy)."
                    )
                }
            }
            
            Section {
                Toggle(isOn: $showRegistration) {
                    Text("Create New Account")
                }
            }
            
            Section {
                Button(showRegistration ? "Create" : "Login") { login() }
            }
//            Button("Login Server") { loginServer() }
            if UserDefaults.standard.bool(forKey: "showDebugValues") {
                HStack {
                    Button("Refresh Login") { relogin() }
                    if someStatus != nil { someStatus }
                }
            }
//            Button("Register for Notifications") { NotificationHandler.shared.getNotificationSettings() }
        }
    }
    
    fileprivate func relogin() {
        Task {
            someStatus = Image(systemName: "circle.dotted")
            await UserManager.shared.refresh()
            if
                let user = UserManager.shared.currentUser,
                user.loggedIn,
                !user.tokenExpired
            {
                someStatus = Image(systemName: "checkmark.circle")
            } else {
                someStatus = Image(systemName: "circle.slash")
            }
        }
    }
    
    fileprivate func loginServer() {
        Task {
            if !showRegistration && ![email, password].contains("") {
                let authTokens = await HTOService().login(email, password)
                switch authTokens {
                case .success(let creds):
                    let ostrichAuthTokens = await HTOService().ostrichLogin(creds.refresh_token)
                    switch ostrichAuthTokens {
                    case .success(let ostrichCreds):
                        await UserManager.shared.updateOSTRichToken(ostrichCreds)
                        dismiss()
                    case .failure(let error):
                        print("Ostrich login failed:", error)
                    }
                case .failure(let error):
                    print("Initial login failed:", error)
                }
            }
        }
    }
    
//
//    fileprivate func loginServer() {
//        Task {
//            if !showRegistration && ![email, password].contains("") {
//                let authTokens = await HTOService().login(email, password)
//                switch authTokens {
//                case .success(let creds):
//                    let ostrichAuthTokens = await HTOService().ostrichLogin(creds.refresh_token)
//                    switch ostrichAuthTokens {
//                    case .success(let ostrichCreds):
//                        await pickleOSTRichAuthentication(ostrichCreds)
//                        dismiss()
//                    case .failure(let error):
//                        print(error)
//                }
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
//    }
    
    fileprivate func login() {
        Task {
            if !showRegistration && ![email, password].contains("") {
                let authTokens = await HTOService().login(email, password)
                switch authTokens {
                case .success(let creds):
                    UserManager.shared.updateToken(creds)
                    await UserManager.shared.refreshProfile()
                    dismiss()
                case .failure(let error):
                    print(error)
                }
            } else if ![displayName, firstName, lastName, email, password].contains("") {
                if showRegistration {
                    let newAccount = await HTOService().register(displayName: displayName, firstName: firstName, lastName: lastName, email: email, password: password, birthday: birthday)
                    switch newAccount {
                    case .success(let creds):
                        UserManager.shared.updateToken(creds.tokens)
                        await UserManager.shared.refreshProfile()
                        dismiss()
                    case .failure(let error):
                        print("Couldn't create account")
                        print(error)
                    }
                }
            }
            if let user = UserManager.shared.currentUser {
                if UserDefaults.standard.bool(forKey: "saveLoginCreds") {
                    user.email = email
                    user.password = password
                    UserManager.shared.saveUser(user)
                } else {
                    user.email = ""
                    user.password = ""
                }
            }
        }
    }
//    private func deleteAll() {
//        do {
//            try context.delete(model: Event.self, includeSubclasses: true)
//            try context.save()
//        } catch {
//            print("error: \(error)")
//        }
//    }
}
