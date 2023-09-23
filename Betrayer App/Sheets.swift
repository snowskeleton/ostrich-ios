//
//  PullupSheets.swift
//  Betrayer App
//
//  Created by snow on 9/19/23.
//

import SwiftUI


struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State var email: String = ""
    @State var password: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var displayName: String = ""
    @State var showRegistration: Bool = false
    @State var birthday = Date()
    
    var body: some View {
        if let savedAuth = UserDefaults.standard.object(forKey: "savedAuth") as? Data {
            if let credentials = try? JSONDecoder().decode(AuthCredentials.Response.self, from: savedAuth) {
                Text("Logged in as \(credentials.display_name ?? "")")
            }
        }
        List {
            Toggle(isOn: $showRegistration) {
                Text("Create New Account")
            }
            if showRegistration {
                DatePicker("Birth Date", selection: $birthday, displayedComponents: .date)
                TextField("Display Name", text: $displayName)
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
            }
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            Button(action: { login() }, label: { Text(showRegistration ? "Create" : "Login") })
        }
    }
    fileprivate func login() {
        Task {
            if !showRegistration && ![email, password].contains("") {
                let authTokens = await HTOService().login(email, password)
                switch authTokens {
                case .success(let creds):
                    pickleAuthentication(creds)
                    dismiss()
                case .failure(let error):
                    print(error)
                }
            } else if ![displayName, firstName, lastName, email, password].contains("") {
                if showRegistration {
                    let newAccount = await HTOService().register(displayName: displayName, firstName: firstName, lastName: lastName, email: email, password: password, birthday: birthday)
                    switch newAccount {
                    case .success(let creds):
                        pickleAuthentication(creds.tokens)
                        dismiss()
                    case .failure(let error):
                        print("We failed somehow")
                        print(error)
                    }
                }
            }
        }
    }
}
