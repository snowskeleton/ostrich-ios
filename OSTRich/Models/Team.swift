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
    @Relationship(deleteRule: .noAction, inverse: \Player.team)
    var players: [Player] = []
    @Relationship(deleteRule: .cascade)
    var gameState: GameStateV2?
    
    
    init(
        teamId: String,
        teamName: String? = nil,
        players: [Player] = [],
        gameState: GameStateV2? = nil
    ) {
        self.teamId = teamId
        self.teamName = teamName
        self.players = players
        self.gameState = gameState

    }
    
    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Team,
        gamestate: GameStateV2
    ) {
        self.init(
            teamId: data.teamId,
            teamName: data.teamName,
            gameState: gamestate
        )
        self.players = data.players.map { Player.createOrUpdate(from: $0, team: self) }    }
    
    static func createOrUpdate(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Team,
        gamestate: GameStateV2
    ) -> Team {
        if let team = gamestate.teams.first(where: { $0.teamId == data.teamId }) {
            team.teamName = data.teamName
            // implement createOrUpdate for Players too
            team.players = data.players.map { Player.createOrUpdate(from: $0, team: team) }
//            team.players.forEach { $0.team = team }
            return team
        } else {
            return Team(from: data, gamestate: gamestate)
        }
    }
}

extension Team {
    var fullName: String {
        if self.players.count == 0 {
            return "No players in team"
        }
        
        if self.players.count == 1 {
            return self.players[0].safeName
        }

        if self.players.count == 2 {
            return "\(self.players[0].safeName) and \(self.players[1].safeName)"
        }

        if self.players.count == 3 {
            return "\(self.players[0].safeName), \(self.players[1].safeName), and \(self.players[2].safeName)"
        }
        
        return "Unknown player count"
    }
}
