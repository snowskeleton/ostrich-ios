//
//  PaywallButtonView.swift
//  OSTRich
//
//  Created by snow on 9/12/24.
//


import SwiftUI
import SwiftData
import RevenueCat
import RevenueCatUI

struct PaywallButtonView: View {
    @State private var showSheet: Bool = false
    
    var body: some View {
        VStack {
            Text("Scouting results are only available to Pro users.")
                .multilineTextAlignment(.center)
            
            Button {
                showSheet = true
            } label: {
                Text("Subscribe to Pro")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showSheet) {
                PaywallView(displayCloseButton: true)
            }
        }
    }
}
