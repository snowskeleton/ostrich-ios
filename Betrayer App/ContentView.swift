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
    @State var joinEventCode: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("New event") {
                    TextField("Event Code", text: $joinEventCode)
                    Button("Join Event", action: {
                        Task {
                            await HTOService().joinEvent(joinEventCode)
                            refreshMainPage()
                        }
                    })
                }
                Section {
                    ForEach(events, id: \.self) { event in
                        NavigationLink {
                            EventView(someEvent: event)
                            .environment(\.managedObjectContext, viewContext)
                        } label: {
                            VStack {
                                Text("\(event.title ?? "") | \(event.shortCode)")
                                Text(event.eventFormat!.name)
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
                .environment(\.managedObjectContext, viewContext)
        }
            
        .onAppear {
            refreshMainPage()
            timerIsRunning = true
        }
        .onDisappear {
            timerIsRunning = false
        }
        .onReceive(Timer.publish(every: 5, on: .main, in: .common).autoconnect(), perform: { _ in
            if timerIsRunning { refreshMainPage() }
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
    fileprivate func refreshMainPage() {
        Task {
            if let savedAuth = UserDefaults.standard.object(forKey: "savedAuth") as? Data {
                if let credentials = try? JSONDecoder().decode(AuthCredentials.Response.self, from: savedAuth) {
                    if Date().timeIntervalSince1970 > UserDefaults.standard.double(forKey: "access_token_expiry") - 10.0 { //seconds
                        switch await HTOService().refreshLogin(credentials.refresh_token) {
                        case .success(let creds):
                            pickleAuthentication(creds)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
            switch await HTOService().getActiveEvents() {
            case .success(let response):
                events = response.data.myActiveEvents
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
