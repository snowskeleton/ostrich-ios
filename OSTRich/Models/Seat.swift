//
//  Seat.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Seat: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var seatNumber: Int
    var teamId: String
    var pod: Pod?
    var deckConstruction: DeckConstruction?
    
    init(
        seatNumber: Int, teamId: String, pod: Pod? = nil,
        deckConstruction: DeckConstruction? = nil
    ) {
        self.seatNumber = seatNumber
        self.teamId = teamId
        self.pod = pod
        self.deckConstruction = deckConstruction
    }
    
    convenience init(from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.Draft.Pod.Seat) {
        self.init(seatNumber: data.seatNumber, teamId: data.teamId)
    }
    
    convenience init(from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.Top8Draft.Pod.Seat) {
        self.init(seatNumber: data.seatNumber, teamId: data.teamId)
    }
    
    convenience init(from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.DeckConstruction.Seat) {
        self.init(seatNumber: data.seatNumber, teamId: data.teamId)
    }
}
