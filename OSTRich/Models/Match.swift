//
//  Match.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Match: Identifiable {
    @Attribute(.unique)
    var matchId: String
    var isBye: Bool = false
    var teamIds: [String]
    @Relationship(deleteRule: .cascade, inverse: \MatchResult.match) var results: [MatchResult]?
    var tableNumber: Int?
    var round: Round
    
    var teams: [Team] {
        self.round.gameState.teams.filter {
            self.teamIds.contains($0.teamId)
        }
    }
    
    var myTeam: Team? {
        return self.teams.first {
            $0.players.contains {
                $0.personaId == UserDefaults.standard.string(forKey: "personaId")!
            }
        }
    }
    
    var myOpponentTeams: [Team] {
        if myTeam == nil { return [] }
        return self.teams.filter {
            $0.teamId != self.myTeam!.teamId
        }
    }

    init(
        matchId: String, isBye: Bool, teamIds: [String],
        results: [MatchResult]? = nil, tableNumber: Int? = nil,
        round: Round
    ) {
        self.matchId = matchId
        self.isBye = isBye
        self.teamIds = teamIds
        self.results = results
        self.tableNumber = tableNumber
        self.round = round
    }

    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Round.Match,
        round: Round
    ) {
        self.init(
            matchId: data.matchId, isBye: data.isBye ?? false,
            teamIds: data.teamIds, tableNumber: data.tableNumber,
            round: round
        )
        self.results = data.results!.map {
            MatchResult(from: $0, match: self)
        }
    }
    
}
