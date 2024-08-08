//
//  Player.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class Player: Identifiable {
    @Attribute(.unique) var id = UUID()
    
    var personaId: String?
    var displayName: String?
    var firstName: String?
    var lastName: String?
    var team: Team?

    var safeName: String {
        return safeNameExpander(self.firstName, self.lastName, self.displayName, self.team?.teamId, self.personaId)
    }

    init(
        personaId: String, displayName: String?,
        firstName: String?, lastName: String?, team: Team? = nil
    ) {
        self.personaId = personaId
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.team = team
    }

    convenience init(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Team.Player,
        team: Team
    ) {
        self.init(
            personaId: data.personaId, displayName: data.displayName,
            firstName: data.firstName, lastName: data.lastName, team: team)
    }
    
    static func createOrUpdate(
        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
            .GameStateV2AtRound.Team.Player,
        team: Team
    ) -> Player {
        if let player = team.players.first(where: {
            $0.personaId == data.personaId
        }) {
            player.displayName = data.displayName
            player.firstName = data.firstName
            player.lastName = data.lastName
            return player
        } else {
            return Player(from: data, team: team)
        }
    }
}
