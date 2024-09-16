//
//  ChangeNameView.swift
//  OSTRich
//
//  Created by snow on 8/27/24.
//

import SwiftUI


struct ChangeNameView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName: String
    @State private var lastName: String
    
    @State private var showProgressView: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var alertTitle = "Failed to Change Name"
    @State private var alertMessage = "Default Error Message"
    
    init() {
        _firstName = State(initialValue: UserManager.shared.currentUser?.firstName ?? "")
        _lastName = State(initialValue: UserManager.shared.currentUser?.lastName ?? "")
    }
    
    var body: some View {
        List {
            Section("First Name") {
                TextField("First Name", text: $firstName)
            }
            Section("Last Name") {
                TextField("Last Name", text: $lastName)
            }
            Section {
                Button("Save") { changeName() }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(alertTitle),
                            message: Text(alertMessage)
                        )
                    }
            }
        }
        .overlay {
            if showProgressView {
                ProgressView()
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
                    .background(Color.gray)
                    .opacity(0.5)
            }
        }
    }
    
    fileprivate func changeName() {
        Task {
            showProgressView = true
            switch await HTOService().changeName(firstName: firstName, lastName: lastName) {
            case .success:
                await UserManager.shared.refreshProfile()
                dismiss()
            case .failure(let error):
                print(error)
                alertMessage = error.customMessage
                showAlert = true
            }
            showProgressView = false
        }
    }
}
