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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(shops, id: \.personaId) { shop in
                    DisclosureGroup {
                        ForEach(shop.formatsPlayed, id: \.self) { format in
                            DisclosureGroup {
                                DecksInStoreView(storePersonaId: shop.personaId,format: format)
                            } label: {
                                Text(format)
                            }
                        }
                    } label: {
                        Text(shop.userGivenName ?? shop.personaId)
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
