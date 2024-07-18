//
//  DeckConstruction.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class DeckConstruction: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var timerId: String?
    @Relationship(inverse: \Seat.deckConstruction) var seats: [Seat]
    
    init(timerId: String? = nil, seats: [Seat]) {
        self.timerId = timerId
        self.seats = seats
    }
    
    convenience init(from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.DeckConstruction) {
        let seats = data.seats.map { Seat(from: $0) }
        self.init(timerId: data.timerId, seats: seats)
    }
}
