//
//  GameStateV2.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class GameStateV2: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var eventId: String
    var minRounds: Int?
    var draft: Draft?
    var top8Draft: Top8Draft?
    var deckConstruction: DeckConstruction?
    var currentRoundNumber: Int
    @Relationship(inverse: \Round.gameState) var rounds: [Round] = []
    @Relationship(inverse: \Team.gameState) var teams: [Team] = []
    @Relationship(inverse: \Drop.gameState) var drops: [Drop] = []
    var podPairingType: String?
    var gamesToWin: Int?
    
    init(
        eventId: String, minRounds: Int? = nil, draft: Draft? = nil,
        top8Draft: Top8Draft? = nil, deckConstruction: DeckConstruction? = nil,
        currentRoundNumber: Int, rounds: [Round] = [], teams: [Team] = [],
        drops: [Drop] = [], podPairingType: String? = nil,
        gamesToWin: Int? = nil
    ) {
        self.eventId = eventId
        self.minRounds = minRounds
        self.draft = draft
        self.top8Draft = top8Draft
        self.deckConstruction = deckConstruction
        self.currentRoundNumber = currentRoundNumber
        self.rounds = rounds
        self.teams = teams
        self.drops = drops
        self.podPairingType = podPairingType
        self.gamesToWin = gamesToWin
    }
}
