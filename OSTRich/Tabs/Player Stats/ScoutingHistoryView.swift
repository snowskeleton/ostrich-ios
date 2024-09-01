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
            List {
                ForEach(searchablePlayers, id: \.personaId) { player in
                    Section(player.safeName) {
                        ScoutingHistoryCollapsableView(player: player)
                    }
                }
            }
            .navigationTitle("Scouted Players")
        }
        .searchable(text: $searchText, isPresented: $isPresented)
        .onAppear {
            Analytics.track(.openedScoutingHistoryAllPlayersView)
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
}
