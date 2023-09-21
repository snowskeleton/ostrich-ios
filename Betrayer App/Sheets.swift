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
        List {
            Toggle(isOn: $showRegistration) {
                Text("Create New Account")
            }
            if showRegistration {
                DatePicker("Birth Date",
                           selection: $birthday,
                           displayedComponents: .date)
                TextField("Display Name", text: $displayName)
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
            }
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
            Button(action: {
                if !showRegistration && ![email, password].contains("") {
                    login(with: email, and: password)
                } else if ![displayName, firstName, lastName, email, password].contains("") {
                    if showRegistration {
                        Task {
//                            let some = try await register(displayName, firstName, lastName, email, password)
                            dismiss()
                        }
                    }
                }
                dismiss()
            },label: {
                Text(showRegistration ? "Create" : "Login")
            })
        }
    }
//    fileprivate func register(_ displayName: String,
//                              _ firstName: String,
//                              _ lastName: String,
//                              _ email: String,
//                              _ password: String) async throws -> NewAccount.Response{
//        HTTPClient.shared.httpRequest(
//            requestType: NewAccount(
//                displayName: displayName,
//                dateOfBirth: birthday.ISO8601Format().replacingOccurrences(of: "T.*Z", with: "", options: .regularExpression),
//                firstName: firstName,
//                email: email,
//                password: password,
//                country: "US",
//                lastName: lastName),
//            url: "https://api.platform.wizards.com/accounts/register"
//        ) { (result: Result<NewAccount.Response, Error>) in
//            switch result {
//            case .success(let credentials):
//                pickleAuthentication(credentials.tokens)
////                print(credentials)
//            case .failure(let error):
//                print("The error we got was: \(String(describing: error))")
//            }
//        }
//    }
}

struct JoinEventView: View {
    @Environment(\.dismiss) private var dismiss
    @State var eventCode: String = ""
    var body: some View {
        List {
            TextField("Event Code", text: $eventCode)
            Button(action: {
                joinEvent(with: eventCode)
                dismiss()
            },label: {
                Text("Join event")
            })
        }
    }
}
