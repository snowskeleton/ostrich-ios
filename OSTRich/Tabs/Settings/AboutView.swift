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

#Preview {
    AboutView()
}
