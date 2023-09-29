//
//  ContentView.swift
//  OSTRich
//
//  Created by snow on 9/1/23.
//

import SwiftUI
import CoreData
import Foundation

@Observable class EventBook {
    var events: [Event] = []
}

struct ContentView: View {
    @Environment(EventBook.self) private var eventBook
//    @Environment(EventBook.self) private var eventBook = EventBook()
    
    @State var showJoinEvent = false
    @State var userIsLoggedIn = false
    @State var showAccountScreen = false
    @State var timerIsRunning = false
    @State var events: [Event] = []
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
                    if !eventBook.events.isEmpty {
                        NavigationLink {
                            EventView(event: eventBook.events[0])
                            //                            .environment(\.managedObjectContext, viewContext)
                        } label: {
                            VStack {
                                Text("\(eventBook.events[0].title ?? "") | \(eventBook.events[0].shortCode ?? "")")
                                Text("\(eventBook.events[0].eventFormat?.name ?? "") | \(eventBook.events[0].scheduledStartTime ?? "")")
                            }
                        }
                    }
                    ForEach(eventBook.events, id: \.scheduledStartTime) { event in
                        NavigationLink {
                            EventView(event: event)
//                            .environment(\.managedObjectContext, viewContext)
                        } label: {
                            VStack {
                                Text("\(event.title ?? "") | \(event.shortCode ?? "")")
                                Text("\(event.eventFormat?.name ?? "") | \(event.scheduledStartTime ?? "")")
                            }
                        }
                    }
                }
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
        .refreshable {
            refreshMainPage()
        }
        .sheet(isPresented: $showAccountScreen) {
            LoginView()
//                .environment(\.managedObjectContext, viewContext)
        }
            
        .onAppear {
            refreshMainPage()
            timerIsRunning = true
        }
        .onDisappear {
            timerIsRunning = false
        }
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
                    if let alreadyHave = eventBook.events.first(where: { $0.id == event.id }) {
                        print("we expected this")
                        alreadyHave.updateSelf()
                    } else {
                        print("well THAT'S new")
                        event.updateSelf()
                        eventBook.events.append(event)
                    }
                }
            case .failure(let error):
                print(error)
            }
//            for event in events {
//                switch await HTOService().getEvent(eventId: event.id) {
//                case .success(let response):
//                    let someEvent = response.data.event
//                case .failure(let failure):
//                    print(failure)
//                }
//            }
        }
    }
}

//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext)
//    }
//}
