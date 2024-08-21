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
    @State private var visibleTime: String = "substitute"
    
    var body: some View {
        Text(visibleTime)
            .foregroundColor(timer.color)
            .font(.headline)
            .onAppear {
                startTimer()
            }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timer.durationMs != nil && timer.durationStartTime != nil {
                let remainingTime = timer.durationMs! / 1000 - Int(Date().timeIntervalSince(timer.durationStartTime!))
                let minutes = remainingTime / 60
                let seconds = remainingTime % 60
                let formattedTime = String(format: "%02d:%02d", minutes, seconds)
                visibleTime = formattedTime
            } else {
                visibleTime = "00:00"
            }
        }
    }
}
