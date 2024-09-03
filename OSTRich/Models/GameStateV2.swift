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
    @Relationship(deleteRule: .cascade, inverse: \Round.gameState) var rounds: [Round] = []
    @Relationship(deleteRule: .cascade) var teams: [Team] = []
    @Relationship(deleteRule: .cascade, inverse: \Drop.gameState) var drops: [Drop] = []
//    var podPairingType: String? //unused
    var gamesToWin: Int?
    var event: Event?

    init(
        eventId: String,
        minRounds: Int? = nil,
        draft: Draft? = nil,
        top8Draft: Top8Draft? = nil,
        deckConstruction: DeckConstruction? = nil,
        currentRoundNumber: Int,
//        podPairingType: String? = nil,
        gamesToWin: Int? = nil,
        event: Event? = nil
    ) {
        self.eventId = eventId
        self.event = event
        self.minRounds = minRounds
        self.draft = draft
        self.top8Draft = top8Draft
        self.deckConstruction = deckConstruction
        self.currentRoundNumber = currentRoundNumber
        self.gamesToWin = gamesToWin
    }

    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound, event: Event
    ) {
        var draft: Draft?
        var top8Draft: Top8Draft?
        var deckConstruction: DeckConstruction?
        if let draftData = data.draft {
            draft = Draft(from: draftData)
        }
        if let top8DraftData = data.top8Draft {
            top8Draft = Top8Draft(from: top8DraftData)
        }
        if let deckConstructionData = data.deckConstruction {
            deckConstruction = DeckConstruction(from: deckConstructionData)
        }
        
        self.init(
            eventId: data.eventId, minRounds: data.minRounds, draft: draft,
            top8Draft: top8Draft, deckConstruction: deckConstruction,
            currentRoundNumber: data.currentRoundNumber,
            gamesToWin: data.gamesToWin, event: event
        )
        
        self.post_init(from: data, event: event)
    }
    
    static func createOrUpdate(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound,
        event: Event
    ) -> GameStateV2 {
        if event.gameStateAtRound?.currentRoundNumber == data.currentRoundNumber {
            let gs = event.gameStateAtRound!
            gs.post_init(from: data, event: event)
            return gs
        } else {
            return GameStateV2(from: data, event: event)
        }
    }
   
    private func post_init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound,
        event: Event
    ) {
        if let roundsData = data.rounds {
            self.rounds = roundsData.map { Round.createOrUpdate(from: $0, gamestate: self) }
        }
        if let dropData = data.drops {
            self.drops = dropData.map { Drop.createOrUpdate(from: $0, gameState: self) }
        }
        if let teamsData = data.teams {
            self.teams = teamsData.map { Team.createOrUpdate(from: $0, gamestate: self) }
        }
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
