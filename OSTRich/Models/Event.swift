//
//  Event.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Event: Identifiable {
    @Attribute(.unique)
    var id: String
    var title: String
    var pairingType: String?
    var status: String?
    var isOnline: Bool?
    var createdBy: String?
    var requiredTeamSize: Int
    @Relationship(deleteRule: .cascade)
    var eventFormat: EventFormat?
    var teams: [Team] = []
    var shortCode: String?
    var scheduledStartTime: Gamestateschema.DateTime?
    var actualStartTime: Gamestateschema.DateTime?
    @Relationship(deleteRule: .cascade)
    var registeredPlayers: [Registration] = []
    @Relationship(deleteRule: .cascade)
    var gameStateAtRound: GameStateV2?

    var created: Date = Date.now
    
    var isFakeEvent: Bool = false

    init(
        id: String, title: String, pairingType: String?, status: String?,
        isOnline: Bool?, createdBy: String?, requiredTeamSize: Int,
        eventFormat: EventFormat?, teams: [Team], shortCode: String?,
        scheduledStartTime: Gamestateschema.DateTime?,
        actualStartTime: Gamestateschema.DateTime?,
        registeredPlayers: [Registration] = [],
        gameStateAtRound: GameStateV2? = nil
    ) {
        self.id = id
        self.title = title
        self.pairingType = pairingType
        self.status = status
        self.isOnline = isOnline
        self.createdBy = createdBy
        self.requiredTeamSize = requiredTeamSize
        self.eventFormat = eventFormat
        self.teams = teams
        self.shortCode = shortCode
        self.scheduledStartTime = scheduledStartTime
        self.actualStartTime = actualStartTime
        self.registeredPlayers = registeredPlayers
        self.gameStateAtRound = gameStateAtRound
    }

}

extension Event {

    func update(
        with data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound
    ) {
        self.gameStateAtRound = GameStateV2.createOrUpdate(from: data, event: self)
    }
    
    func update(
        with data: Gamestateschema.MyActiveEventsQuery.Data.MyActiveEvent
    ) {
        self.actualStartTime = data.actualStartTime
        self.createdBy = data.createdBy
        self.scheduledStartTime = data.scheduledStartTime
        self.shortCode = data.shortCode
        self.title = data.title
        if let eventFormatData = data.eventFormat {
            self.eventFormat = EventFormat(
                id: eventFormatData.id,
                name: eventFormatData.name,
                includesDraft: eventFormatData.includesDraft,
                includesDeckbuilding: eventFormatData
                    .includesDeckbuilding
            )
        }
    }

    func update(with data: Gamestateschema.LoadEventHostV2Query.Data.Event) {
        self.pairingType = data.pairingType.rawValue
        self.status = data.status.rawValue
        self.isOnline = data.isOnline
        self.shortCode = data.shortCode
        
        if let players = data.registeredPlayers {
            self.registeredPlayers = players.map { Registration.createOrUpdate(from: $0, event: self) }
        }
//        for player in data.registeredPlayers! {
//            if let existingPlayer = self.registeredPlayers.first(where: { $0.id == player.id }) {
//                existingPlayer.update(from: player, event: self)
//            } else {
//                let newPlayer = Registration(from: player, event: self)
//                self.registeredPlayers.append(newPlayer)
//            }
//        }
    }

    func update(with data: Gamestateschema.LoadEventJoinV2Query.Data.Event) {
        self.title = data.title
        self.pairingType = data.pairingType.rawValue
        self.status = data.status.rawValue
        self.isOnline = data.isOnline
        self.createdBy = data.createdBy
        self.requiredTeamSize = data.requiredTeamSize

        if let format = data.eventFormat {
            self.eventFormat = EventFormat(from: format)
        }
    }


    convenience init(
        from event: Gamestateschema.MyActiveEventsQuery.Data.MyActiveEvent
    ) {
        self.init(
            id: event.id,
            title: event.title,
            pairingType: nil,
            status: nil,
            isOnline: nil,
            createdBy: event.createdBy ?? "",
            requiredTeamSize: 0,  // Replace with actual requiredTeamSize value
            eventFormat: nil,
            teams: [] as [Team],
            shortCode: event.shortCode,
            scheduledStartTime: event.scheduledStartTime,
            actualStartTime: event.actualStartTime
        )
    }
    
    var standings: [Standing] {
        if let round = self.gameStateAtRound?.currentRound {
            return round.standings
        } else {
            return []
        }
    }
    
}
