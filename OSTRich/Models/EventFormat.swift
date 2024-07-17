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
    let id: String?
    let name: String = ""
    let includesDraft: Bool = false
    let includesDeckbuilding: Bool = false
    
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
