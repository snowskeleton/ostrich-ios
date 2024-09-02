//
//  AboutView.swift
//  OSTRich
//
//  Created by snow on 9/2/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text(Bundle.main.appName)
                        .font(.largeTitle)
                        .bold()
                    Text("Version: \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))")
                    Text("By Isaac Lyons")
                    Text(Bundle.main.copyright)
                }
            }
        }
    }
}

extension Bundle {
    fileprivate var appName: String           { getInfo("CFBundleName") }
    fileprivate var appBuild: String          { getInfo("CFBundleVersion") }
    fileprivate var appVersionLong: String    { getInfo("CFBundleShortVersionString") }
    fileprivate var copyright: String         { getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    
    //    fileprivate var displayName: String       { getInfo("CFBundleDisplayName") }
    //    fileprivate var language: String          { getInfo("CFBundleDevelopmentRegion") }
    //    fileprivate var identifier: String        { getInfo("CFBundleIdentifier") }
    //public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

#Preview {
    AboutView()
}
