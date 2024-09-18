//
//  PullupSheets.swift
//  OSTRich
//
//  Created by snow on 9/19/23.
//

import SwiftUI


struct LoginView: View {
    //https://stackoverflow.com/a/78982717/13919791
    @Environment(\.presentationMode) var mode
    
    @State private var email: String = UserManager.shared.currentUser?.email ?? ""
    @State private var password: String = UserManager.shared.currentUser?.password ?? ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var displayName: String = ""
    @State private var showRegistration: Bool = false
    @State private var isOver18: Bool = false
    @State private var agreeToTerms: Bool = false
    @State private var someStatus: Image?
    
    @State private var alertErrorTitle: String = "Default error title"
    @State private var alertErrorMessage: String = "Default error message"
    @State private var showAlert: Bool = false
    
    @State private var showProgressView: Bool = false
    
    
    var requiredFieldsEmpty: Bool {
        if showRegistration {
            return email.isEmpty ||
            password.isEmpty ||
            firstName.isEmpty ||
            lastName.isEmpty ||
            displayName.isEmpty ||
            !isOver18 ||
            !agreeToTerms
        } else {
            return email.isEmpty ||
            password.isEmpty
        }
    }
    
    var body: some View {
        if let displayName = UserManager.shared.currentUser?.displayName {
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
            
            Section {
                Toggle(isOn: $showRegistration) {
                    Text("Create New Account")
                }
            }
            

            if showRegistration {
                Section {
                    TextField("Display Name", text: $displayName)
                } header: {
                    Text("Username")
                } footer: {
                    Text("Warning: you can't change this later")
                }
                
                Section {
                    TextField("First", text: $firstName)
                    TextField("Last", text: $lastName)
                } header: {
                    Text("Full name")
                } footer: {
                    Text("Change anytime from Settings")
                }
                
                Section("Terms of Use") {
                    Toggle(isOn: $isOver18) {
                        Text("I am over 18 years of age")
                    }
                    Toggle(isOn: $agreeToTerms) { Text("Agree") }
                    Text(
                        "Account created with Wizards of the Coast, not OSTRich. Information collected during this process is not stored or processed by OSTRich, but may be stored or processed by Wizards of the Coast. By creating an account with Wizards of the Coast, you agree to abide by their [Terms and Conditions](https://company.wizards.com/en/legal/terms), [Code of Conduct](https://company.wizards.com/en/legal/code-conduct), and [Privacy Policy](https://company.wizards.com/en/legal/wizards-coasts-privacy-policy). You can alternatively create an account on their website [here](https://myaccounts.wizards.com/register)"
                    )
                    .font(.caption)
                }
            }
            
            Section {
                Button(showRegistration ? "Create" : "Login") { login() }
                    .disabled(requiredFieldsEmpty)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(alertErrorTitle),
                            message: Text(alertErrorMessage)
                        )
                    }
            }
//            Button("Login Server") { loginServer() }
            if UserDefaults.standard.bool(forKey: "showDebugValues") {
                HStack {
                    Button("Refresh Login") { relogin() }
                    if someStatus != nil { someStatus }
                }
            }
             
            Section {
                if email.lowercased() == AppStoreTesting.testString {
                    NavigationLink {
                        CreateFakeEventView()
                    } label: {
                        Text("Create data for testing")
                    }
                }
            }
//            Button("Register for Notifications") { NotificationHandler.shared.getNotificationSettings() }
        }
        .overlay {
            if showProgressView {
                ProgressView()
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
                    .background(Color.gray)
                    .opacity(0.5)
            }
        }
        .navigationBarTitle(showRegistration ? "Register" : "Login", displayMode: .inline)
    }
    
    fileprivate func relogin() {
        Task {
            showProgressView = true
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
            showProgressView = false
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
                        mode.wrappedValue.dismiss()
                    case .failure(let error):
                        print("Ostrich login failed:", error)
                    }
                case .failure(let error):
                    print("Initial login failed:", error)
                }
            }
        }
    }
    
    fileprivate func login() {
        Task {
            showProgressView = true
            if !showRegistration && ![email, password].contains("") {
                let authTokens = await HTOService().login(email, password)
                switch authTokens {
                case .success(let creds):
                    UserManager.shared.updateToken(creds)
                    await UserManager.shared.refreshProfile()
                    mode.wrappedValue.dismiss()
                case .failure(let error):
                    print(error)
                    alertErrorTitle = "Login Failed"
                    alertErrorMessage = error.customMessage
                    showAlert = true
                }
            } else if ![displayName, firstName, lastName, email, password].contains("") {
                if showRegistration {
                    // app review doesn't want me asking for user's birthday, so we're making one up
                    let date19YearsAgo = Calendar.current.date(
                        byAdding: .year,
                        value: -19,
                        to: Date()
                    )!
                                
                    let newAccount = await HTOService().register(
                        displayName: displayName,
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password,
                        birthday: date19YearsAgo
                    )
                    switch newAccount {
                    case .success(let creds):
                        UserManager.shared.updateToken(creds.tokens)
                        await UserManager.shared.refreshProfile()
                        mode.wrappedValue.dismiss()
                    case .failure(let error):
                        print(error)
                        alertErrorTitle = "Create Account Failed"
                        alertErrorMessage = error.customMessage
                        showAlert = true
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
            showProgressView = false
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
