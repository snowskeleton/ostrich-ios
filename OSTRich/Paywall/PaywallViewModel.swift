//
//  PaywallViewModel.swift
//  OSTRich
//
//  Created by snow on 9/12/24.
//

import Foundation
import RevenueCat
import Combine

class PaywallViewModel: ObservableObject {
    // show features to the user
    @Published var showScoutingResults: Bool = true
    // show paywall on view load
    @Published var showPaywall: Bool = false
    // amount of time left in trial
    @Published var freeTimeLeft: Int = 0
    // whether to show free time left
    @Published var showFreeTimeLeft: Bool = false
    //whether user has pro sub
    @Published var hasProAccess: Bool = false
    
    private var timerSubscription: Cancellable?

    @MainActor
    func calculatePaywall() {
        Task {
            do {
                if UserDefaults.standard.bool(forKey: "disableInAppPurchasePaywall") {
                    self.hasProAccess = true
                    self.showScoutingResults = true
                    self.showPaywall = false
                    self.showFreeTimeLeft = false
                    return
                }
                if UserDefaults.standard.bool(forKey: "enableInAppPurchasePaywall") {
                    self.hasProAccess = false
                    self.showScoutingResults = false
                    self.showPaywall = true
                    self.showFreeTimeLeft = true
                    return
                }
                
                let customerInfo = try await Purchases.shared.customerInfo()
                let userHasPro = customerInfo.entitlements["pro"]?.isActive == true
                
                if userHasPro {
                    // User has a pro license, hide paywall and trial period, show scouting results
                    self.hasProAccess = true
                    self.showScoutingResults = true
                    self.showPaywall = false
                    self.showFreeTimeLeft = false
                    timerSubscription?.cancel()
                    return
                } else {
                    self.showPaywall = true
                    self.showFreeTimeLeft = true
                }
                
                if let firstOpen = UserDefaults.standard.object(forKey: "FirstOpen") as? Date {
                    let calendar = Calendar.current
                    let now = Date()
                    let daysSinceFirstOpen = calendar.dateComponents([.day], from: firstOpen, to: now).day ?? 0
                    
                    if daysSinceFirstOpen <= 15 {
                        // Show scouting results and trial period if within the trial window
                        self.showScoutingResults = true
                        self.freeTimeLeft = 15 - daysSinceFirstOpen
                    } else {
                        // Trial expired, show paywall with freeTimeLeft as 0
                        self.showScoutingResults = false
                        self.freeTimeLeft = 0
                    }
                }
            } catch {
                print("Failed to fetch customer info: \(error)")
            }
        }
    }
    
    func startPaywallTimer() {
        timerSubscription = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task {
                    await self?.calculatePaywall()
                }
            }
    }

    func stopPaywallTimer() {
        timerSubscription?.cancel()
    }
}
