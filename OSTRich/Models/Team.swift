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
        let firstPlayer = self.players[0]
        let fpName =
            "\(String(describing: firstPlayer.firstName)) \(String(describing: firstPlayer.lastName))"
        if self.players.count == 1 {
            return fpName
        }

        let secondPlayer = self.players[1]
        let spName =
            "\(String(describing: secondPlayer.firstName)) \(String(describing: secondPlayer.lastName))"
        var combinedName = "\(fpName) \(spName)"
        if self.players.count == 2 {
            return combinedName
        }

        let thirdPlayer = self.players[2]
        let tpName =
            "\(String(describing: thirdPlayer.firstName)) \(String(describing: thirdPlayer.lastName))"
        combinedName = "\(fpName), \(spName), and \(tpName)"
        return combinedName
    }
}
