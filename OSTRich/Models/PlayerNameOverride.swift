//
//  PlayerNameOverride.swift
//  OSTRich
//
//  Created by snow on 9/3/24.
//

import Foundation
import SwiftData

@Model
class PlayerNameOverride {
    @Attribute(.unique)
    var personaId: String
    var userGivenName: String?
    
    init(personaId: String) {
        self.personaId = personaId
    }
    
    @MainActor
    static func createOrUpdate(from personaId: String) -> PlayerNameOverride {
        let predicate = #Predicate<PlayerNameOverride> { $0.personaId == personaId }
        let fetchDescriptor = FetchDescriptor<PlayerNameOverride>(predicate: predicate, sortBy: [SortDescriptor(\.personaId)])
        
        do {
            let names = try SwiftDataManager.shared.container.mainContext.fetch(fetchDescriptor)
            if let override = names.first {
                return override
            }
        } catch { }
        
        let nameOverride = PlayerNameOverride(personaId: personaId)
        SwiftDataManager.shared.container.mainContext.insert(nameOverride)
        return nameOverride
    }
}

//@MainActor
//func nameFromPersona(_ personaId: String) -> String? {
//    let predicate = #Predicate<PlayerNameOverride> { $0.personaId == personaId }
//    let fetchDescriptor = FetchDescriptor<PlayerNameOverride>(predicate: predicate, sortBy: [SortDescriptor(\.personaId)])
//    
//    do {
//        let names = try SwiftDataManager.shared.container.mainContext.fetch(fetchDescriptor)
//        if let name = names.first?.userGivenName {
//            return name
//        }
//    } catch {
//        return nil
//    }
//    return nil
//}

//@MainActor
//func nameOverride(_ player: Player) -> String {
//    if let name = nameFromPersona(player.personaId ?? "") {
//        return name
//    } else {
//        return player.safeName
//    }
//}
//
//@MainActor
//func nameOverride(_ player: Registration) -> String {
//    if let name = nameFromPersona(player.personaId ?? "") {
//        return name
//    } else {
//        return player.safeName
//    }
//}
//
//@MainActor
//func nameOverride(_ player: LocalPlayer) -> String {
//    if let name = nameFromPersona(player.personaId ?? "") {
//        return name
//    } else {
//        return player.safeName
//    }
//}
//
//@MainActor
//func nameOverride(_ player: Reservation) -> String {
//    if let name = nameFromPersona(player.personaId ?? "") {
//        return name
//    } else {
//        return player.safeName
//    }
//}
