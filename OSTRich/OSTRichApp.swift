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
    @State var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Event.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
