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
    var roundNumber: Int
    var gameState: GameStateV2

    init(
        teamId: String, roundNumber: Int,
        gameState: GameStateV2
    ) {
        self.teamId = teamId
        self.roundNumber = roundNumber
        self.gameState = gameState
    }

    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Drop,
        gameState: GameStateV2
    ) {
        self.init(
            teamId: data.teamId,
            roundNumber: data.roundNumber,
            gameState: gameState
        )
    }
    
    static func createOrUpdate(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Drop,
        gameState: GameStateV2
    ) -> Drop {
        if let drop = gameState.drops.first(where: { $0.teamId == data.teamId }) {
            drop.roundNumber = data.roundNumber
            return drop
        } else {
            return Drop(from: data, gameState: gameState)
        }
    }
}
