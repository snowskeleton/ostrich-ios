//
//  AnalyticsView.swift
//  OSTRich
//
//  Created by snow on 8/29/24.
//

import SwiftUI

struct AnalyticsView: View {
    @AppStorage("isAnalyticsDisabled") var disableAnalytics = false
    
    var body: some View {
        List {
            Section {
                Toggle("Enable Analytics", isOn: Binding(
                    get: { !disableAnalytics },
                    set: {
                        Analytics.track(!$0 ? .analyticsDisabled : .analyticsEnabled)
                        disableAnalytics  = !$0
                        Analytics.track(!$0 ? .analyticsDisabled : .analyticsEnabled)
                    }
                ))
            } header: {
                Text("Analytics")
            } footer: {
                Text("\(disableAnalytics ? "No" : "Only") app usage is tracked. No personally identifible information is saved. No information is sold to or used by third parties.")
            }
        }
        .onAppear {
            Analytics.track(.openedAnalyticsView)
        }
    }
}
