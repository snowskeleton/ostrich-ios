//
//  OSTRichApp.swift
//  OSTRich
//
//  Created by snow on 9/1/23.
//

import SwiftUI
import SwiftData

@main
struct OSTRichApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    @State var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Event.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            crashProtection()
            do {
                NSLog("Failed to load current schema and config. Cleraing and trying again")
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .inactive {
                        UserDefaults.standard.setValue(0, forKey: "timesLaunchedWithoutSafeClose")
                    }
                    // crash protection
//                    switch newPhase {
//                    case .active:
//                        let count = UserDefaults.standard.integer(forKey: "timesLaunchedWithoutSafeClose")
//                        if count > 3 {
//                            try? ModelContainer().deleteAllData()
//                        }
//                        UserDefaults.standard.setValue(count + 1, forKey: "timesLaunchedWithoutSafeClose")
//                        NSLog("Crash count: \(count)")
//                    case .inactive:
//                        UserDefaults.standard.setValue(0, forKey: "timesLaunchedWithoutSafeClose")
//                    default:
//                        break
//                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
