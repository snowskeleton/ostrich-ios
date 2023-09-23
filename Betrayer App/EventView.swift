//
//  EventView.swift
//  Betrayer App
//
//  Created by snow on 9/17/23.
//

import SwiftUI

struct EventView: View {
    @State var someEvent: Event
    @State private var event: Event?
    @State private var someValue: String?
    
    init(someEvent: Event) {
        _someEvent = State(initialValue: someEvent)
    }
    var body: some View {
        Text(event?.shortCode ?? "")
        Form {
            ForEach((event?.registeredPlayers) ?? [], id: \.self) { player in
                Button(action: {
                    //                    dropTeam(eventId: event.id!, teamId: player.id)
                }) {
                    Text(player.displayName)
                    Text(player.firstName)
                    Text(player.lastName)
                }
            }
            Section {
                Button(role: .destructive, action: {
//                    dropSelfFromEvent(eventId: event.id!)
                    
                }, label: {
                    Text("Drop")
                })
            }
        }
        .onAppear {
            Task { await getEvent() }
        }
//        .onReceive(Timer.publish(every: 10, on: .main, in: .common).autoconnect(), perform: { _ in
//            Task { await getEvent() }
//        })
        .navigationTitle(Text(event?.title ?? ""))
    }
    func getEvent() async {
        switch await HTOService().getEvent(eventID: someEvent.id) {
        case .success(let response):
            event = response.data.event
            print(response.data.event)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
//    func dropSelfFromEvent(eventId: String) {
//        HTTPClient.shared.gqlRequest(dropSelf(eventId: eventId)
//        ) { (result: Result<dropSelf.Response, Error>) in
//            switch result {
//            case .success(let response):
////                freshEvent = response.data
//                print("Drop self:\n \(response.data) \n")
//            case .failure(let error):
//                print("The error we got was: \(String(describing: error))")
//            }
//        }
//
//    }
//    func dropTeam(eventId: String, teamId: String) {
//        HTTPClient.shared.gqlRequest(dropTeamV2(eventId: eventId, teamId: teamId)
//        ) { (result: Result<dropTeamV2.Response, Error>) in
//            switch result {
//            case .success(let response):
////                freshEvent = response.data
//                print("Drop self:\n \(response.data) \n")
//            case .failure(let error):
//                print("The error we got was: \(String(describing: error))")
//            }
//        }
//
//    }
}

//struct EventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventView()
//    }
//}
