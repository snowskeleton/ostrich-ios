//
//  ScoutingHistory.swift
//  OSTRich
//
//  Created by snow on 8/21/24.
//

import SwiftUI
import SwiftData
import RevenueCat
import RevenueCatUI

struct ScoutingHistoryAllPlayersView: View {
    @Environment(\.modelContext) private var context
    @Query var players: [LocalPlayer]
    
    @State private var isPresented: Bool = false
    @State private var searchText: String = ""
    
    // paywall stuff
    @State private var showScoutingResults: Bool = true
    @State private var showPaywall: Bool = false
    @State private var timer: Timer?
    
    var searchablePlayers: [LocalPlayer] {
        if searchText.isEmpty {
            return players
        } else {
            return players.filter {
                $0.safeName.lowercased().contains(searchText.lowercased()) ||
                $0.stats.contains {
                    $0.deckName.lowercased().contains(searchText.lowercased())
                }
                // since this returns players, and not formats,
                // searching by format returns all formats for each player who's
                // played in the searched format
                // TODO: fix
//                ||
//                $0.stats.contains {
//                    $0.format.lowercased().contains(searchText.lowercased())
//                }
            }
        }
    }

    init() {
        let predicate = #Predicate<LocalPlayer> { !$0.stats.isEmpty }
        let descriptor = FetchDescriptor<LocalPlayer>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.firstName)]
        )
        _players = Query(descriptor)
    }

    var body: some View {
        NavigationStack {
            
            if showScoutingResults {
                List {
                    ForEach(searchablePlayers, id: \.personaId) { player in
                        Section(player.safeName) {
                            ScoutingHistoryCollapsableView(player: player)
                        }
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
    
    fileprivate func calculatePaywall() {
        Task {
            do {
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
