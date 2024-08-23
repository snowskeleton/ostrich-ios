//
//  RoundTimerView.swift
//  OSTRich
//
//  Created by snow on 8/21/24.
//


import SwiftUI
import SwiftData

struct RoundTimerView: View {
    @State var timer: RoundTimer
    @State private var visibleTime: String = "00:00"
    
    var color: Color {
        switch timer.state {
        case .running:
            return .green
        case .halted:
            return .yellow
        case .fake:
            return .blue
        default:
            return .red
        }
    }

    var body: some View {
        Text(visibleTime)
            .foregroundColor(color)
            .font(.headline)
            .onAppear {
                startTimer()
            }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timer.durationMs != nil && timer.durationStartTime != nil {
                let remainingTime = timer.durationMs! / 1000 - Int(Date().timeIntervalSince(timer.durationStartTime!))
                let isNegative = remainingTime < 0
                
                let minutes = abs(remainingTime) / 60
                let seconds = abs(remainingTime) % 60
                
                let formattedTime = String(format: "%@%d:%02d", isNegative ? "-" : "", minutes, seconds)
                visibleTime = formattedTime
            } else {
                visibleTime = "00:00"
            }
        }
    }
}
