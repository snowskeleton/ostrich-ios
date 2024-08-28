//
//  DeveloperMenuView.swift
//  OSTRich
//
//  Created by snow on 8/28/24.
//

import SwiftUI
import Aptabase

struct DeveloperMenuView: View {
    @Environment(\.modelContext) private var context
    @State private var showCrashConfirmation = false
    @AppStorage("saveLoginCreds") var saveLoginCreds = false
    @AppStorage("useLaunchCrashProtection") var useLaunchProtection = true
    @AppStorage("showDebugValues") var showDebugValues = false

    var body: some View {
        List {
            Section("Convenience") {
                Toggle("Save email and password to login", isOn: $saveLoginCreds)
            }
            Section("Troubleshooting") {
                Toggle("Show debug values in various locations throughout the app", isOn: $showDebugValues)
                Toggle("Protect from bad data causing launch crashes", isOn: $useLaunchProtection)
                NavigationLink(destination: NetworkLogView()) { Text("Network Logs") }
            }
            
            Section("Information") {
                NavigationLink(destination: NotificationPermissionsView()) { Text("Notification Permissions") }
            }
            
            Section("Actions") {
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
                Button("Clear event history") { deleteAll() }
            }
        }
        .onAppear {
            Aptabase.shared.trackEvent("opened_developer_menu_view")
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

#Preview {
    DeveloperMenuView()
}
