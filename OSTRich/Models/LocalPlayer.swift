//
//  Player.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

import Foundation
import SwiftData

@Model
class LocalPlayer: Identifiable {
//    @Attribute(.unique) var id = UUID()

    @Attribute(.unique)
    var personaId: String?
    var displayName: String?
    var firstName: String?
    var lastName: String?
    
    var stats: [ScoutingResult] = []

    var safeName: String {
        return safeNameExpander(self.firstName, self.lastName, self.displayName, nil, self.personaId)
    }

    var formatsPlayed: [String] {
        return Array(Set(stats.map { $0.format }))
    }
    
    init(
        personaId: String, displayName: String?,
        firstName: String?, lastName: String?
    ) {
        self.personaId = personaId
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
    }
    
    convenience init(_ player: Player) {
        self.init(
            personaId: player.personaId!,
            displayName: player.displayName,
            firstName: player.firstName,
            lastName: player.lastName
        )
    }
    convenience init(_ player: Registration) {
        self.init(
            personaId: player.personaId!,
            displayName: player.displayName,
            firstName: player.firstName,
            lastName: player.lastName
        )
    }
    
    @MainActor static func createOrUpdate(from player: Registration) -> LocalPlayer {
        let registrationId = player.personaId!
        let predicate = #Predicate<LocalPlayer> { $0.personaId == registrationId }
        let fetchDescriptor = FetchDescriptor<LocalPlayer>(predicate: predicate)
        let context = SwiftDataManager.shared.container.mainContext
        let players = try? context.fetch(fetchDescriptor)
        
        if let finalPlayer = (players ?? []).first {
            return finalPlayer
        } else {
            return .init(player)
        }
    }

    @MainActor static func createOrUpdate(from player: Player) -> LocalPlayer {
        let playerId = player.personaId!
        let predicate = #Predicate<LocalPlayer> { $0.personaId == playerId }
//        let predicate = #Predicate<LocalPlayer> { $0.personaId == player.personaId }
        let fetchDescriptor = FetchDescriptor<LocalPlayer>(predicate: predicate)
        let context = SwiftDataManager.shared.container.mainContext
        let players = try? context.fetch(fetchDescriptor)

        if let finalPlayer = (players ?? []).first {
            return finalPlayer
        } else {
            return .init(player)
        }
    }

    @MainActor static func createOrUpdate(
        personaId: String, displayName: String?,
        firstName: String?, lastName: String?
    ) -> LocalPlayer {
        let fetchDescriptor = FetchDescriptor<LocalPlayer>(
            predicate: #Predicate<LocalPlayer> { $0.personaId == personaId }
        )
        let context = SwiftDataManager.shared.container.mainContext
        let players = try? context.fetch(fetchDescriptor)

        if let finalPlayer = (players ?? []).first {
            return finalPlayer
        } else {
            return .init(
                personaId: personaId,
                displayName: displayName,
                firstName: firstName,
                lastName: lastName
            )
        }
    }

//    convenience init(
//        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
//            .GameStateV2AtRound.Team.Player,
//        team: Team
//    ) {
//        self.init(
//            personaId: data.personaId, displayName: data.displayName,
//            firstName: data.firstName, lastName: data.lastName, team: team)
//    }
    
//    static func createOrUpdate(
//        from data: Gamestateschema.GetGameStateV2AtRoundQuery.Data
//            .GameStateV2AtRound.Team.Player,
//        team: Team
//    ) -> Player {
//        if let player = team.players.first(where: {
//            $0.personaId == data.personaId
//        }) {
//            player.displayName = data.displayName
//            player.firstName = data.firstName
//            player.lastName = data.lastName
//            return player
//        } else {
//            return Player(from: data, team: team)
//        }
//    }
}
