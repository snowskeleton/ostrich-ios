//
//  ScoutingHistoryByShopView.swift
//  OSTRich
//
//  Created by snow on 8/21/24.
//

import SwiftUI
import SwiftData
import RevenueCat
import RevenueCatUI

struct ScoutingHistoryByShopView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \GameStore.userGivenName) var shops: [GameStore]
    
    @State private var isPresented: Bool = false
    @State private var searchText: String = ""
    
    @State private var format: String = "Modern"
    
    // paywall stuff
    @State private var showScoutingResults: Bool = true
    @State private var showPaywall: Bool = false
    @State private var timer: Timer?
    

    var body: some View {
        NavigationStack {
            
            if showScoutingResults {
                List {
                    ForEach(shops, id: \.personaId) { shop in
                        DisclosureGroup {
                            ForEach(shop.formatsPlayed, id: \.self) { format in
                                NavigationLink {
                                    DecksInStoreView(storePersonaId: shop.personaId, format: format)
                                } label: {
                                    Text(format)
                                }
                                .padding(.vertical, 2)
                            }
                        } label: {
                            Text(shop.userGivenName ?? shop.personaId)
                                .font(.headline)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .navigationTitle("Scouted Players")
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
        .searchable(text: $searchText, isPresented: $isPresented)
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
