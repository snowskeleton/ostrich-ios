//
//  convenience functions.swift
//  OSTRich
//
//  Created by snow on 7/17/24.
//

func safeNameExpander(
    _ firstName: String?, _ lastName: String?, _ displayName: String?
) -> String {
    if firstName == nil
        && lastName == nil
        && displayName == nil
    {
        return "Unknown player"
    } else if firstName == nil
                && lastName == nil
                && displayName != nil
    {
        return displayName!
    } else if firstName != nil
                && lastName == nil
    {
        return firstName!
    } else if firstName == nil
                && lastName != nil
    {
        return lastName!
    } else {
        return "\(firstName!) \(lastName!)"
    }
}
