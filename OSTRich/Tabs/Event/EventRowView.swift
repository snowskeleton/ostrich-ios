//
//  EventRowView.swift
//  OSTRich
//
//  Created by snow on 9/3/24.
//


import SwiftUI
import Foundation
import SwiftData
import Observation

struct EventRowView: View {
    var event: Event
    
    var statusColor: Color {
        if let status = event.status {
            switch status {
            case "ROUNDACTIVE":
                return .blue
            case "ENDED":
                return .red
            default:
                return .yellow
            }
        }
        return .yellow
    }
    
    var body: some View {
        HStack {
            VStack {
                if let scheduledStartTime = event.scheduledStartTime {
                    Text(convertToLocalTime(scheduledStartTime))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text(convertToLocalDate(scheduledStartTime))
                        .font(.caption2)
                        .foregroundColor(.primary.opacity(0.8))
                    
                } else {
                    Text("None")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            .padding(14)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color.secondary,
                    Color.primary
                ]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing
                )
                .opacity(0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 30))
//            .clipShape(Circle())
            .shadow(
                color: Color.black.opacity(0.6),
                radius: 10, x: 0, y: 5
            )
            
            VStack(alignment: .leading) {
                Text(event.title)
                    .foregroundColor(.primary)
                    .font(.title2)
                    .fontWeight(.bold)

//                if let status = event.status {
//                    Text(status)
//                        .font(.subheadline)
//                        .fontWeight(.semibold)
//                        .padding(4)
//                        .foregroundColor(statusColor)
//                }
            }
        }
    }
    
    func convertToLocalDate(_ utcTime: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        
        // Attempt to parse with fractional seconds
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        var date = dateFormatter.date(from: utcTime)
        
        // If parsing fails, try without fractional seconds
        if date == nil {
            dateFormatter.formatOptions = [.withInternetDateTime]
            date = dateFormatter.date(from: utcTime)
        }
        
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            
            // Get current year
            let currentYear = Calendar.current.component(.year, from: Date())
            
            // Get year from the parsed date
            let dateYear = Calendar.current.component(.year, from: date)
            
            // Custom format: Include the year only if it's different from the current year
            if dateYear == currentYear {
                formatter.dateFormat = "MM/dd"
            } else {
                formatter.dateFormat = "MM/dd/yyyy"
            }
            
            return formatter.string(from: date)
        }
        
        return "Invalid"
    }
    
    func convertToLocalTime(_ utcTime: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        
        // Attempt to parse with fractional seconds
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        var date = dateFormatter.date(from: utcTime)
        
        // If parsing fails, try without fractional seconds
        if date == nil {
            dateFormatter.formatOptions = [.withInternetDateTime]
            date = dateFormatter.date(from: utcTime)
        }
        
        if let date = date {
            let localFormatter = DateFormatter()
            localFormatter.timeStyle = .short
            localFormatter.timeZone = .current
            
            return localFormatter.string(from: date)
        }
        
        return "Invalid date"
    }
}
