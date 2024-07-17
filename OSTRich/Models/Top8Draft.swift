//
//  Top8Draft.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Top8Draft: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    @Relationship(inverse: \Pod.top8Draft) var pods: [Pod]
    var timerId: String?
    
    init(pods: [Pod], timerId: String? = nil) {
        self.pods = pods
        self.timerId = timerId
    }
}
