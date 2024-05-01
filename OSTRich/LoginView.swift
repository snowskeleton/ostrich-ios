//
//  PullupSheets.swift
//  OSTRich
//
//  Created by snow on 9/19/23.
//

import SwiftUI


struct LoginView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State var email: String = UserDefaults.standard.bool(forKey: "saveLoginCreds") ? UserDefaults.standard.string(forKey: "email") ?? "" : ""
    @State var password: String = UserDefaults.standard.bool(forKey: "saveLoginCreds") ? UserDefaults.standard.string(forKey: "password") ?? "" : ""
    @State var firstName: String = UserDefaults.standard.string(forKey: "firstName") ?? ""
    @State var lastName: String = UserDefaults.standard.string(forKey: "lastName") ?? ""
    @State var displayName: String = UserDefaults.standard.string(forKey: "displayName") ?? ""
    @State var showRegistration: Bool = false
    @State var birthday = Date()
    @State var someStatus: Image?
    
    var body: some View {
        if let displayName = UserDefaults.standard.string(forKey: "displayName") {
            Text("Logged in as \(displayName)")
        }
        List {
            Section(showRegistration ? "New Account" : "Login") {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                Toggle(isOn: $showRegistration) {
                    Text("Create New Account")
                }
                if showRegistration {
                    TextField("Display Name", text: $displayName)
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    DatePicker("Birth Date", selection: $birthday, displayedComponents: .date)
                    Text("By creating an account with Wizards of the Coast, you agree to abide by their [Terms and Conditions](https://company.wizards.com/en/legal/terms), [Code of Conduct](https://company.wizards.com/en/legal/code-conduct), and [Privacy Policy](https://company.wizards.com/en/legal/wizards-coasts-privacy-policy).")
                }
                Button(showRegistration ? "Create" : "Login") { login() }
                HStack {
                    Button("Refresh Login") { relogin() }
                    if someStatus != nil { someStatus }
                }
            }
            Section("Change Name") {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                Button("Save") { changeName() }
            }
            Button("Clear event history") { deleteAll() }
        }
    }
    fileprivate func relogin() {
        someStatus = Image(systemName: "circle.dotted")
        Task {
            if let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") {
                switch await HTOService().refreshLogin(refreshToken) {
                case .success(let creds):
                    await pickleAuthentication(creds)
                    someStatus = Image(systemName: "checkmark.circle")
                case .failure:
                    someStatus = Image(systemName: "circle.slash")
                }
            }
        }
    }
    fileprivate func login() {
        Task {
            if !showRegistration && ![email, password].contains("") {
                let authTokens = await HTOService().login(email, password)
                switch authTokens {
                case .success(let creds):
                    await pickleAuthentication(creds)
                    dismiss()
                case .failure(let error):
                    print(error)
                }
            } else if ![displayName, firstName, lastName, email, password].contains("") {
                if showRegistration {
                    let newAccount = await HTOService().register(displayName: displayName, firstName: firstName, lastName: lastName, email: email, password: password, birthday: birthday)
                    switch newAccount {
                    case .success(let creds):
                        await pickleAuthentication(creds.tokens)
                        dismiss()
                    case .failure(let error):
                        print("Couldn't create account")
                        print(error)
                    }
                }
            }
            if UserDefaults.standard.bool(forKey: "saveLoginCreds") {
                UserDefaults.standard.setValue(email, forKey: "email")
                UserDefaults.standard.setValue(password, forKey: "password")
            } else {
                UserDefaults.standard.setValue("", forKey: "email")
                UserDefaults.standard.setValue("", forKey: "password")
            }
            deleteAll()
        }
    }
    fileprivate func changeName() {
        Task {
            switch await HTOService().changeName(firstName: firstName, lastName: lastName) {
            case .success:
                dismiss()
            case .failure(let error):
                print(error)
            }
        }
    }
    private func deleteAll() {
        do {
            try context.delete(model: Event.self, includeSubclasses: true)
            try context.save()
        } catch {
            print("error: \(error)")
        }
    }
}
