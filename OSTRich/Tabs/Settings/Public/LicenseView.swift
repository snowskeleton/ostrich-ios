//
//  LicenseView.swift
//  OSTRich
//
//  Created by snow on 9/2/24.
//

import SwiftUI

struct LicenseView: View {
    var body: some View {
        List {
            Section("Apache 2.0") {
                NavigationLink {
                    MarkdownView(markdownFile: "LICENSE")
                } label: {
                    Text("OSTRich")
                }

            }
            
            Section("MIT") {
                Link(destination: URL(string: "https://github.com/apollographql/apollo-ios/blob/main/LICENSE")!) {
                    Text("Apollo iOS")
                }
                Link(destination: URL(string: "https://github.com/RevenueCat/purchases-ios/blob/main/LICENSE")!) {
                    Text("RevenueCat")
                }
                Link(destination: URL(string: "https://github.com/gonzalezreal/swift-markdown-ui/blob/main/LICENSE")!) {
                    Text("MarkdownUI")
                }
            }
            
            Section("AGPL") {
                Link(destination: URL(string: "https://github.com/aptabase/aptabase/blob/main/LICENSE")!) {
                    Text("Aptabase")
                }
            }
            
            Section("Public Domain") {
                Link(destination: URL(string: "https://www3.sqlite.org/copyright.html")!) {
                    Text("SQLite")
                }
                
            }
        }
    }
}

#Preview {
    LicenseView()
}
