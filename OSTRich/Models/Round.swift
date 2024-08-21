//
//  Round.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Round: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var roundId: String
    var roundNumber: Int
    var isFinalRound: Bool?
    var isPlayoff: Bool?
    var isCertified: Bool?
    @Relationship(deleteRule: .cascade, inverse: \Match.round) var matches: [Match] = []
    var pairingStrategy: String?
    var canRollback: Bool?
    var timerId: String?
    @Relationship(deleteRule: .cascade, inverse: \Standing.round) var standings: [Standing] = []
    var gameState: GameStateV2
    @Relationship(deleteRule: .cascade) var timer: RoundTimer?

    init(
        roundId: String, roundNumber: Int, isFinalRound: Bool? = nil,
        isPlayoff: Bool? = nil, isCertified: Bool? = nil,
        matches: [Match] = [],
        pairingStrategy: String? = nil, canRollback: Bool? = nil,
        timerId: String? = nil,
        standings: [Standing] = [],
        gameState: GameStateV2
    ) {
        self.roundId = roundId
        self.roundNumber = roundNumber
        self.isFinalRound = isFinalRound
        self.isPlayoff = isPlayoff
        self.isCertified = isCertified
        self.matches = matches
        self.pairingStrategy = pairingStrategy
        self.canRollback = canRollback
        self.timerId = timerId
        self.standings = standings
        self.gameState = gameState
        self.timer = RoundTimer()
    }

    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Round,
        gameState: GameStateV2
    ) {
        self.init(
            roundId: data.roundId,
            roundNumber: data.roundNumber,
            timerId: data.timerId,
            gameState: gameState
        )
        self.matches = data.matches.map { Match(from: $0, round: self) }
        self.standings = data.standings.map { Standing(from: $0, round: self) }
    }
    
    static func createOrUpdate(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Round,
        gamestate: GameStateV2
    ) -> Round {
        if let round = gamestate.rounds.first(where: { $0.roundId == data.roundId }) {
            round.roundNumber = data.roundNumber
            round.isFinalRound = data.isFinalRound
            round.isPlayoff = data.isPlayoff
            round.isCertified = data.isCertified
            round.pairingStrategy = data.pairingStrategy
            round.canRollback = data.canRollback
            if data.timerId != "" {
                round.timerId = data.timerId
            }
            
            round.matches = data.matches.map { Match.createOrUpdate(from: $0, round: round) }
            round.standings = data.standings.map { Standing.createOrUpdate(from: $0, round: round) }
            
            return round
        } else {
            return Round(from: data, gameState: gamestate)
        }
    }
    
    var myMatch: Match? {
        return self.matches.first { match in
            match.teams.contains { team in
                team.players.contains { player in
                    player.personaId == UserDefaults.standard.string(forKey: "personaId")!
                }
            }
        }
    }
}
