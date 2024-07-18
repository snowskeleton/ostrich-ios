//
//  Reservation.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Reservation: Identifiable {
    @Attribute(.unique)
    var personaId: String?
    var displayName: String?
    var firstName: String?
    var lastName: String?
    var safeName: String {
        return safeNameExpander(self.firstName, self.lastName, self.displayName)
    }

    init(
        personaId: String?, displayName: String?, firstName: String?,
        lastName: String?
    ) {
        self.personaId = personaId
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
    }
    convenience init(
        from data: Gamestateschema.LoadEventJoinV2Query.Data.Event.Team
            .Reservation
    ) {
        self.init(
            personaId: data.personaId, displayName: data.displayName,
            firstName: data.firstName, lastName: data.lastName)
    }
}
