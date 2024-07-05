//
//  SettingsView.swift
//  OSTRich
//
//  Created by snow on 5/1/24.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    @AppStorage("saveLoginCreds") var saveLoginCreds = false
    
    var body: some View {
        List {
            Toggle(isOn: $saveLoginCreds) {
                Text("Save email and password to login")
            }
            Button("Crash!") {
                fatalError()
            }
        }
    }
}
