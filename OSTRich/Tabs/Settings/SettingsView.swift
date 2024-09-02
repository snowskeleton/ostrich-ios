//
//  SettingsView.swift
//  OSTRich
//
//  Created by snow on 5/1/24.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var loggedIn = false
    @AppStorage("showDeveloperMenu") var showDeveloperMenu = false

    init() {
        _loggedIn = .init(initialValue: UserManager.shared.currentUser?.loggedIn ?? false)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        LoginView()
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle")
                            Text("Login")
                        }
                    }
                    if loggedIn {
                        NavigationLink {
                            ChangeNameView()
                        } label: {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Change Name")
                            }
                        }
                        
                        Button(action: {
                            logout()
                        }) {
                            HStack {
                                Image(systemName: "arrow.left.circle")
                                Text("Logout")
                            }
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        AnalyticsView()
                    } label: {
                        HStack {
                            Image(systemName: "chart.bar")
                            Text("Analytics")
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        HStack {
                            Image(systemName: "list.clipboard")
                            Text("About")
                        }
                    }
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.shield")
                            Text("Privacy Policy")
                        }
                    }
                }
                
                Section {
                    Link(destination: URL(string: "https://github.com/snowskeleton/ostrich-ios")!) {
                        HStack {
                            HStack {
                                Image(colorScheme == .dark ? "github-mark-white" : "github-mark")
                                    .resizable()
                                    .frame(width: 24, height: 24) // Adjust the size to fit your design
                                
                                Text("View on GitHub")
                            }
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        DeveloperMenuView()
                    } label: {
                        HStack {
                            Image(systemName: "hammer")
                            Text("Developer Menu")
                        }
                    }
                }
                
            }
        }
        .onAppear {
            Analytics.track(.openedSettingsView)
        }
    }
    
    private func logout() {
        UserManager.shared.logout()
    }

}

#Preview {
    SettingsView()
}
