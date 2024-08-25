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
    var format: String = ""
    var player: LocalPlayer?
    
    var date: Date = Date.now

    
    init(
        deckName: String,
        deckNotes: String? = nil,
        eventName: String? = nil,
        eventId: String? = nil,
        playerName: String? = nil,
        playerPersonaId: String? = nil,
        format: String = "",
        player: LocalPlayer,
        date: Date
        
    ) {
        self.deckName = deckName
        self.deckNotes = deckNotes
        self.eventName = eventName
        self.eventId = eventId
        self.format = format
        self.player = player
        self.date = date
    }
}
