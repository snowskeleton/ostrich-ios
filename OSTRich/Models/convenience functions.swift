//
//  convenience functions.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//
import SwiftUI

func safeNameExpander(
    _ firstName: String?, _ lastName: String?, _ displayName: String?, _ teamId: String? = nil, _ playerId: String? = nil
) -> String {
    var nameString = ""
    if firstName == nil
        && lastName == nil
        && displayName == nil
    {
        nameString = "Unknown player"
    } else if firstName == nil
                && lastName == nil
                && displayName != nil
    {
        nameString = displayName!
    } else if firstName != nil
                && lastName == nil
    {
        nameString = firstName!
    } else if firstName == nil
                && lastName != nil
    {
        return lastName!
    } else {
        nameString = "\(firstName!) \(lastName!))"
    }
    if UserDefaults.standard.bool(forKey: "showDebugValues") {
        nameString += " | t: \(teamId ?? "no ID"), p: \(playerId ?? "no ID")"
    }
    return nameString
}
