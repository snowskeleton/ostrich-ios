//
//  SettingsView.swift
//  OSTRich
//
//  Created by snow on 5/1/24.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    @AppStorage("saveLoginCreds") var saveLoginCreds = false
    @AppStorage("useLoadGameStateV2") var useGameStateV2 = true
    @State private var showCrashConfirmation = false
    
    var body: some View {
        List {
            Toggle(isOn: $saveLoginCreds) {
                Text("Save email and password to login")
            }
            Toggle(isOn: $useGameStateV2) {
                Text("Use new Game State method")
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
        }
    }
}
