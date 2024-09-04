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
    @Query private var events: [Event]

    @State var showJoinEvent = false
    @State var showAccountScreen = false
    @State var showSettingsScreen = false
    
    @State var timerIsRunning = false
    @State var joinEventCode: String = ""
    
    @AppStorage("netowrkAuthorized") var networkAuthorized = true
    
    init() {
        let predicate = #Predicate<Event> {
            $0.showOnMainView
        }
        let descriptor = FetchDescriptor<Event>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.scheduledStartTime, order: .reverse)]
        )
        _events = Query(descriptor)
    }
    
    var currentEvents: [Event] {
        return events.filter {
            $0.status != "ENDED" &&
            $0.status != "EXPIRED" &&
            $0.status != "CANCELLED"
        }
    }
    var endedEvents: [Event] {
        return events.filter {
            $0.status == "ENDED" ||
            $0.status == "EXPIRED" ||
            $0.status == "CANCELLED"
        }
    }

    var body: some View {
        NavigationView {
            List {
                Section("New event") {
                    TextField("Event Code", text: $joinEventCode)
                    Button("Join Event", action: { joinEvent() })
                }
                
                Section {
                    ForEach(currentEvents, id: \.id) { event in
                        NavigationLink {
                            EventView(event: event)
                        } label: {
                            EventRowView(event: event)
                        }
                    }.onDelete(perform: deleteItems)
                }
                DisclosureGroup("Ended Events") {
                    ForEach(endedEvents, id: \.id) { event in
                        NavigationLink {
                            EventView(event: event)
                        } label: {
                            EventRowView(event: event)
                        }
                    }.onDelete(perform: deleteItems)
                }
            }
            .toolbar {
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
            Analytics.track(.openedAllEventsView)
        }
        .onDisappear { timerIsRunning = false }
        .onReceive(Timer.publish(every: 30, on: .main, in: .common).autoconnect(), perform: { _ in
            if timerIsRunning { refreshMainPage() }
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    fileprivate func refreshMainPage() {
        GQLNetwork.getEvents(context: context)
        events.forEach { event in
            GQLNetwork.getEvent(event: event)
            GQLNetwork.getEventAsHost(event: event)
            GQLNetwork.getGameState(event: event)
        }
    }
    
    fileprivate func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let event = events[index]
                event.showOnMainView = false
            }
        }
    }
    
    fileprivate func joinEvent() {
        GQLNetwork.shared.joinEventWithShortCode(shortCode: joinEventCode) { results in
            switch results {
            case .success:
                Analytics.track(.joinEvent, with: ["shortCode": joinEventCode])
                joinEventCode = ""
                refreshMainPage()
            case .failure(let failure):
                print(failure)
            }
        }
    }
}


