//
//  EventDetail.swift
//  OSTRich
//
//  Created by snow on 7/12/24.
//

import SwiftUI

struct EventDetail: View {
    var event: Event
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(event.title)
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                
                if let pairingType = event.pairingType {
                    HStack {
                        Text("Pairing Type:")
                            .fontWeight(.bold)
                        Text(pairingType)
                    }
                }
                
                if let status = event.status {
                    HStack {
                        Text("Status:")
                            .fontWeight(.bold)
                        Text(status)
                    }
                }
                
                if let isOnline = event.isOnline {
                    HStack {
                        Text("Online:")
                            .fontWeight(.bold)
                        Text(isOnline ? "Yes" : "No")
                    }
                }
                
                if let createdBy = event.createdBy {
                    HStack {
                        Text("Created By:")
                            .fontWeight(.bold)
                        Text(createdBy)
                    }
                }
                
                HStack {
                    Text("Required Team Size:")
                        .fontWeight(.bold)
                    Text("\(event.requiredTeamSize)")
                }
                
                if let shortCode = event.shortCode {
                    HStack {
                        Text("Short Code:")
                            .fontWeight(.bold)
                        Text(shortCode)
                    }
                }
                
                if let scheduledStartTime = event.scheduledStartTime {
                    HStack {
                        Text("Scheduled Start:")
                            .fontWeight(.bold)
                        Text("\(scheduledStartTime)")
                    }
                }
                
                if let actualStartTime = event.actualStartTime {
                    HStack {
                        Text("Actual Start:")
                            .fontWeight(.bold)
                        Text("\(actualStartTime)")
                    }
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                Analytics.track(.openedEventDetailsView)
            }
        }
        .navigationTitle("Event Details")
    }
}
