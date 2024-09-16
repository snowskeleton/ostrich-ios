//
//  AccountView.swift
//  OSTRich
//
//  Created by snow on 9/16/24.
//

import SwiftUI

struct AccountView: View {
    @State private var loggedIn = false
    
    init() {
        _loggedIn = .init(initialValue: UserManager.shared.currentUser?.loggedIn ?? false)
    }

    var body: some View {
        List {
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
                
                HStack {
                    Image(systemName: "arrow.left.circle")
                Button(action: {
                    logout()
                }) {
                        Text("Logout")
                    }
                }
                
                Link(destination: URL(string: "https://magic-support.wizards.com/hc/en-us/requests/new?ticket_form_id=4413121329940")!) {
                    Text("Delete Account")
                }
            }
        }
    }
    
    private func logout() {
        UserManager.shared.logout()
    }
}

#Preview {
    AccountView()
}
