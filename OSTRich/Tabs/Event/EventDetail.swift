//
//  EventDetail.swift
//  OSTRich
//
//  Created by snow on 7/12/24.
//

import SwiftUI

struct EventDetailsView: View {
    var event: Event
    
    var body: some View {
        List {
            Section("Event Name") {
                Text(event.title)
            }
                
            if let status = event.status {
                Section("Status") {
                    Text(status)
                }
            }
            
            if let shortCode = event.shortCode {
                Section("Join Code") {
                    Text(shortCode)
                }
            }
                
            if let createdBy = event.createdBy {
                Section("Host") {
                    Text(createdBy)
                }
            }
                
            Section("Minimum Team Size") {
                Text("\(event.requiredTeamSize)")
            }
                
                
            if let scheduledStartTime = event.scheduledStartTime {
                Section("Scheduled Start") {
                    Text("\(scheduledStartTime)")
                }
            }
                
            if let actualStartTime = event.actualStartTime {
                Section("Actual Start") {
                    Text("\(actualStartTime)")
                }
            }
            
            if let pairingType = event.pairingType {
                Section("Pairing Type") {
                    Text(pairingType)
                }
            }
            
            
            if let isOnline = event.isOnline {
                Section("Type") {
                    Text(isOnline ? "Online" : "In Person")
                }
            }

        }
        .onAppear {
            Analytics.track(.openedEventDetailsView)
        }
        .navigationTitle("Event Details")
    }
}
