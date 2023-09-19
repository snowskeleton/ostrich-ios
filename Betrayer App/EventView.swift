//
//  EventView.swift
//  Betrayer App
//
//  Created by snow on 9/17/23.
//

import SwiftUI

struct EventView: View {
    @Binding var event: Event
    @State var freshEvent: Event?
    
    init(event: Binding<Event>) {
        _event = event
        _freshEvent = State(initialValue: event.wrappedValue)
    }
    var body: some View {
        Form {
            Text("hello world")
            ForEach((freshEvent?.registeredPlayers) ?? [], id: \.self) { player in
                Button(action: {
                    dropTeam(eventId: event.id!, teamId: player.id)
                }) {
                Text(player.displayName)
                }
            }
            Text("\(freshEvent?.registeredPlayers?.count ?? 0)")
            Section {
                Button(role: .destructive, action: {
                    dropSelfFromEvent(eventId: event.id!)
                    
                }, label: {
                    Text("Drop")
                })
            }
        }
        .onAppear {
            print(event.id!)
            pullEventData(eventId: event.id!)
        }
        .navigationTitle(Text(event.title!))
    }
    func pullEventData(eventId: String) {
        HTTPClient.shared.gqlRequest(loadEvent(eventId: eventId)
        ) { (result: Result<loadEvent.Response, Error>) in
            switch result {
            case .success(let response):
                freshEvent = response.data.event
                //                print("Event data:\n \(response.data.event) \n")
            case .failure(let error):
                print("The error we got was: \(String(describing: error))")
            }
        }
        
    }
    func dropSelfFromEvent(eventId: String) {
        HTTPClient.shared.gqlRequest(dropSelf(eventId: eventId)
        ) { (result: Result<dropSelf.Response, Error>) in
            switch result {
            case .success(let response):
//                freshEvent = response.data
                print("Drop self:\n \(response.data) \n")
            case .failure(let error):
                print("The error we got was: \(String(describing: error))")
            }
        }
        
    }
    func dropTeam(eventId: String, teamId: String) {
        HTTPClient.shared.gqlRequest(dropTeamV2(eventId: eventId, teamId: teamId)
        ) { (result: Result<dropTeamV2.Response, Error>) in
            switch result {
            case .success(let response):
//                freshEvent = response.data
                print("Drop self:\n \(response.data) \n")
            case .failure(let error):
                print("The error we got was: \(String(describing: error))")
            }
        }
        
    }
}

//struct EventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventView()
//    }
//}
