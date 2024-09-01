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
    @State private var showDebugOverlay = false
    
    var body: some View {
        List {
            Button {
                showDebugOverlay = true
            } label: {
                Text("Debug Overlay")
            }
            
            Text("You broke through the paywall!")
                .presentPaywallIfNeeded(
                    requiredEntitlementIdentifier: "pro",
                    purchaseCompleted: { customerInfo in
                        print("Purchase completed: \(customerInfo.entitlements)")
                    },
                    restoreCompleted: { customerInfo in
                        // Paywall will be dismissed automatically if "pro" is now active.
                        print("Purchases restored: \(customerInfo.entitlements)")
                    }
                )
        }
        .debugRevenueCatOverlay(isPresented: $showDebugOverlay)
    }
}
#endif