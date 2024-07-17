//
//  Team.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Team: Identifiable {
    @Attribute(.unique)
    var eventId: String
    var teamCode: String
    var isLocked: Bool?
    var isRegistered: Bool?
    var registrations: [Registration]?
    var reservations: [Reservation]?
    var teamId: String
    var teamName: String?
    @Relationship(inverse: \Player.team) var players: [Player]
    var gameState: GameStateV2?
    
    init(
        eventId: String, teamCode: String, isLocked: Bool?,
        isRegistered: Bool?, registrations: [Registration]?,
        reservations: [Reservation]?,
        teamId: String, teamName: String? = nil, players: [Player],
        gameState: GameStateV2? = nil
    ) {
        self.eventId = eventId
        self.teamCode = teamCode
        self.isLocked = isLocked
        self.isRegistered = isRegistered
        self.registrations = registrations
        self.reservations = reservations
        self.teamId = teamId
        self.teamName = teamName
        self.players = players
        self.gameState = gameState
    }
}

extension Team {
    var fullName: String {
        let firstPlayer = self.players[0]
        let fpName =
        "\(String(describing: firstPlayer.firstName)) \(String(describing: firstPlayer.lastName))"
        if self.players.count == 1 {
            return fpName
        }
        
        let secondPlayer = self.players[1]
        let spName =
        "\(String(describing: secondPlayer.firstName)) \(String(describing: secondPlayer.lastName))"
        var combinedName = "\(fpName) \(spName)"
        if self.players.count == 2 {
            return combinedName
        }
        
        let thirdPlayer = self.players[2]
        let tpName =
        "\(String(describing: thirdPlayer.firstName)) \(String(describing: thirdPlayer.lastName))"
        combinedName = "\(fpName), \(spName), and \(tpName)"
        return combinedName
    }
}
