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
    var isBye: Bool?
    var teamIds: [String]
    @Relationship(inverse: \MatchResult.match) var results: [MatchResult]?
    var tableNumber: Int?
    var round: Round?
    
    var teams: [Team] {
        return self.round?.gameState?.teams.filter {
            $0.teamId == self.teamIds[0] || $0.teamId == self.teamIds[1]
        } ?? []
    }
    
    init(
        matchId: String, isBye: Bool? = nil, teamIds: [String],
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
}
