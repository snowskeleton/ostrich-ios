//
//  OSTRichApp.swift
//  OSTRich
//
//  Created by snow on 9/1/23.
//

import SwiftUI

@main
struct OSTRichApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
