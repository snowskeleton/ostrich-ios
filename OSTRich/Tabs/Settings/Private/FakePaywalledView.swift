//
//  FakePaywalledView.swift
//  OSTRich
//
//  Created by snow on 9/1/24.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

#if DEBUG
struct FakePaywalledView: View {
    @AppStorage("disableInAppPurchasePaywall") var disableInAppPurchasePaywall = false
    @AppStorage("enableInAppPurchasePaywall") var enableInAppPurchasePaywall = false
    @AppStorage("showOverlayWhenOpeningThisPage") var showOverlayWhenOpeningThisPage = false

    @State private var showDebugOverlay = false
    @State private var firstOpen = Date()

    init() {
        if let firstOpen = UserDefaults.standard.object(forKey: "FirstOpen") as? Date {
            _firstOpen = .init(initialValue: firstOpen)
        }

    }
    
    var body: some View {
        List {
            #if DEBUG
            Button {
                showDebugOverlay = true
            } label: {
                Text("Debug Overlay")
            }
            .debugRevenueCatOverlay(isPresented: $showDebugOverlay)

            if showOverlayWhenOpeningThisPage {
                Text("You broke through the paywall!")
                    .presentPaywallIfNeeded { customerInfo in
                        showOverlayWhenOpeningThisPage
                    } purchaseCompleted: { customerInfo in
                        print("Purchase completed: \(customerInfo.entitlements)")
                    } restoreCompleted: { customerInfo in
                        print("Purchases restored: \(customerInfo.entitlements)")
                    }
            }
            #endif
            
            Section {
                Toggle("Show In-App purchase overlay on this page", isOn: $showOverlayWhenOpeningThisPage)
            }
            
            Section {
                Toggle("Disable in-app purchase paywall", isOn: $disableInAppPurchasePaywall)
                    .onChange(of: disableInAppPurchasePaywall) {
                        enableInAppPurchasePaywall = false
                    }
            }
            
            Section {
                Toggle("Enable in-app purchase paywall", isOn: $enableInAppPurchasePaywall)
                    .onChange(of: enableInAppPurchasePaywall) {
                        disableInAppPurchasePaywall = false
                    }
            }
            
            Section {
                DatePicker("First Open", selection: $firstOpen)
                    .onChange(of: firstOpen) { _, newValue in
                        UserDefaults.standard.set(newValue, forKey: "FirstOpen")
                    }
            }
        }
    }
}
#endif
