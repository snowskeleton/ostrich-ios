//
//  AppDelegate.swift
//  FlockPocket
//
//  Created by snow on 1/15/24.
//

import SwiftUI
import Foundation
import UserNotifications
import SwiftData

fileprivate func crashProtection() {
    let count = UserDefaults.standard.integer(
        forKey: "timesLaunchedWithoutSafeClose"
    )
    if count > 1 {
        try? ModelContainer().deleteAllData()
    }
    UserDefaults.standard
        .setValue(count + 1, forKey: "timesLaunchedWithoutSafeClose")
    NSLog("Crash count: \(count)")
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        if UserDefaults.standard.bool(forKey: "useLaunchCrashProtection") {
            crashProtection()
        }
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Task {
            guard let deviceId = UIDevice().identifierForVendor?.uuidString else { return }
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            let token = tokenParts.joined()
            let _ = await HTOService().ostrichRegisterDevice(token, deviceId)
//            print("Device Token: \(token)")
        }
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        NotificationHandler.shared.handle(notification: response)
    }
    
    // Needed if notifications should be presented while the app is in the foreground
    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        NotificationHandler.shared.handle(notification: notification)
    }
}
