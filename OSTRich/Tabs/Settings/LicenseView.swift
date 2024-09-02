//
//  LicenseView.swift
//  OSTRich
//
//  Created by snow on 9/2/24.
//

import SwiftUI

struct LicenseView: View {
    var body: some View {
        ScrollView {
            List {
                Section("MIT License") {
                    Text("Apollo iOS")
                }
                Text("SQLite")
                Text("Aptabase")
                Text("RevenueCat")
                Text("swift-markdown-ui")
                Text("NetworkImage")
            }
        }
    }
}

#Preview {
    LicenseView()
}
