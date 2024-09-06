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
    @Query var stats: [ScoutingResult]
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
    
    init(storePersonaId: String, format: String) {
        self.format = format
        let predicate = #Predicate<ScoutingResult> {
            $0.createdBy == storePersonaId &&
            $0.format == format
        }
        let descriptor = FetchDescriptor<ScoutingResult>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.deckName)]
        )
        _stats = Query(descriptor)
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
//        List(deckCounts, id: \.deckName) { deck in
//            DisclosureGroup {
//                InnerLoop(players: deck.players, format: format)
//            } label: {
//                HStack {
//                    Text(deck.deckName)
//                        .font(.headline)
//                    Spacer()
//                    Text("\(deck.count)")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//                .padding(.vertical, 5)
//            }
//        }
//        .navigationTitle("Decks in Store")
    }
    
    struct InnerLoop: View {
        // if this inner loop is combined with the above view, something goes into an infinite loop and crashes
        @State var players: [LocalPlayer]
        var format: String
        
        var body: some View {
            ForEach(players) { player in
                NavigationLink {
                    List {
                        ScoutingHistoryByFormatView(player: player, format: format)
                    }
                } label: {
                    Text(player.safeName)
                        .font(.body)
                }
                .padding(.vertical, 2)
            }
        }
    }
}
