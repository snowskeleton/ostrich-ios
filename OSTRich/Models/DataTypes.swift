//
//  DataTypes.swift
//  OSTRich
//
//  Created by snow on 9/29/23.
//

import Foundation
import SwiftData

//private func safeNameExpander(
//    _ firstName: String?, _ lastName: String?, _ displayName: String?
//) -> String {
//    if firstName == nil
//        && lastName == nil
//        && displayName == nil
//    {
//        return "Unknown player"
//    } else if firstName == nil
//        && lastName == nil
//        && displayName != nil
//    {
//        return displayName!
//    } else if firstName != nil
//        && lastName == nil
//    {
//        return firstName!
//    } else if firstName == nil
//        && lastName != nil
//    {
//        return lastName!
//    } else {
//        return "\(firstName!) \(lastName!)"
//    }
//}
//


class EventV1: Codable, Identifiable {
}

//struct EventFormat: Codable {
//}

struct GameState: Codable {
}


//struct User: Codable {
//}

struct TeamResult: Codable {
}

struct TeamStanding: Codable {
}

struct WotcTimer: Codable {
}
