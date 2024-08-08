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
    var teams: [Team]
    var shortCode: String?
    var scheduledStartTime: Gamestateschema.DateTime?
    var actualStartTime: Gamestateschema.DateTime?
    @Relationship(deleteRule: .cascade)
    var registeredPlayers: [Registration]
    @Relationship(deleteRule: .cascade)
    var gameStateAtRound: GameStateV2?

    var created: Date = Date.now

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
        for player in data.registeredPlayers! {
            if let existingPlayer = self.registeredPlayers.first(where: { $0.id == player.id }) {
                existingPlayer.update(from: player)
            } else {
                let newPlayer = Registration(from: player)
                self.registeredPlayers.append(newPlayer)
            }
        }
    }

    func update(with data: Gamestateschema.LoadEventJoinV2Query.Data.Event) {
        self.title = data.title
        self.pairingType = data.pairingType.rawValue
        self.status = data.status.rawValue
        self.isOnline = data.isOnline
        self.createdBy = data.createdBy
        self.requiredTeamSize = data.requiredTeamSize

        // Initialize eventFormat
        if let format = data.eventFormat {
            self.eventFormat = EventFormat(from: format)
        }

        // Update teams
        // I don't think we're getting Teams data from this endpoint
//        self.teams = data.teams.map { teamData in
//            let registrations = teamData.registrations?.map {
//                Registration(from: $0)
//            }
//
//            let reservations = teamData.reservations?.map {
//                Reservation(from: $0)
//            }
//
//            return Team(
//                eventId: teamData.eventId,
//                registrations: registrations,
//                reservations: reservations,
//                teamId: teamData.id,
//                players: [] as [Player]
//            )
//        }
    }

    //    convenience init(from data: Gamestateschema.LoadEventJoinV2Query.Data) {
    //        let event = data.event!
    //
    //        // Initialize eventFormat
    //        let eventFormat = event.eventFormat.map {
    //            EventFormat(
    //                id: $0.id,
    //                name: $0.name,
    //                includesDraft: $0.includesDraft,
    //                includesDeckbuilding: $0.includesDeckbuilding
    //            )
    //        }
    //
    //        // Initialize teams
    //        let teams = event.teams.map { teamData in
    //            // Initialize registrations
    //            let registrations = teamData.registrations?.map {
    //                Registration(
    //                    id: $0.id,
    //                    status: $0.status?.rawValue,
    //                    personaId: $0.personaId,
    //                    displayName: $0.displayName,
    //                    firstName: $0.firstName,
    //                    lastName: $0.lastName
    //                )
    //            }
    //
    //            // Initialize reservations
    //            let reservations = teamData.reservations?.map {
    //                Reservation(
    //                    personaId: $0.personaId,
    //                    displayName: $0.displayName,
    //                    firstName: $0.firstName,
    //                    lastName: $0.lastName
    //                )
    //            }
    //
    //            return Team(
    //                eventId: teamData.eventId,
    //                teamCode: teamData.teamCode,
    //                isLocked: teamData.isLocked,
    //                isRegistered: teamData.isRegistered,
    //                registrations: registrations,
    //                reservations: reservations,
    //                teamId: teamData.id,
    //                players: []
    //            )
    //        }
    //
    //        self.init(
    //            id: event.id,
    //            title: event.title,
    //            pairingType: event.pairingType.rawValue,
    //            status: event.status.rawValue,
    //            isOnline: event.isOnline,
    //            createdBy: event.createdBy,
    //            requiredTeamSize: event.requiredTeamSize,
    //            eventFormat: eventFormat,
    //            teams: teams,
    //            shortCode: nil,
    //            scheduledStartTime: nil,
    //            actualStartTime: nil
    //        )
    //    }

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
