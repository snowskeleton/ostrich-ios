//
//  ScoutingResult.swift
//  OSTRich
//
//  Created by snow on 8/21/24.
//

import Foundation
import SwiftData

@Model
class ScoutingResult: Identifiable {
    @Attribute(.unique)
    var id: String = UUID().uuidString
    var deckName: String
    var deckNotes: String?
    var eventName: String?
    var eventId: String?
    var playerName: String?
    var playerPersonaId: String?

    
    init(
        deckName: String,
        deckNotes: String? = nil,
        eventName: String? = nil,
        eventId: String? = nil,
        playerName: String? = nil,
        playerPersonaId: String? = nil
    ) {
        self.deckName = deckName
        self.deckNotes = deckNotes
        self.eventName = eventName
        self.eventId = eventId
        self.playerName = playerName
        self.playerPersonaId = playerPersonaId
    }
}
