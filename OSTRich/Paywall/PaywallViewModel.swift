//
//  PaywallViewModel.swift
//  OSTRich
//
//  Created by snow on 9/12/24.
//

import SwiftUI
import Foundation
import RevenueCat
import Combine

@MainActor
class PaywallViewModel: ObservableObject {
    // Show features to the user
    @Published var showScoutingResults: Bool = true
    // Show paywall on view load (only set once)
    @Published var showPaywall: Bool = false
    // Amount of time left in trial
    @Published var freeTimeLeft: Int = 0
    // Whether to show free time left
    @Published var showFreeTimeLeft: Bool = false
    // Whether user has pro subscription
    @Published var hasProAccess: Bool = false
    
    private var timerSubscription: Cancellable?
    
    init() {
        calculatePaywallOnce()
        startPaywallTimer()
    }
    
    /// Calculate paywall visibility once per session
    func calculatePaywallOnce() {
        Task {
            do {
                if UserDefaults.standard.bool(forKey: "disableInAppPurchasePaywall") {
                    self.showPaywall = false
                    return
                }
                
                if UserDefaults.standard.bool(forKey: "enableInAppPurchasePaywall") {
                    self.showPaywall = true
                    return
                }
                
                let customerInfo = try await Purchases.shared.customerInfo()
                let userHasPro = customerInfo.entitlements["pro"]?.isActive == true
                
                if userHasPro {
                    self.showPaywall = false
                } else {
                    self.showPaywall = true
                }
            } catch {
                print("Failed to fetch customer info: \(error)")
            }
        }
    }
    
    /// This function will run on a timer to continuously update `showScoutingResults`, `hasProAccess`, and `freeTimeLeft`
    func updateScoutingStatus() {
        Task {
            do {
                if UserDefaults.standard.bool(forKey: "disableInAppPurchasePaywall") {
                    self.hasProAccess = true
                    self.showScoutingResults = true
                    self.showFreeTimeLeft = false
                    timerSubscription?.cancel()
                    return
                }
                
                if UserDefaults.standard.bool(forKey: "enableInAppPurchasePaywall") {
                    self.hasProAccess = false
                    self.showScoutingResults = false
                    self.showFreeTimeLeft = true
                    return
                }

                let customerInfo = try await Purchases.shared.customerInfo()
                let userHasPro = customerInfo.entitlements["pro"]?.isActive == true
                
                if userHasPro {
                    // User has a pro license, hide paywall and trial period, show scouting results
                    self.hasProAccess = true
                    self.showScoutingResults = true
                    self.showFreeTimeLeft = false
                    timerSubscription?.cancel()
                    return
                } else {
                    // Show trial status if no pro license
                    self.hasProAccess = false
                    self.showScoutingResults = false
                    self.showFreeTimeLeft = true
                }
                
                if let firstOpen = UserDefaults.standard.object(forKey: "FirstOpen") as? Date {
                    let calendar = Calendar.current
                    let now = Date()
                    let daysSinceFirstOpen = calendar.dateComponents([.day], from: firstOpen, to: now).day ?? 0
                    
                    if daysSinceFirstOpen <= 15 {
                        // Within trial period
                        self.showScoutingResults = true
                        self.freeTimeLeft = 15 - daysSinceFirstOpen
                    } else {
                        // Trial expired
                        self.showScoutingResults = false
                        self.freeTimeLeft = 0
                    }
                }
            } catch {
                print("Failed to update scouting status: \(error)")
            }
        }
    }
    
    // Starts the timer to update scouting status every 0.5 seconds
    func startPaywallTimer() {
        timerSubscription = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateScoutingStatus()
            }
    }
    
    func stopPaywallTimer() {
        timerSubscription?.cancel()
    }
}
