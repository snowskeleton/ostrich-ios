//
//  PullupSheets.swift
//  Betrayer App
//
//  Created by snow on 9/19/23.
//

import SwiftUI


struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
            List {
                TextField("Username", text: $username)
                SecureField("passowrd", text: $password)
                Button(action: {
                    if username != "" && password != "" {
                        login(with: username, and: password)
                        dismiss()
                    }
                },label: {
                    Text("Login")
                })
            }
        }
    }
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
