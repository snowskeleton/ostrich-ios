//
//  OSTRichTests.swift
//  OSTRichTests
//
//  Created by snow on 8/29/24.
//

import Testing
import Foundation
import OSTRich


struct OSTRichTests {
    
    @Test func dontCrashOnSerialize() async throws {
        let team1Wins = 2
        let team2Wins = 1
        let team1Losses = 1
        let team2Losses = 2
        
        var teamResults = [Gamestateschema.TeamResultInputV2]()
        
        let team1Result = Gamestateschema.TeamResultInputV2(
            matchId: "1",
            isBye: false,
            wins: team1Wins,
            losses: team1Losses,
            draws: 0,
            teamId: "1"
        )
        let team2Result = Gamestateschema.TeamResultInputV2(
            matchId: "2",
            isBye: false,
            wins: team2Wins,
            losses: team2Losses,
            draws: 0,
            teamId: "2"
        )
        
        teamResults.append(team1Result)
        teamResults.append(team2Result)
        let mutation = Gamestateschema.RecordMatchResultV2Mutation(eventId: "someEventId", results: teamResults)
        
        let loggableVariables = convertToLoggableFormat(mutation.__variables ?? [:])
        print(String(describing: loggableVariables))
        
        // Serialize the sanitized variables
        let _ = try JSONSerialization.data(withJSONObject: loggableVariables ?? [:], options: [])
        #expect(true)
    }
    
}

fileprivate func convertToLoggableFormat(_ object: Any) -> Any? {
    if let dict = object as? [String: Any] {
        var loggableDict = [String: Any]()
        for (key, value) in dict {
            loggableDict[key] = convertToLoggableFormat(value)
        }
        return loggableDict
    } else if let array = object as? [Any] {
        return array.compactMap { convertToLoggableFormat($0) }
    } else if let customSerializable = object as? CustomSerializable {
        return customSerializable.toDictionary()
    } else if JSONSerialization.isValidJSONObject(object) {
        return object
    } else {
        return String(describing: object)
    }
}


protocol CustomSerializable {
    func toDictionary() -> [String: Any]
}

extension Gamestateschema.TeamResultInputV2: CustomSerializable {
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["matchId"] = matchId
        dict["submitter"] = submitter.unwrapped
        dict["isBye"] = isBye
        dict["wins"] = wins
        dict["losses"] = losses
        dict["draws"] = draws
        dict["teamId"] = teamId
        return dict
    }
}

