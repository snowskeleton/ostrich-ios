//
//  Drop.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Drop: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var teamId: String
    var reason: String
    var timestamp: Date
    var gameState: GameStateV2?

    init(
        teamId: String, reason: String, timestamp: Date,
        gameState: GameStateV2? = nil
    ) {
        self.teamId = teamId
        self.reason = reason
        self.timestamp = timestamp
        self.gameState = gameState
    }
}
