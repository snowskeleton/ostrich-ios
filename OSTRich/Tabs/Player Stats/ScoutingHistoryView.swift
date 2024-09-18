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
    @StateObject private var viewModel = PaywallViewModel()

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
    
    var body: some View {
        NavigationStack {
            if viewModel.showFreeTimeLeft {
                Text("\(viewModel.freeTimeLeft) trial day\(viewModel.freeTimeLeft > 1 ? "s" : "") remaining")
            }
            
            if viewModel.showScoutingResults {
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
                PaywallButtonView()
            }
        }
        .searchable(text: $searchText)
        .onAppear {
            viewModel.startPaywallTimer()
            Analytics.track(.openedScoutingHistoryAllPlayersView)
        }
        .onDisappear {
            viewModel.stopPaywallTimer()
        }
        .sheet(isPresented: $viewModel.showPaywall) {
            PaywallView(displayCloseButton: true)
        }
        .navigationTitle("Scouting History")
    }
}


