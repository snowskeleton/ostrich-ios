//
//  AllEventsView.swift
//  OSTRich
//
//  Created by snow on 8/21/24.
//


import SwiftUI
import Foundation
import SwiftData
import Observation

struct AllEventsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Event.scheduledStartTime, order: .reverse) private var events: [Event]
    
    @State var showJoinEvent = false
    @State var showScoutingStats = false
    @State var showAccountScreen = false
    @State var showSettingsScreen = false
    
    @State var userIsLoggedIn = false
    @State var timerIsRunning = false
    @State var joinEventCode: String = ""
    
    @AppStorage("netowrkAuthorized") var networkAuthorized = true

    var body: some View {
        NavigationView {
            List {
                Section("New event") {
                    TextField("Event Code", text: $joinEventCode)
                    Button("Join Event", action: { joinEvent() })
                }
                
                Section {
                    ForEach(events, id: \.id) { event in
                        NavigationLink {
                            EventView(event: event)
                        } label: {
                            EventRow(event: event)
                        }
                    }.onDelete(perform: deleteItems)
                }
            }
            .sheet(isPresented: $showScoutingStats) {
                PlayerStatsView()
            }
            .sheet(isPresented: $showAccountScreen) {
                LoginView()
            }
            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button(
//                        action: { showAccountScreen = true },
//                        label:  {
//                            Image(systemName: "person.crop.circle")
//                                .font(.largeTitle)
//                                .foregroundColor(Color.secondary)
//                        }
//                    ).accessibilityLabel(("Login/Logout"))
//                }
                
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem {
                    if !networkAuthorized {
                        Text("Please login")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                }
                ToolbarItem {
                    Spacer()
                }
            }
        }
//        .onLaunchWithNotification { notification in
//            chatThreadToLaunch = notification.id
//            launchedWithNotification = true
//        }
//        .onForegroundNotification { notification in
//            print("Notification while in foreground")
//            print(notification.request.content.userInfo)
//        }

        .refreshable { refreshMainPage() }
        .onAppear {
            refreshMainPage()
            timerIsRunning = true
        }
        .onDisappear { timerIsRunning = false }
        .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect(), perform: { _ in
            if timerIsRunning { refreshMainPage() }
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    fileprivate func refreshMainPage() {
        Task {
            if Date().timeIntervalSince1970 > UserDefaults.standard.double(forKey: "access_token_expiry") - 40.0 { //seconds
                await refreshLogin()
            }
//            if Date().timeIntervalSince1970 > UserDefaults.standard.double(forKey: "ostrichAccessTokenExpiry") - 40 { //seconds
//                await ostrichRefreshLogin()
//            }
            Network.getEvents(context: context)
            events.forEach { event in
                Network.getEvent(event: event)
                Network.getEventAsHost(event: event)
                Network.getGameState(event: event)
            }
        }
    }
    
    fileprivate func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { events[$0] }.forEach(context.delete)
        }
    }
    
    fileprivate func joinEvent() {
        Task {
            switch await HTOService().joinEvent(joinEventCode) {
            case .success:
                joinEventCode = ""
                refreshMainPage()
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

struct EventRow: View {
    var event: Event
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                if let pairingType = event.pairingType {
                    Text(pairingType)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let status = event.status {
                    Text(status)
                        .font(.subheadline)
                        .foregroundColor(status == "Active" ? .green : .red)
                }
                
                HStack {
                    if event.isOnline == true {
                        Image(systemName: "globe")
                            .foregroundColor(.blue)
                    } else {
                        Image(systemName: "person.2")
                            .foregroundColor(.gray)
                    }
                    
                    Text(event.createdBy ?? "Unknown")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            VStack {
                Text("\(event.requiredTeamSize)")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(Color(.systemBlue))
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}
