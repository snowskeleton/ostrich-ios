//
//  OSTRichApp.swift
//  OSTRich
//
//  Created by snow on 9/1/23.
//

import SwiftUI
import SwiftData
import Aptabase
import RevenueCat

@main
struct OSTRichApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        Aptabase.shared.initialize(
            appKey: AptabaseSecrets.appKey,
            with: InitOptions(host: AptabaseSecrets.host)
        )
        
        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: RevenueCatSecrets.apiKey)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    trackAppLaunch()
                }
                .onChange(of: scenePhase) { _, newPhase in
                    switch newPhase {
                    case .inactive:
                        UserDefaults.standard.setValue(0, forKey: "timesLaunchedWithoutSafeClose")
                    default:
                        break
                    }
                }
        }
        .modelContainer(SwiftDataManager.shared.container)
    }
    
    fileprivate func trackAppLaunch() {
        if let _ = UserDefaults.standard.object(forKey: "FirstOpen") as? Date {
            Analytics.track(.appLaunch)
        } else {
            Analytics.track(.appLaunchFirstTime)
            UserDefaults.standard.set(Date(), forKey: "FirstOpen")
        }
    }
}
