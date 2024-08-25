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
        id: String = UUID().uuidString,
        name: String,
        includesDraft: Bool = false,
        includesDeckbuilding: Bool = false
    ) {
        self.id = id
        self.name = name
        self.includesDraft = includesDraft
        self.includesDeckbuilding = includesDeckbuilding
    }

    convenience init(
        from data: Gamestateschema.LoadEventJoinV2Query.Data.Event.EventFormat
    ) {
        self.init(
            id: data.id, name: data.name, includesDraft: data.includesDraft,
            includesDeckbuilding: data.includesDeckbuilding)
    }
}
