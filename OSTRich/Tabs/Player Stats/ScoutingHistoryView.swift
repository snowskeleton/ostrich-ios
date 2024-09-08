//
//  ScoutingHistoryView.swift
//  OSTRich
//
//  Created by snow on 9/5/24.
//

import SwiftUI
import SwiftData
import Charts
import RevenueCat
import RevenueCatUI

struct ScoutingHistoryView: View {
    @AppStorage("preferredFormat") var preferredFormat: String = ""
    
    @Query var scoutingResults: [ScoutingResult]
    
    var filteredStats: [ScoutingResult] {
        var filteredResults: [ScoutingResult] = searchedStats
        if shopSelection != "All" {
            filteredResults = filteredResults.filter { ($0.gameStore?.safeName ?? "") == shopSelection }
        }
        if preferredFormat != "All" {
            filteredResults = filteredResults.filter { $0.format == preferredFormat }
        }
        return filteredResults
    }
    
    var searchedStats: [ScoutingResult] {
        if searchText.isEmpty {
            return scoutingResults
        } else {
            if tabSelection == "Players" {
                return scoutingResults.filter {
                    ($0.player?.safeName.lowercased().contains(searchText.lowercased()) ?? false) ||
                    $0.deckName.lowercased().contains(searchText.lowercased())
                }
            } else if tabSelection == "Shop" {
                return scoutingResults.filter {
                    $0.deckName.lowercased().contains(searchText.lowercased())
                }
            }
            
            return scoutingResults
        }
    }
    
    var shops: [GameStore] {
        let storeSet = Set(scoutingResults.compactMap { $0.gameStore })
        return Array(storeSet).sorted { $0.safeName < $1.safeName }
    }
    
    @State private var searchText: String = ""
    @State private var tabSelection: String = "Shop"
    @State private var shopSelection: String = "All"

    @State private var selectedFormat: String = "All"
    var defaultFormat: String {
        // default to the format with the highest representation
        let formatCounts = scoutingResults
            .map { $0.format }
            .reduce(into: [String: Int]()) { counts, format in
                counts[format, default: 0] += 1
            }
        
        if let mostCommonFormat = formatCounts.max(by: { $0.value < $1.value })?.key {
            return mostCommonFormat
        } else {
            return "All"
        }

    }
    
    //paywall
    @State private var showScoutingResults: Bool = true
    @State private var showPaywall: Bool = false
    @State private var timer: Timer?

    var body: some View {
        NavigationStack {
            if showScoutingResults {
                VStack {
                    BarChartView(stats: filteredStats)
                    
                    VStack {
                        HStack {
                            Picker("Shops", selection: $shopSelection) {
                                Text("All Shops").tag("All")
                                ForEach(shops, id: \.safeName) { shop in
                                    Text(shop.safeName).tag(shop.safeName)
                                }
                            }
                            
                            Picker("Format", selection: $selectedFormat) {
                                Text("All Formats").tag("All")
                                ForEach(formatNames, id: \.self) {
                                    Text($0).tag($0)
                                }
                            }
                            .onChange(of: selectedFormat) {
                                preferredFormat = selectedFormat
                            }
                            .onAppear {
                                if !preferredFormat.isEmpty {
                                    selectedFormat = preferredFormat
                                } else {
                                    selectedFormat = defaultFormat
                                }
                            }
                        }
                        
                        Picker("Show...", selection: $tabSelection) {
                            Text("Shop").tag("Shop")
                            Text("Players").tag("Players")
                        }.pickerStyle(SegmentedPickerStyle())
                    }

                    TabView(selection: $tabSelection) {
                        ScoutingHistoryByShopView(stats: filteredStats).tag("Shop")
                        ScoutingHistoryAllPlayersView(stats: filteredStats).tag("Players")
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
        .searchable(text: $searchText)
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


