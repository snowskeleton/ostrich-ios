//
//  SettingsView.swift
//  OSTRich
//
//  Created by snow on 5/1/24.
//

import Foundation
import SwiftUI
import Aptabase


struct SettingsView: View {
//    @Environment(\.modelContext) private var context
    @State private var showLogout = false
    @AppStorage("showDeveloperMenu") var showDeveloperMenu = false

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
                
                Toggle("Show Developer Menu", isOn: $showDeveloperMenu)
                
                if showDeveloperMenu {
                    NavigationLink {
                        DeveloperMenuView()
                    } label: {
                        Text("Developer Menu")
                    }
                }
                
            }
        }
    }
    
    private func logout() {
        UserManager.shared.logout()
    }

}
