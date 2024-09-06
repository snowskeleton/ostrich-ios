//
//  ScoutingHistoryView.swift
//  OSTRich
//
//  Created by snow on 9/5/24.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct ScoutingHistoryView: View {
    @State private var selection: String = "Shop"
    
    //paywall
    @State private var showScoutingResults: Bool = true
    @State private var showPaywall: Bool = false
    @State private var timer: Timer?

    var body: some View {
        NavigationStack {
            if showScoutingResults {
                VStack {
                    Picker(selection: $selection, label: Text("")) {
                        Text("Standings").tag("Shop")
                        Text("Players").tag("Players")
                    }//.pickerStyle(SegmentedPickerStyle())

                    TabView(selection: $selection) {
                        ScoutingHistoryByShopView().tag("Shop")
                        ScoutingHistoryAllPlayersView().tag("Players")
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            } else {
                Button {
                    showPaywall = true
                } label: {
                    Text("Subscribe to Pro")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .sheet(isPresented: $showPaywall) {
                    PaywallView()
                }
            }
        }
        .onAppear {
            calculatePaywall()
            startPaywallTimer()
            Analytics.track(.openedScoutingHistoryAllPlayersView)
        }
        .onDisappear {
            stopPaywallTimer()
        }
        .presentPaywallIfNeeded { customerInfo in
            if UserDefaults.standard.bool(forKey: "disableInAppPurchasePaywall") { return false }
            return customerInfo.entitlements.active.keys.contains("pro")
            //            return true
        } purchaseCompleted: { customerInfo in
            print("Purchase completed: \(customerInfo.entitlements)")
        } restoreCompleted: { customerInfo in
            // Paywall will be dismissed automatically if "pro" is now active.
            print("Purchases restored: \(customerInfo.entitlements)")
        }
        .navigationTitle("Scouting History")
    }
    
    fileprivate func calculatePaywall() {
        Task {
            do {
                if UserDefaults.standard.bool(forKey: "disableInAppPurchasePaywall") {
                    self.showScoutingResults = true
                    return
                }
                let customerInfo = try await Purchases.shared.customerInfo()
                self.showScoutingResults = customerInfo.entitlements["pro"]?.isActive == true ? true : false
            } catch {
                print("\(error)")
            }
        }
    }
    
    private func startPaywallTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if !showScoutingResults {
                calculatePaywall()
            } else {
                stopPaywallTimer()
            }
        }
    }
    
    private func stopPaywallTimer() {
        timer?.invalidate()
        timer = nil
    }
    

}

#Preview {
    ScoutingHistoryView()
}
