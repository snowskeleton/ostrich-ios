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
    @State var timerIsRunning = false
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
//                    ForEach(events, id: \.self) { event in
//                        NavigationLink {
//                            EventView(event: event)
//                        } label: {
//                            EventBoxView(event: event)
//                        }
//                    }
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
        }
        .onAppear {
            reLogin()
            getEvents()
            timerIsRunning = true
        }
        .onDisappear {
            timerIsRunning = false
        }
        .onReceive(Timer.publish(every: 10, on: .main, in: .common).autoconnect(), perform: { _ in
            if timerIsRunning {
                reLogin()
                getEvents()
            }
        })
        .navigationViewStyle(StackNavigationViewStyle())
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

//func pullEventData(eventId: String) {
//    HTTPClient.shared.gqlRequest(
//        requestType: loadEvent(eventId: eventId)
//    ) { (result: Result<loadEvent.Response, Error>) in
//            switch result {
//            case .success(let response):
//                print("We got these events:\n \(response.data) \n")
//            case .failure(let error):
//                print("The error we got was: \(String(describing: error))")
//            }
//    }
//
//}

struct EventBoxView: View {
    @Binding var event: Event
    var body: some View {
        VStack {
                Text("\(event.title!) | \(event.shortCode!)")
                Text(event.eventFormat!.name)
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
}


func reLogin() {
    if let loginExpieryDate = UserDefaults.standard.double(forKey: "access_token_expiry") as? Double {
        if let savedAuth = UserDefaults.standard.object(forKey: "savedAuth") as? Data {
            if let credentials = try? JSONDecoder().decode(AuthCredentials.Response.self, from: savedAuth) {
                let currentTimestamp = Date().timeIntervalSince1970
                if currentTimestamp > loginExpieryDate {
                    login(refreshToken: credentials.refresh_token)
                }
            }
        }
    }
}

public func login(with username: String = "", and password: String = "", refreshToken: String = "") {
    if username == "" && password == "" && refreshToken == "" {
        fatalError("Supply either refreshToken or username and password.")
    }
    
    var creds = AuthCredentials()
    if username != "" && password != "" {
        creds.grant_type = "password"
        creds.username = username
        creds.password = password
    } else if refreshToken != "" {
        creds.grant_type = "refresh_token"
        creds.refresh_token = refreshToken
    }
    HTTPClient.shared.httpRequest(
        requestType: creds
    ) { (result: Result<AuthCredentials.Response, Error>) in
        switch result {
        case .success(let credentials):
            if let encoded = try? JSONEncoder().encode(credentials) {
                UserDefaults.standard.set(encoded, forKey: "savedAuth")
            }
            if let futureDate = Calendar.current.date(byAdding: DateComponents(second: credentials.expires_in), to: Date()) {
                UserDefaults.standard.set(futureDate.timeIntervalSince1970, forKey: "access_token_expiry")
            }
        case .failure(let error):
            print("The error we got was: \(String(describing: error))")
        }
    }
}
