//
//  Analytics.swift
//  OSTRich
//
//  Created by snow on 8/28/24.
//

import Foundation
import Aptabase

enum AnalyticEvent: String {
    case appLaunch
    
    case manuallyRefreshedEventView
    case noTimerForEvent
    case playerDroppedFromEvent
    case playerDropFromEventFailure
    case foundPreviousDecks
    case newPlayerToFormat
    case enabledSaveLoginCreds
    case disabledSaveLoginCreds
    case enabledShowDebugValues
    case disabledShowDebugValues
    case enabledUseLaunchProtection
    case disabledUseLaunchProtection
    case enabledDisableRoundTimerNotifications
    case disabledDisableRoundTimerNotifications
    case enabledDisableInAppPurchasePaywall
    case disabledDisableInAppPurchasePaywall  

    case joinEvent
    case matchSubmittedWithError
    case matchSubmittedWithoutError
    case removedAllPendingNotificaionts
    case logout
    case changeName
    case registerNewAccount
    case login

    case analyticsDisabled
    case analyticsEnabled
    
    case openedDeveloperMenu
    case openedAnalyticsView
    case openedAllEventsView
    case openedEventView
    case changedEventViewTab
    case openedSubmitMatchView
    case openedEventDetailsView
    case openedScoutingHistoryAllPlayersView
    case openedCreateScoutingResultView
    case openedSettingsView
    case openedNetworkLogView
    case openedNotificationPermissionsView
}

class Analytics {
    static private func privateTrack(_ event: AnalyticEvent, with options: [String: Any]?) {
        if UserDefaults.standard.bool(forKey: "isAnalyticsDisabled") {
            return
        }
        
        let expiryTimestamp = UserDefaults.standard.double(forKey: "optInTrackingIdentifierExpiry")
        let expiryDate = Date(timeIntervalSince1970: expiryTimestamp)
        
        if Date() > expiryDate {
            UserDefaults.standard.set("", forKey: "optInTrackingIdentifier")
            UserDefaults.standard.set(0, forKey: "optInTrackingIdentifierExpiry")
        }
        
        var modifiedOptions = options ?? [:]
        if let id = UserDefaults.standard.string(forKey: "optInTrackingIdentifier"), !id.isEmpty {
            modifiedOptions["trackingIdentifier"] = id
        }
        
        if modifiedOptions.isEmpty {
            Aptabase.shared.trackEvent(event.rawValue)
        } else {
            Aptabase.shared.trackEvent(event.rawValue, with: modifiedOptions)
        }
    }
    
    static func track(_ event: AnalyticEvent ) {
        Analytics.privateTrack(event, with: nil)
    }
    static func track(_ event: AnalyticEvent, with options: [String: Any]) {
        Analytics.privateTrack(event, with: options)
    }
}
