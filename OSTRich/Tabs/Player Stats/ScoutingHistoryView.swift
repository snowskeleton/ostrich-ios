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
    
    @State private var searchText: String = ""
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

    var filteredStats: [ScoutingResult] {
        var filteredResults: [ScoutingResult] = searchedStats
        if shopSelection != "All" {
            filteredResults = filteredResults.filter { ($0.gameStore?.safeName ?? "") == shopSelection }
        }
        if preferredFormat != "All" {
            filteredResults = filteredResults.filter { $0.format == preferredFormat }
        }
        filteredResults = filteredResults.sorted {
            $0.format > $1.format &&
            $0.deckName > $1.deckName
        }
        return filteredResults
    }
    
    var shops: [GameStore] {
        let storeSet = Set(scoutingResults.compactMap { $0.gameStore })
        return Array(storeSet).sorted { $0.safeName < $1.safeName }
    }
    
    @State private var tabSelection: String = "Shop"
    @State private var shopSelection: String = "All"

    @State private var formatSelected: String = "All"
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
    var possibleFormats: [String] {
        return Array(Set(scoutingResults.map { $0.format })).sorted { $0 > $1 }
    }
    
    //paywall
    @State private var showScoutingResults: Bool = true
    @State private var showPaywall: Bool = false
    @State private var showPaywallSheet: Bool = false
    @State private var timer: Timer?
    @State private var freeTimeLeft: Int = 15
    @State private var showFreeTimeLeft: Bool = false

    var body: some View {
        NavigationStack {
            if showFreeTimeLeft {
                Text("\(freeTimeLeft) trial day\(freeTimeLeft > 1 ? "s" : "") remaining")
            }
            
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
                            
                            Picker("Format", selection: $formatSelected) {
                                Text("All Formats").tag("All")
                                ForEach(possibleFormats, id: \.self) {
                                    Text($0).tag($0)
                                }
                            }
                            .onChange(of: formatSelected) {
                                preferredFormat = formatSelected
                            }
                            .onAppear {
                                if !preferredFormat.isEmpty {
                                    formatSelected = preferredFormat
                                } else {
                                    formatSelected = defaultFormat
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
                    showPaywallSheet = true
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
                .sheet(isPresented: $showPaywallSheet) {
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
            return showPaywall
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
                    self.showPaywall = false
                    self.showFreeTimeLeft = false
                    return
                }
                
                if let firstOpen = UserDefaults.standard.object(forKey: "FirstOpen") as? Date {
                    let calendar = Calendar.current
                    let now = Date()
                    let daysSinceFirstOpen = calendar.dateComponents([.day], from: firstOpen, to: now).day ?? 0
                    
                    if daysSinceFirstOpen <= 15 {
                        // Show scouting results and trial period if within the trial window
                        self.showScoutingResults = true
                        self.showPaywall = true
                        self.showFreeTimeLeft = true
                        self.freeTimeLeft = 15 - daysSinceFirstOpen
                    } else {
                        // Trial expired, show paywall with freeTimeLeft as 0
                        self.showScoutingResults = false
                        self.showPaywall = true
                        self.showFreeTimeLeft = true
                        self.freeTimeLeft = 0
                    }
                }
                
                let customerInfo = try await Purchases.shared.customerInfo()
                let userHasPro = customerInfo.entitlements["pro"]?.isActive == true
                
                if userHasPro {
                    // User has a pro license, hide paywall and trial period, show scouting results
                    self.showScoutingResults = true
                    self.showPaywall = false
                    self.showFreeTimeLeft = false
                } else {
                    // User does not have pro, keep paywall and trial information visible
                    self.showPaywall = true
                }
            } catch {
                print("Failed to fetch customer info: \(error)")
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


