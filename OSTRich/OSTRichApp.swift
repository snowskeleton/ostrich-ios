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
        Aptabase.shared.initialize(appKey: "A-SH-8446942175") // 👈 this is where you enter your App Key
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .modelContainer(for: [Event.self])
                .onChange(of: scenePhase) { _, newPhase in
                    switch newPhase {
                    case .inactive:
                        UserDefaults.standard.setValue(0, forKey: "timesLaunchedWithoutSafeClose")
                    case .active:
                        Aptabase.shared.trackEvent("app_started")
                    default:
                        break
                    }
                }
        }
        .modelContainer(SwiftDataManager.shared.container)
    }
}
