//
//  Seat.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Seat: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var seatNumber: Int
    var teamId: String
    var pod: Pod?
    var deckConstruction: DeckConstruction?
    
    init(
        seatNumber: Int, teamId: String, pod: Pod? = nil,
        deckConstruction: DeckConstruction? = nil
    ) {
        self.seatNumber = seatNumber
        self.teamId = teamId
        self.pod = pod
        self.deckConstruction = deckConstruction
    }
    
    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.Draft.Pod.Seat,
        pod: Pod
    ) {
        self.init(seatNumber: data.seatNumber, teamId: data.teamId)
        self.pod = pod
    }
    
    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.Top8Draft.Pod.Seat,
        pod: Pod
    ) {
        self.init(seatNumber: data.seatNumber, teamId: data.teamId)
        self.pod = pod
    }
    
    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.DeckConstruction.Seat,
        deckConstruction: DeckConstruction
    ) {
        self.init(seatNumber: data.seatNumber, teamId: data.teamId)
        self.deckConstruction = deckConstruction
    }
    
    static func createOrUpdate(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.Draft.Pod.Seat,
        pod: Pod
    ) -> Seat {
        if let seat = pod.seats.first(where: { $0.teamId == data.teamId }) {
            seat.seatNumber = data.seatNumber
            return seat
        } else {
            return Seat(from: data, pod: pod)
        }
        
    }
    static func createOrUpdate(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.Top8Draft.Pod.Seat,
        pod: Pod
    ) -> Seat {
        if let seat = pod.seats.first(where: { $0.teamId == data.teamId }) {
            seat.seatNumber = data.seatNumber
            return seat
        } else {
            return Seat(from: data, pod: pod)
        }
    }
    static func createOrUpdate(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data.GameStateV2AtRound.DeckConstruction.Seat,
        deckConstruction: DeckConstruction
    ) -> Seat {
        if let seat = deckConstruction.seats.first(where: { $0.teamId == data.teamId }) {
            seat.seatNumber = data.seatNumber
            return seat
        } else {
            return Seat(from: data, deckConstruction: deckConstruction)
        }
    }
}
