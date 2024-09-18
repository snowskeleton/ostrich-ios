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
                    
                    Button {
                        showSubscriptionSheet = true
                    } label: {
                        Text("Manage Subscription")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .disabled(ProcessInfo.processInfo.isiOSAppOnMac )
                    .manageSubscriptionsSheet(isPresented: $showSubscriptionSheet)
                }
                
                Section("Features") {
                    Text("Track players across events and view deck history. Record scouted results and see most recently played decks in Event History.")
                }
                
                if viewModel.showFreeTimeLeft {
                    
                    Section {
                        PaywallButtonView()
                    }
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
