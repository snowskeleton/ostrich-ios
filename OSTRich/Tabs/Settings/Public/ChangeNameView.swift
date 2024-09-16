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
            Button("Save") { changeName() }
        }
    }
    fileprivate func changeName() {
        Task {
            switch await HTOService().changeName(firstName: firstName, lastName: lastName) {
            case .success:
                await UserManager.shared.refreshProfile()
                dismiss()
            case .failure(let error):
                print(error)
            }
        }
    }
}
