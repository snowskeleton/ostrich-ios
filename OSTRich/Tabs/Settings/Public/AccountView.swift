//
//  AccountView.swift
//  OSTRich
//
//  Created by snow on 9/16/24.
//

import SwiftUI

struct AccountView: View {
    @Environment(\.presentationMode) var mode
    @State private var loggedIn = false
    @State private var showLogoutSuccessful = false
    
    @ObservedObject private var userManager = UserManager.shared

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
            
            if userManager.currentUser?.loggedIn == true {
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
                .alert(isPresented: $showLogoutSuccessful) {
                    Alert(
                        title: Text("Logout Successful!"),
                        message: Text("Please login to continue using this app")
                    )
                }
                
                Link(destination: URL(string: "https://magic-support.wizards.com/hc/en-us/requests/new?ticket_form_id=4413121329940")!) {
                    Text("Delete Account")
                }
            }
        }
        .onAppear {
            UserManager.shared.loadUser()
        }
        .navigationTitle("Account")
    }
    
    private func logout() {
        UserManager.shared.logout()
        showLogoutSuccessful = true
        mode.wrappedValue.dismiss()
    }
}

#Preview {
    AccountView()
}
