//
//  OSTRichApp.swift
//  OSTRich
//
//  Created by snow on 9/1/23.
//

import SwiftUI

@main
struct OSTRichApp: App {
    @State private var eventBook = EventBook()
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(eventBook)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
