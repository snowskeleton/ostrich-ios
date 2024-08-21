//
//  CreateScoutingReport.swift
//  OSTRich
//
//  Created by snow on 8/21/24.
//

import SwiftUI

struct CreateScoutingResultView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var deckName: String = ""
    @State private var deckNotes: String = ""
    
    @State var playerName: String = ""
    @State var playerPersonaId: String = ""
    @State var eventName: String = ""
    @State var eventId: String = ""
    
    var body: some View {
            Form {
                Section(header: Text("Deck Information")) {
                    // have some preselections at some point
                    TextField("Deck Name", text: $deckName)
                    TextField("Deck Notes", text: $deckNotes)
                }
                
                Section(header: Text("Event Information")) {
                    TextField("Event Name", text: $eventName)
                }
                
                Button(action: createScoutingResult) {
                    Text("Save Scouting Result")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(deckName.isEmpty)
            }
            .navigationTitle("New Scouting Result")
        }
    
    private func createScoutingResult() {
        let result = ScoutingResult(
            deckName: deckName,
            deckNotes: deckNotes.isEmpty ? nil : deckNotes,
            eventName: eventName.isEmpty ? nil : eventName,
            eventId: eventId.isEmpty ? nil : eventId,
            playerName: playerName.isEmpty ? nil : playerName,
            playerPersonaId: playerPersonaId.isEmpty ? nil : playerPersonaId
        )
        modelContext.insert(result)
    }
}
