//
//  NotificationViewModifier.swift
//  OSTRich
//
//  Created by snow on 1/21/24.
// https://alexanderweiss.dev/blog/2023-08-13-push-notification-in-swiftui

import SwiftUI

struct NotificationViewModifier: ViewModifier {
    // MARK: - Private Properties
    private let onNotification: (UNNotificationResponse) -> Void
    
    // MARK: - Initializers
    init(onNotification: @escaping (UNNotificationResponse) -> Void, handler: NotificationHandler) {
        self.onNotification = onNotification
    }
    
    // MARK: - Body
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationHandler.shared.$latestNotification) { notification in
                guard let notification else { return }
                onNotification(notification)
            }
    }
}

struct ForegroundNotificationViewModifier: ViewModifier {
    // MARK: - Private Properties
    private let onNotification: (UNNotification) -> Void
    
    // MARK: - Initializers
    init(onNotification: @escaping (UNNotification) -> Void, handler: NotificationHandler) {
        self.onNotification = onNotification
    }
    
    // MARK: - Body
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationHandler.shared.$foregroundNotification) { notification in
                guard let notification else { return }
                onNotification(notification)
            }
    }
}
