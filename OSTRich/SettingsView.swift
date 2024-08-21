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
        List {
            Toggle(isOn: $saveLoginCreds) {
                Text("Save email and password to login")
            }
            Toggle(isOn: $useGameStateV2) {
                Text("Use new Game State method")
            }
            Toggle(isOn: $useLaunchProtection) {
                Text("Protect from bad data causing launch crashes")
            }
            Toggle(isOn: $showDebugValues) {
                Text("Show debug values in various locations throughout the app")
            }
            Button("Crash!") {
                showCrashConfirmation = true
            }
            .confirmationDialog(
                "Crash car into a bridge",
                isPresented: $showCrashConfirmation) {
                    Button("Watch and let it burn", role: .destructive) {
                        fatalError()
                    }
            }
            NavigationLink(destination: NetworkLogView()) {
                Text("Network Logs")
            }
            NavigationLink(destination: LoginView()) {
                Text("Login")
            }
            Button("Clear event history") { deleteAll() }

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
