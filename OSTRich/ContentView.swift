//
//  ContentView.swift
//  OSTRich
//
//  Created by snow on 9/1/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var loggedIn = false
    
    init() {
        _loggedIn = .init(initialValue: !(UserManager.shared.currentUser?.loggedIn ?? false))
    }
    var body: some View {
        TabView {
            AllEventsView()
                .tabItem {
                    Label("Events", systemImage: "bus.doubledecker")
                }
            ScoutingHistoryAllPlayersView()
                .tabItem {
                    Label("Player Stats", systemImage: "person.2")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .sheet(isPresented: $loggedIn) {
            LoginView()
        }
        // this is needed to make the tabs show up properly on the iPad version for macOS
        .environment(\.horizontalSizeClass, .compact)
    }
}
