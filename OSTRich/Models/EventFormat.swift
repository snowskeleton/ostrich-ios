//
//  EventFormat.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class EventFormat: Identifiable {
    @Attribute(.unique)
    var id: String?
    var name: String = ""
    var includesDraft: Bool = false
    var includesDeckbuilding: Bool = false
    
    init(
        id: String, name: String, includesDraft: Bool,
        includesDeckbuilding: Bool
    ) {
        self.id = id
        self.name = name
        self.includesDraft = includesDraft
        self.includesDeckbuilding = includesDeckbuilding
    }
}
