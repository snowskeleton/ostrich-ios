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
    
    convenience init(from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.Draft.Pod) {
        let seats = data.seats.map {
            Seat(from: $0)
        }
        self.init(podNumber: data.podNumber, seats: seats)
    }
    
    convenience init(from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.Top8Draft.Pod) {
        let seats = data.seats.map {
            Seat(from: $0)
        }
        self.init(podNumber: data.podNumber, seats: seats)
    }
    
    static func createOrUpdate(
        from draftData: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.Draft.Pod,
        draft: Draft
    ) -> Pod  {
        if let pod = draft.pods.first(where: { $0.podNumber == draftData.podNumber }) {
            pod.seats = draftData.seats.map {
                Seat.createOrUpdate(from: $0, pod: pod)
            }
            return pod
        } else {
            return Pod(from: draftData)
        }
    }
        
    static func createOrUpdate(
        from top8DraftData: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.Top8Draft.Pod,
        top8Draft: Top8Draft
    ) -> Pod  {
        if let pod = top8Draft.pods.first(where: { $0.podNumber == top8DraftData.podNumber }) {
            pod.seats = top8DraftData.seats.map {
                Seat.createOrUpdate(from: $0, pod: pod)
            }
            return pod
        } else {
            return Pod(from: top8DraftData)
        }
    }
}
extension String: @retroactive Error {}
