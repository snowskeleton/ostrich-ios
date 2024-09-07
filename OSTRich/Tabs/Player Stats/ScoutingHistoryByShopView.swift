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
    @AppStorage("preferredFormat") var preferredFormat: String?
    
    @Query(sort: \GameStore.userGivenName) var shops: [GameStore]
    
    @State private var isPresented: Bool = false
    @State private var searchText: String = ""
    
    var stats: [ScoutingResult]
    
    private var sortedGroupedByStore: [(key: GameStore, value: [ScoutingResult])] {
        var storeDict: [GameStore: [ScoutingResult]] = [:]
        
        for result in stats {
            if let store = result.gameStore {
                if storeDict[store] != nil {
                    storeDict[store]?.append(result)
                } else {
                    storeDict[store] = [result]
                }
            }
        }
        
        return storeDict.sorted {
            ($0.key.userGivenName ?? "") < ($1.key.userGivenName ?? "")
        }
    }


    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedGroupedByStore, id: \.key.personaId) { (store, results) in
                    DisclosureGroup {
                        ForEach(Array(Set(results.map { $0.format })).sorted(), id: \.self) { format in
                            if let preferredFormat = preferredFormat, !preferredFormat.isEmpty {
                                if format == preferredFormat {
                                    DecksInStoreView(storePersonaId: store.personaId, format: format)
                                }
                            } else {
                                DisclosureGroup {
                                    DecksInStoreView(storePersonaId: store.personaId, format: format)
                                } label: {
                                    Text(format)
                                }
                            }
                        }
                    } label: {
                        Text(store.userGivenName ?? store.personaId)
                            .font(.headline)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .searchable(text: $searchText, isPresented: $isPresented)
        .onAppear {
            Analytics.track(.openedScoutingHistoryAllPlayersView)
        }
    }
}
