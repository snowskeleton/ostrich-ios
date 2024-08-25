//
//  ScoutingHistoryCollapsableView.swift
//  OSTRich
//
//  Created by snow on 8/25/24.
//


import SwiftUI
import SwiftData

struct ScoutingHistoryCollapsableView: View {
    @Environment(\.modelContext) var context
    
    @State private var expandedSections: [String: Bool] = [:]
    @State var player: LocalPlayer

    init(player: Player) {
        let localPlayer = LocalPlayer.createOrUpdate(from: player)
        self.init(player: localPlayer)
    }
    
    init(player: LocalPlayer) {
        _player = .init(initialValue: player)
        let uniqueFormats = Set(player.formatsPlayed)
        _expandedSections = .init(initialValue: Dictionary(uniqueKeysWithValues: uniqueFormats.map { ($0, true) }))
    }
    
    var body: some View {
        ForEach(player.formatsPlayed, id: \.self) { format in
            DisclosureGroup(isExpanded: Binding(
                get: { expandedSections[format] ?? false },
                set: { expandedSections[format] = $0 }
            )) {
                ScoutingHistoryByFormatView(player: player, format: format)
            } label: {
                Text(format)
            }
        }
    }
}
