//
//  PendingNotificationsView.swift
//  OSTRich
//
//  Created by snow on 8/31/24.
//

import SwiftUI
import UserNotifications

struct PendingNotificationsView: View {
    @State private var pendingNotifications: [UNNotificationRequest] = []
    @State private var timeRemainingDict: [String: TimeInterval] = [:]
    @State private var timer: Timer? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(pendingNotifications, id: \.identifier) { request in
                    VStack(alignment: .leading) {
                        Text(request.content.title)
                            .font(.headline)
                        Text(request.content.body)
                            .font(.subheadline)
                        
                        if let scheduledTimeString = request.content.userInfo["scheduledTime"] as? String,
                           let scheduledTime = ISO8601DateFormatter().date(from: scheduledTimeString) {
                            let remainingTime = timeRemaining(for: request.identifier)
                            HStack {
                                Text("Scheduled for: \(formattedDate(scheduledTime)).")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Text("T – \(remainingTime)")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteNotification)
            }
            .navigationTitle("Pending Notifications")
            .onAppear {
                updatePendingNotifications()
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
        }
    }
    
    fileprivate func updatePendingNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            pendingNotifications = requests
            timeRemainingDict = requests.reduce(into: [:]) { dict, request in
                if let scheduledTimeString = request.content.userInfo["scheduledTime"] as? String,
                   let scheduledTime = ISO8601DateFormatter().date(from: scheduledTimeString) {
                    dict[request.identifier] = scheduledTime.timeIntervalSince(Date())
                }
            }
            // Sort notifications by time remaining
            pendingNotifications.sort { (request1, request2) -> Bool in
                let time1 = timeRemainingDict[request1.identifier] ?? 0
                let time2 = timeRemainingDict[request2.identifier] ?? 0
                return time1 < time2
            }
        }
    }

    func removeNotification(withIdentifier identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // Remove from local array
        if let index = pendingNotifications.firstIndex(where: { $0.identifier == identifier }) {
            pendingNotifications.remove(at: index)
            timeRemainingDict.removeValue(forKey: identifier)
        }
    }
    
    private func deleteNotification(at offsets: IndexSet) {
        offsets.forEach { index in
            let request = pendingNotifications[index]
            removeNotification(withIdentifier: request.identifier)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func timeRemaining(for identifier: String) -> String {
        guard let remainingTime = timeRemainingDict[identifier] else {
            return "Unknown time"
        }
        if remainingTime <= 0 {
            return "Time's up!"
        } else {
            let minutes = Int(remainingTime) / 60
            let seconds = Int(remainingTime) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updatePendingNotifications()
            // Update remaining time in the dictionary
            timeRemainingDict = timeRemainingDict.mapValues { $0 - 1 }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

