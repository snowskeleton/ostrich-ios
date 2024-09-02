//
//  PrivacyPolicyView.swift
//  OSTRich
//
//  Created by snow on 9/2/24.
//

import SwiftUI
import MarkdownUI

struct PrivacyPolicyView: View {
    var privacyPolicy: String
    
    init() {
        guard let url = Bundle.main.url(forResource: "PRIVACY_POLICY", withExtension: "md") else {
            self.privacyPolicy = "Privacy policy not available."
            return
        }
        
        do {
            self.privacyPolicy = try String(contentsOf: url, encoding: .utf8)
        } catch {
            self.privacyPolicy = "Error loading privacy policy."
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                Markdown(privacyPolicy)
                    .padding(10)
            }
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
