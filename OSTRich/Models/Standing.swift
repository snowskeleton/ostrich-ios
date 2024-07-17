//
//  Standing.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Standing: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var teamId: String
    var rank: Int
    var wins: Int
    var losses: Int
    var draws: Int
    var matchPoints: Int
    var gameWinPercent: Double
    var opponentGameWinPercent: Double
    var opponentMatchWinPercent: Double
    var round: Round?

    init(
        teamId: String, rank: Int, wins: Int, losses: Int, draws: Int,
        matchPoints: Int, gameWinPercent: Double,
        opponentGameWinPercent: Double, opponentMatchWinPercent: Double,
        round: Round? = nil
    ) {
        self.teamId = teamId
        self.rank = rank
        self.wins = wins
        self.losses = losses
        self.draws = draws
        self.matchPoints = matchPoints
        self.gameWinPercent = gameWinPercent
        self.opponentGameWinPercent = opponentGameWinPercent
        self.opponentMatchWinPercent = opponentMatchWinPercent
        self.round = round
    }
}
