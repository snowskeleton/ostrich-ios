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
    let personaId: String?
    let displayName: String?
    let firstName: String?
    let lastName: String?
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
}
