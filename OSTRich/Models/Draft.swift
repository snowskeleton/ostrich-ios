//
//  Draft.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Draft: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    @Relationship(inverse: \Pod.draft) var pods: [Pod]
    var timerId: String?
    
    init(pods: [Pod], timerId: String? = nil) {
        self.pods = pods
        self.timerId = timerId
    }
    
    convenience init(from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.Draft) {
        let pods = data.pods.map {
            Pod(from: $0)
        }
        self.init(pods: pods, timerId: data.timerId)
    }
}
