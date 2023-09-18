//
//  Betrayer_AppApp.swift
//  Betrayer App
//
//  Created by snow on 9/1/23.
//

import SwiftUI

@main
struct Betrayer_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
