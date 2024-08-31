//
//  PendingNotificationsView.swift
//  OSTRich
//
//  Created by snow on 8/31/24.
//

import SwiftUI
import UserNotifications

struct PendingNotificationsView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.pendingNotifications, id: \.identifier) { request in
                VStack(alignment: .leading) {
                    Text(request.content.title)
                        .font(.headline)
                    Text(request.content.body)
                        .font(.subheadline)
                    if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                        Text("Time Interval Trigger: \(trigger.timeInterval) seconds")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                        Text("Calendar Trigger: \(trigger.nextTriggerDate()?.description ?? "Unknown")")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        Text("Unknown Trigger")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Pending Notifications")
        }
    }
    
    class ViewModel: ObservableObject {
        @Published var pendingNotifications: [UNNotificationRequest] = []
        
        init() {
            fetchPendingNotifications()
        }
        
        func fetchPendingNotifications() {
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests { requests in
                DispatchQueue.main.async {
                    self.pendingNotifications = requests
                }
            }
        }
    }
}
