//
//  Pod.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Pod: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var podNumber: Int
    @Relationship(inverse: \Seat.pod) var seats: [Seat]
    var draft: Draft?
    var top8Draft: Top8Draft?
    
    init(
        podNumber: Int, seats: [Seat], draft: Draft? = nil,
        top8Draft: Top8Draft? = nil
    ) {
        self.podNumber = podNumber
        self.seats = seats
        self.draft = draft
        self.top8Draft = top8Draft
    }
}
