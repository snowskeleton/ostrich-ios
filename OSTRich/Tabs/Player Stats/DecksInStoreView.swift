//
//  DecksInStoreView.swift
//  OSTRich
//
//  Created by snow on 9/5/24.
//


import SwiftUI
import SwiftData
import RevenueCat
import RevenueCatUI

struct DecksInStoreView: View {
    var stats: [ScoutingResult]
    var format: String
    
    private var deckCounts: [(deckName: String, count: Int, players: [LocalPlayer])] {
        Dictionary(grouping: stats, by: \.deckName)
            .mapValues { results in
                let players = results.compactMap { $0.player }
                return (count: results.count, players: Array(Set(players)))
            }
            .sorted {
                if $0.value.count == $1.value.count {
                    return $0.key < $1.key  // Sort by deckName if counts are equal
                } else {
                    return $0.value.count > $1.value.count  // Sort by count in descending order
                }
            }
            .map { (deckName: $0.key, count: $0.value.count, players: $0.value.players) }
    }
    
    var body: some View {
        ForEach(deckCounts, id: \.deckName) { deck in
            NavigationLink {
                DeckStatsView(deckName: deck.deckName, format: format)
            } label: {
                HStack {
                    Text(deck.deckName)
                        .font(.headline)
                    Spacer()
                    Text("\(deck.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
