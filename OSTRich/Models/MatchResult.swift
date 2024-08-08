//
//  MatchResult.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class MatchResult: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var matchId: String
    var submitter: String?
    var isBye: Bool
    var wins: Int
    var losses: Int
    var draws: Int
    var teamId: String
    var match: Match

    init(
        matchId: String, submitter: String?, isBye: Bool, wins: Int, losses: Int,
        draws: Int, teamId: String, match: Match
    ) {
        self.matchId = matchId
        self.submitter = submitter
        self.isBye = isBye
        self.wins = wins
        self.losses = losses
        self.draws = draws
        self.teamId = teamId
        self.match = match
    }

    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Round.Match.Result,
        match: Match
    ) {
        self.init(
            matchId: data.matchId, submitter: data.submitter, isBye: data.isBye,
            wins: data.wins, losses: data.losses, draws: data.draws,
            teamId: data.teamId,
            match: match
        )
    }
    
    static func createOrUpdate(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Round.Match.Result,
        match: Match
    ) -> MatchResult {
        if let result = match.results!.first(where: { $0.matchId == data.matchId && $0.teamId == data.teamId }) {
            result.submitter = data.submitter
            result.isBye = data.isBye
            result.wins = data.wins
            result.losses = data.losses
            result.draws = data.draws
            return result
        } else {
            return MatchResult(from: data, match: match)
        }
    }
    
}
