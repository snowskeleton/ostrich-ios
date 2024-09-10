//
//  Registration.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Registration: Identifiable {
    @Attribute(.unique)
    var localId: String = UUID().uuidString
    var id: String?
    var status: String?
    var personaId: String?
    var displayName: String?
    var firstName: String?
    var lastName: String?
    var event: Event?
    
    var safeName: String {
        return safeNameExpander(self.firstName, self.lastName, self.displayName, nil, self.personaId)
    }

    init(
        id: String,
        status: String?,
        personaId: String?,
        displayName: String?,
        firstName: String?,
        lastName: String?,
        event: Event? = nil
    ) {
        self.id = id
        self.status = status
        self.personaId = personaId
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.event = event
    }

    convenience init(
        from data: Gamestateschema.LoadEventJoinV2Query.Data.Event.Team
            .Registration,
        event: Event
    ) {
        self.init(
            id: data.id, status: data.status?.rawValue,
            personaId: data.personaId, displayName: data.displayName,
            firstName: data.firstName, lastName: data.lastName, event: event
        )
    }

    convenience init(
        from data: Gamestateschema.LoadEventHostV2Query.Data.Event
            .RegisteredPlayer,
        event: Event
    ) {
        self.init(
            id: data.id, status: data.status?.rawValue,
            personaId: data.personaId, displayName: data.displayName,
            firstName: data.firstName, lastName: data.lastName, event: event
        )
    }
    
    func update(
        from data: Gamestateschema.LoadEventHostV2Query.Data.Event
        .RegisteredPlayer,
        event: Event
    ) {
            self.id = id
            self.status = status
            self.personaId = personaId
            self.displayName = displayName
            self.firstName = firstName
            self.lastName = lastName
        }
    
    static func createOrUpdate(
        from data: Gamestateschema.LoadEventHostV2Query.Data.Event
            .RegisteredPlayer,
        event: Event
    ) -> Registration {
        if let existingPlayer = event.registeredPlayers.first(where: { $0.id == data.id }) {
            existingPlayer.status = data.status?.rawValue
            existingPlayer.personaId = data.personaId
            existingPlayer.displayName = data.displayName
            existingPlayer.firstName = data.firstName
            existingPlayer.lastName = data.lastName
            return existingPlayer
        } else {
            return Registration(from: data, event: event)
        }
    }
}
