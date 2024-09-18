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
            print("appears")
            viewModel.calculatePaywall()
            viewModel.startPaywallTimer()
        }
        .onDisappear {
            print("disappear (ouch, NO!)")
            viewModel.stopPaywallTimer()
        }
        .presentPaywallIfNeeded { customerInfo in
            viewModel.calculatePaywall()
            return viewModel.showPaywall
        } purchaseCompleted: { customerInfo in
            print("Purchase completed: \(customerInfo.entitlements)")
        } restoreCompleted: { customerInfo in
            // Paywall will be dismissed automatically if "pro" is now active.
            print("Purchases restored: \(customerInfo.entitlements)")
        }
    }
}
