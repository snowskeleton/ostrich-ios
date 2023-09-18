//
//  EventView.swift
//  Betrayer App
//
//  Created by snow on 9/17/23.
//

import SwiftUI

struct EventView: View {
    @Binding var event: Event
    var body: some View {
        List {
            Text("hello world")
        }
        .onAppear {
            pullEventData(eventId: event.id)
        }
        .navigationTitle(Text(event.title))
    }
    func pullEventData(eventId: String) {
        HTTPClient.shared.gqlRequest(
            requestType: loadEvent(eventId: eventId)
        ) { (result: Result<loadEvent.Response, Error>) in
            switch result {
            case .success(let response):
                print("We got these events:\n \(response.data) \n")
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
