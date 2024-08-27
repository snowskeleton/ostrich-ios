//
//  PermissionsView.swift
//  OSTRich
//
//  Created by snow on 8/26/24.
//

import SwiftUI

struct NotificationPermissionsView: View {
    private let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    @State var persistentBannerEnabled = false
    @State var bannerEnabled = false
    @State var soundEnabled = false
    @State var lockScreenEnabled = false
    @State var notificationsEnabled = false
    @State var timeSensitiveEnabled = false
    @State var criticalAlertsEnabled = false
    
    var body: some View {
        List {
            SinglePermissionView(title: "Notifications", toggle: notificationsEnabled)
            SinglePermissionView(title: "Sound", toggle: soundEnabled)
            Section(header: Text("Where to show alarms")) {
                SinglePermissionView(title: "Lock Screen", toggle: lockScreenEnabled)
                SinglePermissionView(title: "Banner", toggle: bannerEnabled)
                if bannerEnabled {
                    SinglePermissionView( title: "Persistent Banner", toggle: persistentBannerEnabled)
                }
            }
            Section(header: Text("Special Permissions")) {
                SinglePermissionView(title: "Time Sensitive", toggle: timeSensitiveEnabled)
                SinglePermissionView(title: "Critical Alerts", toggle: criticalAlertsEnabled)
            }
            
            Section(footer: Text("Ensure Snowclock has permission for any Focus modes you use.")) {
                Button("Open Notification Settings") {
                    if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            }
            
            Section(footer: Text("Disables all alarms and removes all queued notifications.")) {
                Button("Clear all notifications", role: .destructive) { Notifications.removeAllPendingNotifications() }
            }
        }
        .onReceive(timer) { _ in
            setStates()
        }
    }
    
    fileprivate func setStates() {
        UNUserNotificationCenter.current().getNotificationSettings  { settings in
            bannerEnabled = settings.alertSetting.rawValue == 2
            criticalAlertsEnabled = settings.criticalAlertSetting.rawValue == 2
            if bannerEnabled {
                persistentBannerEnabled = settings.alertStyle.rawValue == 2
            }
            soundEnabled = settings.soundSetting.rawValue == 2
            lockScreenEnabled = settings.lockScreenSetting.rawValue == 2
            notificationsEnabled = settings.authorizationStatus.rawValue == 2
            timeSensitiveEnabled = settings.timeSensitiveSetting.rawValue == 2
        }
    }
}

struct SinglePermissionView: View {
    var title: String
    var toggle: Bool
    var options: Array = ["Enabled", "Disabled"]
    var body: some View {
        HStack {
            Text("\(title):")
            Spacer()
            Text(toggle ? options[0] : options[1])
        }
    }
}
