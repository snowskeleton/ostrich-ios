//
//  OSTRichApp.swift
//  OSTRich
//
//  Created by snow on 9/1/23.
//

import SwiftUI
import SwiftData
import Aptabase

@main
struct OSTRichApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        Aptabase.shared.initialize(
            appKey: AptabaseSecrets.appKey,
            with: InitOptions(host: AptabaseSecrets.host)
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { _, newPhase in
                    switch newPhase {
                    case .inactive:
                        UserDefaults.standard.setValue(0, forKey: "timesLaunchedWithoutSafeClose")
                    case .active:
                        Analytics.track(.appLaunch)
                    default:
                        break
                    }
                }
        }
        .modelContainer(SwiftDataManager.shared.container)
    }
}
