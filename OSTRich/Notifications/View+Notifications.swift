//
//  View+Notifications.swift
//  OSTRich
//
//  Created by snow on 1/21/24.
// https://holyswift.app/push-notifications-options-in-swiftui/

import SwiftUI

extension View {
    func onLaunchWithNotification(perform action: @escaping (UNNotificationResponse) -> Void) -> some View {
        modifier(NotificationViewModifier(onNotification: action, handler: NotificationHandler.shared))
    }
    func onForegroundNotification(perform action: @escaping (UNNotification) -> Void) -> some View {
        modifier(ForegroundNotificationViewModifier(onNotification: action, handler: NotificationHandler.shared))
    }
}
