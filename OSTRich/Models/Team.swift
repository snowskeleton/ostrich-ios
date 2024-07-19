//
//  Team.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Team: Identifiable {
    @Attribute(.unique)
    var id: String = UUID().uuidString
    
    var teamId: String
    var teamName: String?
    @Relationship(inverse: \Player.team)
    var players: [Player] = []
    @Relationship(deleteRule: .cascade)
    var gameState: GameStateV2
    
    
//    var registrations: [Registration]?
//    var reservations: [Reservation]?
    
    init(
        teamId: String,
        teamName: String? = nil,
        players: [Player] = [],
        gameState: GameStateV2
    ) {
        self.teamId = teamId
        self.teamName = teamName
        self.gameState = gameState
        self.players = players

    }
    
    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Team,
        gamestate: GameStateV2
    ) {
        self.init(
            teamId: data.teamId,
            teamName: data.teamName,
            players: data.players.map { Player(from: $0) },
            gameState: gamestate
        )
        self.players.forEach { $0.team = self }
    }

}

extension Team {
    var fullName: String {
        if self.players.count == 1 {
            return self.players[0].safeName
        }

        if self.players.count == 2 {
            return "\(self.players[0].safeName) and \(self.players[1].safeName)"
        }

        return "\(self.players[0].safeName), \(self.players[1].safeName), and \(self.players[2].safeName)"
    }
}
