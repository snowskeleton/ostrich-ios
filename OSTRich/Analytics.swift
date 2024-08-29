//
//  Analytics.swift
//  OSTRich
//
//  Created by snow on 8/28/24.
//

import Foundation
import Aptabase

enum AnalyticEvent: String {
    case joinEvent
    case opened_developer_menu
}

class Analytics {
    
    static func track(_ event: AnalyticEvent ) {
        Aptabase.shared.trackEvent(event.rawValue)
    }
}
