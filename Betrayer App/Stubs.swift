//
//  Stubs.swift
//  Betrayer App
//
//  Created by snow on 9/19/23.
//

import SwiftUI

struct EventBoxView: View {
    @Binding var event: Event
    var body: some View {
        VStack {
                Text("\(event.title!) | \(event.shortCode!)")
                Text(event.eventFormat!.name)
        }
    }
}

