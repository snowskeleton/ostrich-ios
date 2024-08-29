//
//  SwiftDataManager.swift
//  OSTRich
//
//  Created by snow on 8/24/24.
//

import Foundation
import SwiftData

public class SwiftDataManager {
    
    public static let shared = SwiftDataManager()
    
    public let container: ModelContainer = {
        
        let schema = Schema([
            Event.self,
            GameStateV2.self,
            DeckConstruction.self,
            Drop.self,
            Draft.self,
            EventFormat.self,
            Match.self,
            MatchResult.self,
            Player.self,
            Pod.self,
            Registration.self,
            Reservation.self,
            Round.self,
            Seat.self,
            Standing.self,
            Top8Draft.self,
            Team.self,
            ScoutingResult.self,
            LocalPlayer.self
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            crashProtection()
            do {
                NSLog("Failed to load current schema and config. Cleraing and trying again")
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()
    
    
    }
