//
//  ContentView.swift
//  OSTRich
//
//  Created by snow on 9/1/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TabView {
                AllEventsView()
                    .tabItem {
                        Label("Events", systemImage: "bus.doubledecker")
                    }
                PlayerStatsView()
                    .tabItem {
                        Label("Player Stats", systemImage: "person.2")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            // this is needed to make the tabs show up properly on the iPad version for macOS
            .environment(\.horizontalSizeClass, .compact)
        }
    }
}
