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
}
