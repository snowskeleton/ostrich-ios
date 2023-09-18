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
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var showJoinEvent = false
    @State var showAccountScreen = false
    @State var events: [Event] = []
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    showAccountScreen = true
                },label: {
                    Text("Login")
                })
                Button(action: {
                    getEvents()
                },label: {
                    Text("Get events")
                })
                
                Section {
                    ForEach($events, id: \.self) { event in
                        EventBoxView(event: event)
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
        }.navigationViewStyle(StackNavigationViewStyle())
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
                ToolbarItemGroup(placement: .destructiveAction) {
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
    public func getEvents() {
        HTTPClient.shared.gqlRequest(
            requestType: myActiveEvents()
        ) { (result: Result<myActiveEvents.Response, Error>) in
            switch result {
            case .success(let response):
                print("We got these events:\n \(response.data.myActiveEvents) \n")
                events = response.data.myActiveEvents
            case .failure(let error):
                print("The error we got was: \(String(describing: error))")
            }
        }
    }
}

struct EventBoxView: View {
    @Binding var event: Event
    var body: some View {
        VStack {
            Text("\(event.title) | \(event.shortCode)")
            Text(event.eventFormat.name)
        }
    }
}

struct JoinEventView: View {
    @Environment(\.dismiss) private var dismiss
    @State var eventCode: String = ""
    var body: some View {
        List {
            TextField("Event Code", text: $eventCode)
            Button(action: {
                joinEvent(with: eventCode)
                dismiss()
            },label: {
                Text("Join event")
            })
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext)
//    }
//}
struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationView {
            List {
                TextField("Username", text: $username)
                SecureField("passowrd", text: $password)
                Button(action: {
                    login(with: username, and: password)
                },label: {
                    Text("Login")
                })
            }
        }
    }
    public func login(with username: String, and password: String) {
        HTTPClient.shared.httpRequest(
            requestType: AuthCredentials(grant_type: "password", username: username, password: password)
        ) { (result: Result<AuthCredentials.Response, Error>) in
            switch result {
            case .success(let credentials):
                print("We got these credentials:\n \(credentials) \n")
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(credentials) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "savedAuth")
                }
            case .failure(let error):
                print("The error we got was: \(String(describing: error))")
            }
        }
    }
}
