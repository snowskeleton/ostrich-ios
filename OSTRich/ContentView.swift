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
    
    @ObservedObject var userManager = UserManager.shared

    var body: some View {
        TabView {
            AllEventsView()
                .tabItem {
                    Label("Events", systemImage: "person.line.dotted.person.fill")
                }
            ScoutingHistoryView()
                .tabItem {
                    Label("Metagame", systemImage: "chart.bar.xaxis")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .sheet(isPresented: $loggedIn) {
            LoginView()
        }
        .onAppear {
            loggedIn = !(userManager.currentUser?.loggedIn ?? true)
        }
        .onReceive(userManager.$currentUser) { newValue in
            loggedIn = !(newValue?.loggedIn ?? true)
        }
        // this is needed to make the tabs show up properly on the iPad version for macOS
        .environment(\.horizontalSizeClass, .compact)
    }
}
