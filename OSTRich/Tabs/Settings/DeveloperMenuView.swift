//
//  DeveloperMenuView.swift
//  OSTRich
//
//  Created by snow on 8/28/24.
//

import SwiftUI

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
                    .onChange(of: saveLoginCreds) {
                        Analytics.track(saveLoginCreds ? .enabledSaveLoginCreds : .disabledSaveLoginCreds)
                    }
            }
            Section("Troubleshooting") {
                Toggle("Show debug values in various locations throughout the app", isOn: $showDebugValues)
                    .onChange(of: showDebugValues) {
                        Analytics.track(showDebugValues ? .enabledShowDebugValues : .disabledShowDebugValues)
                    }
                Toggle("Protect from bad data causing launch crashes", isOn: $useLaunchProtection)
                    .onChange(of: useLaunchProtection) {
                        Analytics.track(useLaunchProtection ? .enabledUseLaunchProtection : .disabledUseLaunchProtection )
                    }
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
            Analytics.track(.openedDeveloperMenu)
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
