//
//  Player.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Player: Identifiable {
    @Attribute(.unique)
    var id: String
    var team: Team?
    var personaId: String?
    var displayName: String?
    var firstName: String?
    var lastName: String?
    
    var safeName: String {
        return safeNameExpander(self.firstName, self.lastName, self.displayName)
    }
    
    init(
        id: String, personaId: String, displayName: String?,
        firstName: String?, lastName: String?, team: Team?
    ) {
        self.id = id
        self.personaId = personaId
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.team = team
    }
}
