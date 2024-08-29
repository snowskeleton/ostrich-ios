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
        } else {
            if let options {
                Aptabase.shared.trackEvent(event.rawValue, with: options)
            } else {
                Aptabase.shared.trackEvent(event.rawValue)
            }
        }
    }
    
    static func track(_ event: AnalyticEvent ) {
        Analytics.privateTrack(event, with: nil)
    }
    static func track(_ event: AnalyticEvent, with options: [String: Any]) {
        Analytics.privateTrack(event, with: options)
    }
}
