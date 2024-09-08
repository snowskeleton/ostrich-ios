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
            $0.key.safeName < $1.key.safeName
        }
    }


    var body: some View {
        NavigationStack {
            List {
                ForEach(sortedGroupedByStore, id: \.key.personaId) { (store, results) in
                    Section(store.safeName) {
                        ForEach(Array(Set(results.map { $0.format })).sorted(), id: \.self) { format in
                            if let preferredFormat = preferredFormat, preferredFormat != "All" {
                                if format == preferredFormat {
                                    DecksInStoreView(stats: results, format: format)
                                }
                            } else {
                                DisclosureGroup {
                                    DecksInStoreView(stats: results, format: format)
                                } label: {
                                    Text(format)
                                }
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, isPresented: $isPresented)
        .onAppear {
            Analytics.track(.openedScoutingHistoryAllPlayersView)
        }
    }
}
