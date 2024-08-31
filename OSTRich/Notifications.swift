//
//  Notifications.swift
//  OSTRich
//
//  Created by snow on 8/26/24.
//

import Foundation
import UserNotifications

struct Notifications {
    static func verifyPermissions() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [
                .alert, .badge, .sound
            ]) { success, error in
                if success {
                    // we got or have permissions
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
    }
    
    static func scheduleRoundTimerNotifications(for roundTimer: RoundTimer) {
        if UserDefaults.standard.bool(forKey: "disableRoundTimerNotifications") {
            return
        }
        Notifications.verifyPermissions()
        let notificationCenter = UNUserNotificationCenter.current()
        
        // Calculate the end time of the timer
        guard let durationMs = roundTimer.durationMs,
              let startTime = roundTimer.durationStartTime else {
            return
        }
        
        let endTime = startTime.addingTimeInterval(TimeInterval(durationMs) / 1000)
        
        // Times before the end to schedule notifications
//        let timesBeforeEnd: [TimeInterval] = [2690] // in seconds
        let timesBeforeEnd: [TimeInterval] = [30 * 60, 15 * 60, 5 * 60, 0] // in seconds

        for timeBeforeEnd in timesBeforeEnd {
            let notificationTime = endTime.addingTimeInterval(-timeBeforeEnd)
            if notificationTime > Date() {
                let content = UNMutableNotificationContent()
                content.title = "Round Timer"
                if timeBeforeEnd == 0 {
                    content.body = "Time in round!"
                } else {
                    content.body = "\(Int(timeBeforeEnd / 60)) minutes remaining"
                }
                content.sound = .default
                content.threadIdentifier = roundTimer.localId
                content.userInfo = ["scheduledTime": ISO8601DateFormatter().string(from: notificationTime)]

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notificationTime.timeIntervalSinceNow, repeats: false)
                
                let request = UNNotificationRequest(
                    identifier: "\(roundTimer.localId)_\(timeBeforeEnd)",
                    content: content,
                    trigger: trigger
                )
                
                notificationCenter.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
//                        print("Notification scheduled successfully for \(notificationTime.timeIntervalSinceNow)")
                    }
                }
            }
        }
        
    }
    
    static func cancelRoundTimerNotifications(for roundTimer: RoundTimer) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        // Generate the identifiers for all potential notifications related to this RoundTimer
        let timesBeforeEnd: [TimeInterval] = [30 * 60, 15 * 60, 5 * 60, 0] // in seconds
        let identifiers = timesBeforeEnd.map { "\(roundTimer.localId)_\($0)" }
        
        // Cancel notifications with the generated identifiers
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    static func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
}
