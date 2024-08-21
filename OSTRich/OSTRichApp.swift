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
            GameStateV2.self,
            DeckConstruction.self,
            Drop.self,
            Draft.self,
            EventFormat.self,
            Match.self,
            MatchResult.self,
            Player.self,
            Pod.self,
            Registration.self,
            Reservation.self,
            Round.self,
            Seat.self,
            Standing.self,
            Top8Draft.self,
            Team.self,
            ScoutingResult.self
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
//                .modelContainer(for: [Event.self])
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .inactive {
                        UserDefaults.standard.setValue(0, forKey: "timesLaunchedWithoutSafeClose")
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
