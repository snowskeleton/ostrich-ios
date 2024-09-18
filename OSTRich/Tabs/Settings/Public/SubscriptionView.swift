//
//  SubscriptionView.swift
//  OSTRich
//
//  Created by snow on 9/18/24.
//

import Foundation
import SwiftUI
import RevenueCat
import RevenueCatUI

struct SubscriptionView: View {
    @StateObject private var viewModel = PaywallViewModel()
    
    @State private var showSubscriptionSheet = false
    
    var body: some View {
        VStack {
            if viewModel.hasProAccess {
                Text("Thank you for your support!")
            }

            Form {
                Section {
                    if viewModel.showFreeTimeLeft {
                        HStack {
                            Text("Trial time left: ")
                            Spacer()
                            Text("\(viewModel.freeTimeLeft) day\(viewModel.freeTimeLeft > 1 ? "s" : "")")
                        }
                    }
                    
                    Button("Manage subscription") {
                        showSubscriptionSheet = true
                    }
                    .disabled(ProcessInfo.processInfo.isiOSAppOnMac )
                    .manageSubscriptionsSheet(isPresented: $showSubscriptionSheet)
                }
                
                if viewModel.showPaywall {
                    Text("Subscribe to access premium features")
                        .font(.headline)
                        .padding()
                    
                    PaywallButtonView()
                    
                } else if viewModel.hasProAccess {
                    Text("You have Pro access!")
                        .font(.headline)
                        .padding()
                } else {
                    Text("Scouting results are available.")
                        .font(.headline)
                        .padding()
                }
            }
        }
        .onAppear {
            viewModel.startPaywallTimer()
        }
        .onDisappear {
            viewModel.stopPaywallTimer()
        }
        .sheet(isPresented: $viewModel.showPaywall) {
            PaywallView(displayCloseButton: true)
        }
    }
}
