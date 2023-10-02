//
//  ContentView.swift
//  OSTRich
//
//  Created by snow on 9/1/23.
//

import SwiftUI
import Foundation
import SwiftData
import Observation

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Event.id, order: .reverse) private var events: [Event]
    
    @State var showJoinEvent = false
    @State var userIsLoggedIn = false
    @State var showAccountScreen = false
    @State var timerIsRunning = false
    @State var joinEventCode: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("New event") {
                    TextField("Event Code", text: $joinEventCode)
                    Button("Join Event", action: {
                        Task {
                            switch await HTOService().joinEvent(joinEventCode) {
                            case .success:
                                joinEventCode = ""
                                refreshMainPage()
                            case .failure(let failure):
                                print(failure)
                            }
                        }
                    })
                }
                Section {
                    ForEach(events, id: \.id) { event in
                        NavigationLink {
                            EventView(event: event)
                        } label: {
                            VStack {
                                Text("\(event.title ?? "") | \(event.shortCode ?? "")")
                                Text("\(event.eventFormat?.name ?? "") | \(event.scheduledStartTime ?? "")")
                            }
                        }
                    }
                }
            }
        .sheet(isPresented: $showAccountScreen) {
            LoginView()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(
                    action: { showAccountScreen = true },
                    label:  {
                        Image(systemName: "person.crop.circle")
                            .font(.largeTitle)
                            .foregroundColor(Color.secondary)
                    }
                ).accessibilityLabel(("Login/Logout"))
            }
        }
        }
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
                refreshLogin()
            }
            switch await HTOService().getActiveEvents() {
            case .success(let response):
                for event in response.data.myActiveEvents {
                    if let oldEvent = events.first(where: { $0.id == event.id }) {
                        oldEvent.updateSelf()
                    } else {
                        context.insert(event)
                        event.updateSelf()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext)
//    }
//}
