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
    @State private var birthday = Date()
    @State private var someStatus: Image?
    
    @State private var alertErrorTitle: String = "Default error title"
    @State private var alertErrorMessage: String = "Default error message"
    @State private var showAlert: Bool = false
    
    @State private var showProgressView: Bool = false
    
    init() {
        if let date18YearsAgo = Calendar.current.date(byAdding: .year, value: -18, to: Date()),
           let finalDate = Calendar.current.date(byAdding: .day, value: -1, to: date18YearsAgo) {
            _birthday = State(initialValue: finalDate)
        }
//        if UserDefaults.standard.bool(forKey: "saveLoginCreds") {
//            _email = State(initialValue: UserManager.shared.currentUser?.email ?? "" )
//            _password = State(initialValue: UserManager.shared.currentUser?.password ?? "")
//        } else {
//            _email = State(initialValue: "")
//            _password = State(initialValue: "")
//        }
        
//        _firstName = State(initialValue: UserManager.shared.currentUser?.firstName ?? "")
//        _lastName = State(initialValue: UserManager.shared.currentUser?.lastName ?? "")
//        var someDisplayName = UserManager.shared.currentUser?.displayName ?? ""
//        someDisplayName = someDisplayName.components(separatedBy: ("#"))[0]
//        _displayName = State(initialValue: someDisplayName)
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
                
                
                Section{
                    DatePicker("Birth Date", selection: $birthday, displayedComponents: .date)
                } header: {
                    Text("Birthday")
                } footer: {
                    Text("You must be 18 years or older to create an account")
                }
                
                Section("Privacy Policy") {
                    Text(
                        "Account created with Wizards of the Coast, not OSTRich. Information collected during this process is not stored or processed by OSTRich. By creating an account with Wizards of the Coast, you agree to abide by their [Terms and Conditions](https://company.wizards.com/en/legal/terms), [Code of Conduct](https://company.wizards.com/en/legal/code-conduct), and [Privacy Policy](https://company.wizards.com/en/legal/wizards-coasts-privacy-policy). You can alternatively create an account on their website [here](https://myaccounts.wizards.com/register)"
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
                    let newAccount = await HTOService().register(displayName: displayName, firstName: firstName, lastName: lastName, email: email, password: password, birthday: birthday)
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
