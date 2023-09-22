//
//  ContentView.swift
//  Betrayer App
//
//  Created by snow on 9/1/23.
//

import SwiftUI
import CoreData
import Foundation

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext: NSManagedObjectContext
    
    @State var showJoinEvent = false
    @State var userIsLoggedIn = false
    @State var showAccountScreen = false
    @State var timerIsRunning = false
    @State var events: [Event] = []
    
    init(showJoinEvent: Bool = false,
         userIsLoggedIn: Bool = false,
         showAccountScreen: Bool = false,
         timerIsRunning: Bool = false,
         events: [Event] = []
    ) {
        _userIsLoggedIn = State(initialValue: UserDefaults.standard.bool(forKey: "userIsLoggedIn"))
        _showJoinEvent = State(initialValue: showJoinEvent)
        _showAccountScreen = State(initialValue: showAccountScreen)
        _timerIsRunning = State(initialValue: timerIsRunning)
        _events = State(initialValue: events)
    }
    
    var body: some View {
        NavigationView {
            List {
//                Button(action: {
//                    if let loginExpieryDate = UserDefaults.standard.double(forKey: "access_token_expiry") as? Double {
//                        UserDefaults.standard.set(loginExpieryDate - 900, forKey: "access_token_expiry")
//                    }
//                },label: {
//                    Text("Expire Login")
//                })
//                Button(action: {
//                    HTTPClient.shared.gqlRequest(myActiveEvents()
//                    ) { (result: Result<myActiveEvents.Response, Error>) in
//                        switch result {
//                        case .success(let response):
//                            //                print("We got these events:\n \(response.data.myActiveEvents) \n")
//                            events = response.data.myActiveEvents
//                        case .failure(let error):
//                            print("The error we got was: \(String(describing: error))")
//                        }
//                    }
//                },label: {
//                    Text("Get events")
//                })
                
                Section {
                    ForEach($events, id: \.self) { event in
                        NavigationLink {
                            EventView(event: event)
                        } label: {
                            EventBoxView(event: event)
                        }
                    }
                }
            }
        .sheet(isPresented: $showJoinEvent) {
            JoinEventView()
                .environment(\.managedObjectContext, viewContext)
        }
        .sheet(isPresented: $showAccountScreen) {
            LoginView()
                .environment(\.managedObjectContext, viewContext)
        }

        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(
                    action: { showJoinEvent = true },
                    label:  {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color.secondary)
                    }
                ).accessibilityLabel(("New Event"))
            }
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
        .onAppear {
            refreshMainPage()
            timerIsRunning = true
        }
        .onDisappear {
            timerIsRunning = false
        }
        .onReceive(Timer.publish(every: 5, on: .main, in: .common).autoconnect(), perform: { _ in
            if timerIsRunning {
                refreshMainPage()
            }
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
    fileprivate func refreshMainPage() {
        // refresh authentication
        Task {
            if let loginExpieryDate = UserDefaults.standard.double(forKey: "access_token_expiry") as? Double {
                if let savedAuth = UserDefaults.standard.object(forKey: "savedAuth") as? Data {
                    if let credentials = try? JSONDecoder().decode(AuthCredentials.Response.self, from: savedAuth) {
                        let currentTimestamp = Date().timeIntervalSince1970
                        if currentTimestamp > loginExpieryDate - 10.0 { //seconds
                            let result = await AuthenticationService().refreshLogin(credentials.refresh_token)
                            switch result {
                            case .success(let creds):
                                pickleAuthentication(creds)
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
            }
        }
        // get events
        HTTPClient.shared.gqlRequest(myActiveEvents()
        ) { (result: Result<myActiveEvents.Response, Error>) in
            switch result {
            case .success(let response):
//                print("We got these events:\n \(response.data.myActiveEvents) \n")
                events = response.data.myActiveEvents
            case .failure(let error):
                print("The error we got was: \(String(describing: error))")
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
