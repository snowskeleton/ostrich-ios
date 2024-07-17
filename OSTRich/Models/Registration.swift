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
        //        self.event = event
    }
}
