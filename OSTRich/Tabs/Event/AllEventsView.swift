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
import Aptabase

struct AllEventsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Event.scheduledStartTime, order: .reverse) private var events: [Event]
    
    @State var showJoinEvent = false
    @State var showAccountScreen = false
    @State var showSettingsScreen = false
    
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
            offsets.map { events[$0] }.forEach(context.delete)
        }
    }
    
    fileprivate func joinEvent() {
        GQLNetwork.shared.joinEventWithShortCode(shortCode: joinEventCode) { results in
            switch results {
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
    
    var statusColor: Color {
        if let status = event.status {
            switch status {
            case "ROUNDACTIVE":
                return .blue
            case "ENDED":
                return .red
            default:
                return .yellow
            }
        }
        return .yellow
    }
    
    var body: some View {
        HStack {
            VStack {
                if let scheduledStartTime = event.scheduledStartTime {
                    Text(convertToLocalTime(scheduledStartTime))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text(convertToLocalDate(scheduledStartTime))
                        .font(.caption2)
                        .foregroundColor(.primary.opacity(0.8))
                    
                } else {
                    Text("None")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            .padding(14)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color.secondary,
                    Color.primary
                ]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing
                )
                .opacity(0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 30))
//            .clipShape(Circle())
            .shadow(
                color: Color.black.opacity(0.6),
                radius: 10, x: 0, y: 5
            )
            
            VStack(alignment: .leading) {
                Text(event.title)
                    .foregroundColor(.primary)
                    .font(.title2)
                    .fontWeight(.bold)

                if let status = event.status {
                    Text(status)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(4)
                        .foregroundColor(statusColor)
                }
            }
        }
    }
    
    func convertToLocalDate(_ utcTime: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        
        // Attempt to parse with fractional seconds
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        var date = dateFormatter.date(from: utcTime)
        
        // If parsing fails, try without fractional seconds
        if date == nil {
            dateFormatter.formatOptions = [.withInternetDateTime]
            date = dateFormatter.date(from: utcTime)
        }
        
        if let date = date {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            
            return formatter.localizedString(for: date, relativeTo: Date.now)
        }
        
        return "Invalid"
    }
    func convertToLocalTime(_ utcTime: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        
        // Attempt to parse with fractional seconds
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        var date = dateFormatter.date(from: utcTime)
        
        // If parsing fails, try without fractional seconds
        if date == nil {
            dateFormatter.formatOptions = [.withInternetDateTime]
            date = dateFormatter.date(from: utcTime)
        }
        
        if let date = date {
            let localFormatter = DateFormatter()
            localFormatter.timeStyle = .short
            localFormatter.timeZone = .current
            
            return localFormatter.string(from: date)
        }
        
        return "Invalid date"
    }
}
