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
    @Relationship(inverse: \MatchResult.match) var results: [MatchResult]?
    var tableNumber: Int?
    var round: Round?
    
//    var teams: [Team] {
//        return self.round?.gameState?.teams.filter {
//            $0.teamId == self.teamIds[0] || $0.teamId == self.teamIds[1]
//        } ?? []
//    }
    var teams: [Team] {
        guard let teams = self.round?.gameState?.teams else {
            return []
        }
        return teams.filter { team in
            self.teamIds.contains(team.teamId)
        }
    }
    
    init(
        matchId: String, isBye: Bool, teamIds: [String],
        results: [MatchResult]? = nil, tableNumber: Int? = nil,
        round: Round? = nil
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
            .GameStateV2AtRound.Round.Match
    ) {
        let results = data.results!.map {
            MatchResult(from: $0)
        }
        self.init(matchId: data.matchId, isBye: data.isBye ?? false, teamIds: data.teamIds, results: results)
    }
}
