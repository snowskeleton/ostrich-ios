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
    var podPairingType: String? //unused
    var gamesToWin: Int?
    var event: Event?

    init(
        eventId: String, minRounds: Int? = nil, draft: Draft? = nil,
        top8Draft: Top8Draft? = nil, deckConstruction: DeckConstruction? = nil,
        currentRoundNumber: Int, rounds: [Round] = [], teams: [Team] = [],
        drops: [Drop] = [], podPairingType: String? = nil,
        gamesToWin: Int? = nil, event: Event? = nil
    ) {
        self.eventId = eventId
//        self.event = event
        self.minRounds = minRounds
        self.draft = draft
        self.top8Draft = top8Draft
        self.deckConstruction = deckConstruction
        self.currentRoundNumber = currentRoundNumber
        self.rounds = rounds
        self.teams = teams
        self.drops = drops
        self.gamesToWin = gamesToWin
    }

    convenience init() {
        self.init(eventId: "some string", currentRoundNumber: 0, event: nil)
    }
    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound, event: Event
    ) {
        var draft: Draft?
        var top8Draft: Top8Draft?
        var deckConstruction: DeckConstruction?
        var rounds: [Round] = []
        var drops: [Drop] = []
        var teams: [Team] = []
        if let draftData = data.draft {
            draft = Draft(from: draftData)
        }
        if let top8DraftData = data.top8Draft {
            top8Draft = Top8Draft(from: top8DraftData)
        }
        if let deckConstructionData = data.deckConstruction {
            deckConstruction = DeckConstruction(from: deckConstructionData)
        }
        if let roundsData = data.rounds {
            rounds = roundsData.map { Round(from: $0) }
        }
        if let dropData = data.drops {
            drops = dropData.map { Drop(from: $0) }
        }

        if let teamsData = data.teams {
            teams = teamsData.map { Team(from: $0) }
        }
        
        self.init(
            eventId: data.eventId, minRounds: data.minRounds, draft: draft,
            top8Draft: top8Draft, deckConstruction: deckConstruction,
            currentRoundNumber: data.currentRoundNumber, rounds: rounds,
            teams: teams, drops: drops,
            gamesToWin: data.gamesToWin// , event: event
        )
        rounds.forEach { $0.gameState = self }
        drops.forEach { $0.gameState = self }
        teams.forEach { $0.gameState = self }
    }

    var currentRound: Round? {
        return rounds.first(where: { $0.roundNumber == currentRoundNumber })
    }

    var currentMatches: [Match] {
        if let currentRound = self.currentRound {
            return currentRound.matches
        }
        return []
    }
}
