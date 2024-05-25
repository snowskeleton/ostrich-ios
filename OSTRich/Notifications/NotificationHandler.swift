//
//  NotificationHandler.swift
//  OSTRich
//
//  Created by snow on 1/21/24.
// https://alexanderweiss.dev/blog/2023-08-13-push-notification-in-swiftui

import SwiftUI
import Foundation
import UserNotifications

public class NotificationHandler: ObservableObject {
    // MARK: - Shared Instance
    /// The shared notification system for the process
    public static let shared = NotificationHandler()
    
    // MARK: - Properties
    /// Latest available notification
    @Published private(set) var latestNotification: UNNotificationResponse? = .none // default value
    @Published private(set) var foregroundNotification: UNNotification? = .none // default value
    
    // MARK: - Methods
    /// Handles the receiving of a UNNotificationResponse and propagates it to the app
    ///
    /// - Parameters:
    ///   - notification: The UNNotificationResponse to handle
    public func handle(notification: UNNotificationResponse) {
        self.latestNotification = notification
    }
    public func handle(notification: UNNotification) {
        self.foregroundNotification = notification
    }
    
    public func getNotificationSettings() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        guard settings.authorizationStatus == .authorized else { return }
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            )
    }
}
