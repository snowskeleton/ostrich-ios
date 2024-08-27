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
    @AppStorage("useLoadGameStateV2") var useGameStateV2 = true
    @AppStorage("useLaunchCrashProtection") var useLaunchProtection = true
    @AppStorage("showDebugValues") var showDebugValues = false
    @State private var showCrashConfirmation = false
    
    var body: some View {
        NavigationStack {
            List {
                Toggle("Save email and password to login", isOn: $saveLoginCreds)
                Toggle("Use new Game State method", isOn: $useGameStateV2)
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
                NavigationLink(destination: LoginView()) { Text("Login") }
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

}
