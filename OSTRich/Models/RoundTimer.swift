//
//  RoundTimer.swift
//  OSTRich
//
//  Created by snow on 8/20/24.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@Model
class RoundTimer: Identifiable {
    @Attribute(.unique)
    var localId: String
    var id: String?
    var state: TimerState?
    var durationMs: Int?
    var durationStartTime: Date?
    var serverTime: Date?
    var round: Round?
    
    var created: Date = Date.now
    
    init(
        id: String?,
        state: TimerState = TimerState.uncreated,
        durationMs: Int?,
        durationStartTime: Date?,
        serverTime: Date?,
        round: Round?
    ) {
        self.localId = UUID().uuidString
        self.id = id
        self.state = state
        self.durationMs = durationMs
        self.durationStartTime = durationStartTime
        self.serverTime = serverTime
        self.round = round
    }
    
    convenience init() {
        self.init(
            id: nil,
            durationMs: nil,
            durationStartTime: nil,
            serverTime: nil,
            round: nil
        )
    }
    
    convenience init(
        from data: Gamestateschema.GetTimerQuery.Data.Timer,
        round: Round
    ) {
        let durationStartTime = convertWotcTimestamps(from: data.durationStartTime)
        let serverTime = convertWotcTimestamps(from: data.serverTime)

        self.init(
            id: data.id,
            state: TimerState(rawValue: data.state.rawValue) ?? .deleted,
            durationMs: data.durationMs,
            durationStartTime: durationStartTime,
            serverTime: serverTime,
            round: round
        )
    }
    
    
    static func createOrUpdate(
        from data: Gamestateschema.GetTimerQuery.Data.Timer,
        round: Round
    ) -> RoundTimer? {
        guard let timer = round.timer else {
            return nil
        }
        if timer.id == data.id {
            let durationStartTime = convertWotcTimestamps(from: data.durationStartTime)
            let serverTime = convertWotcTimestamps(from: data.serverTime)

            timer.state = TimerState(rawValue: data.state.rawValue) ?? .deleted
            timer.durationMs = data.durationMs
            timer.durationStartTime = durationStartTime
            timer.serverTime = serverTime
            return timer
        } else {
            return RoundTimer(from: data, round: round)
        }
        
    }
    
    
    func update() {
        if self.id != nil && self.id != "" {
            GQLNetwork.getTimer(timerId: self.id!) { result in
                switch result {
                case .success(let data):
                    let durationStartTime = convertWotcTimestamps(from: data.durationStartTime)
                    let serverTime = convertWotcTimestamps(from: data.serverTime)

                    self.state = TimerState(rawValue: data.state.rawValue) ?? .deleted
                    self.durationMs = data.durationMs
                    self.durationStartTime = durationStartTime
                    self.serverTime = serverTime
                case .failure(let error):
                    print("The error we got was: \(String(describing: error))")
                    
                }
            }
        } else { //fake timer
            let durationMs = 50 * 60 * 1000 // 50 minutes in milliseconds
            let durationStartTime = Date().addingTimeInterval(-5 * 60) // 5 minutes ago
            let serverTime = Date()
            let state: TimerState = .fake
            
            self.state = state
            self.durationMs = durationMs
            self.durationStartTime = durationStartTime
            self.serverTime = serverTime

        }
    }
    
}

enum TimerState: String, Codable {
    case running
    case halted
    case deleted
    case fake
    case uncreated
}

fileprivate func convertWotcTimestamps(from originTimestamp: String) -> Date {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    let convertedTimestamp = isoFormatter.date(from: originTimestamp) ?? Date()
    return convertedTimestamp
}
