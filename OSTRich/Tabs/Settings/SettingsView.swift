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
                        MarkdownView(markdownFile: "PRIVACY_POLICY.md")
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.shield")
                            Text("Privacy Policy")
                        }
                    }
                }
                
                Section {
                    Link(destination: supportEmailURL()) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Support")
                        }
                    }
                    
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
                    
                    NavigationLink {
                        LicenseView()
                    } label: {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Licenses & Libraries")
                        }
                    }
                }
                
                if Config.appConfiguration != .AppStore {
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
        }
        .onAppear {
            Analytics.track(.openedSettingsView)
        }
    }
    
    private func logout() {
        UserManager.shared.logout()
    }
    
    func supportEmailURL() -> URL {
        let recipient = "ostrich_support@snowskeleton.net"
        let subject = "OSTRich Support Request"
        let body = """
        Describe the problem you're having:
        
        
        Describe when it happens:
        
        
        Anything else you think is relevant:
        
        
        
        —————————————————————————————————————————————————————
        Please don't edit anything below this line
        
        - App Version: \(Bundle.main.appVersionLong)
        - Build Number: \(Bundle.main.appBuild)
        """
        
        // URL encode the subject and body
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "mailto:\(recipient)?subject=\(encodedSubject)&body=\(encodedBody)"
        return URL(string: urlString)!
    }


}

#Preview {
    SettingsView()
}
