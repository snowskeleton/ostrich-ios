//
//  SettingsView.swift
//  OSTRich
//
//  Created by snow on 5/1/24.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @AppStorage("saveLoginCreds") var saveLoginCreds = false
    @AppStorage("useLaunchCrashProtection") var useLaunchProtection = true
    @AppStorage("showDebugValues") var showDebugValues = false
    @State private var showCrashConfirmation = false
    @State private var showLogout = false
    
    init() {
        _showLogout = .init(initialValue: UserManager.shared.currentUser?.loggedIn ?? false)
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    NavigationLink {
                        ChangeNameView()
                    } label: {
                        Text("Change Name")
                    }
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("Login")
                    }
                    Button("Logout") {
                        logout()
                    }
                }
                
                Toggle("Save email and password to login", isOn: $saveLoginCreds)
                Toggle("Protect from bad data causing launch crashes", isOn: $useLaunchProtection)
                Toggle("Show debug values in various locations throughout the app", isOn: $showDebugValues)
                Button("Crash!") { showCrashConfirmation = true }
                    .confirmationDialog(
                        "Crash car into a bridge",
                        isPresented: $showCrashConfirmation) {
                            Button(
                                "Watch and let it burn",
                                   role: .destructive ) {
                                fatalError()
                            }
                        }
                NavigationLink(destination: NetworkLogView()) { Text("Network Logs") }
                NavigationLink(destination: NotificationPermissionsView()) { Text("Notification Permissions") }
                Button("Clear event history") { deleteAll() }
                
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
    
    private func logout() {
        UserManager.shared.logout()
    }

}
