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
    var id: String?
    var status: String?
    var personaId: String?
    var displayName: String?
    var firstName: String?
    var lastName: String?
    var safeName: String {
        return safeNameExpander(self.firstName, self.lastName, self.displayName)
    }

    init(
        id: String, status: String?, personaId: String?,
        displayName: String?, firstName: String?, lastName: String?
    ) {
        self.id = id
        self.status = status
        self.personaId = personaId
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
    }

    convenience init(
        from data: Gamestateschema.LoadEventJoinV2Query.Data.Event.Team
            .Registration
    ) {
        self.init(
            id: data.id, status: data.status?.rawValue,
            personaId: data.personaId, displayName: data.displayName,
            firstName: data.firstName, lastName: data.lastName
        )
    }

    convenience init(
        from data: Gamestateschema.LoadEventHostV2Query.Data.Event
            .RegisteredPlayer
    ) {
        self.init(
            id: data.id, status: data.status?.rawValue,
            personaId: data.personaId, displayName: data.displayName,
            firstName: data.firstName, lastName: data.lastName
        )
    }
    
    func update(from data: Gamestateschema.LoadEventHostV2Query.Data.Event
        .RegisteredPlayer) {
            self.id = id
            self.status = status
            self.personaId = personaId
            self.displayName = displayName
            self.firstName = firstName
            self.lastName = lastName
        }
}
