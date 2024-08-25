//
//  CreateScoutingReport.swift
//  OSTRich
//
//  Created by snow on 8/21/24.
//

import SwiftUI
import SwiftData

struct CreateScoutingResultView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var deckName: String
    @State private var deckNotes: String
    
    @State private var eventName: String
    @State private var eventId: String
    @State private var formatName: String
    @State private var freeEntryFormatName: String = ""

    @State private var scoutingResult: ScoutingResult?
    @State private var player: LocalPlayer
    @State private var date: Date = .now
    
    init(
        playingPlayer: Player,
        event: Event,
        deckName: String = "",
        deckNotes: String = ""
    ) {
        let newPlayer = LocalPlayer.createOrUpdate(from: playingPlayer)
        
        self.init(
            player: newPlayer,
            event: event,
            deckName: deckName,
            deckNotes: deckNotes
        )
    }
    
    init(
        registeredPlayer: Registration,
        event: Event,
        deckName: String = "",
        deckNotes: String = ""
    ) {
        let newPlayer = LocalPlayer.createOrUpdate(from: registeredPlayer)
        
        self.init(
            player: newPlayer,
            event: event,
            deckName: deckName,
            deckNotes: deckNotes
        )
    }
    
//    init(
//        playerFirstName: String,
//        playerLastName: String,
//        playerDisplayName: String,
//        playerPersonaId: String,
//        
//        event: Event,
//        deckName: String = "",
//        deckNotes: String = ""
//    ) {
//        let newPlayer = LocalPlayer.createOrUpdate(
//            personaId: playerPersonaId,
//            displayName: playerDisplayName,
//            firstName: playerFirstName,
//            lastName: playerLastName
//        )
//        
//        self.init(
//            player: newPlayer,
//            event: event,
//            deckName: deckName,
//            deckNotes: deckNotes
//        )
//    }

    init(
        player: LocalPlayer,
        eventName: String,
        eventId: String,
        formatName: String?,
        deckName: String = "",
        deckNotes: String = ""
    ) {
        _player = .init(initialValue: player)
        _eventName = .init(initialValue: eventName)
        _eventId = .init(initialValue: eventId)
        _formatName = .init(initialValue: formatName != nil ? formatName! : "Please select")
        _deckName = .init(initialValue: deckName)
        _deckNotes = .init(initialValue: deckNotes)
        _player = .init(initialValue: player)
    }
    
    init(
        player: LocalPlayer,
        event: Event,
        deckName: String = "",
        deckNotes: String = ""
    ) {
        self.init(
            player: player,
            eventName: event.title,
            eventId: event.id,
            formatName: event.eventFormat?.name ?? "Other",
            deckName: deckName,
            deckNotes: deckNotes
        )

    }
    
    init(scoutingResult: ScoutingResult) {
        self.init(
            player: scoutingResult.player!,
            eventName: scoutingResult.eventName ?? "",
            eventId: scoutingResult.eventId ?? "",
            formatName: scoutingResult.format,
            deckName: scoutingResult.deckName,
            deckNotes: scoutingResult.deckNotes ?? ""
        )
        _scoutingResult = .init(initialValue: scoutingResult)
    }
    
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
                
                Section(header: Text("Format")) {
                    Picker("Select a Format", selection: $formatName) {
                        ForEach(formatNames, id: \.self) {
                            Text($0).tag($0)
                        }
                    }
                    if formatName == "Other" {
                        TextField("Custom Format Name", text: $freeEntryFormatName)
                    }
                }
                
                Section {
                    DatePicker("Event Date", selection: $date, displayedComponents: .date)
                }
                
                Button(action: createScoutingResult) {
                    Text("Save Scouting Result")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(deckName.isEmpty || formatName == "Please select")
                
                if scoutingResult != nil {
                    Button(action: deleteScoutingResult) {
                        Text("Delete entry")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("New Scouting Result")
        }
    
    private func createScoutingResult() {
        if let result = scoutingResult {
            result.deckName = deckName
            result.deckNotes = deckNotes
            result.eventName = eventName
            result.eventId = eventId
            result.player = player
            result.format = formatName == "Other" ? freeEntryFormatName : formatName
            result.date = date
        } else {
            let result = ScoutingResult(
                deckName: deckName,
                deckNotes: deckNotes,
                eventName: eventName,
                eventId: eventId,
                format: formatName == "Other" ? freeEntryFormatName : formatName,
                player: player,
                date: date
            )
            context.insert(result)
        }
        dismiss()
    }
    
    private func deleteScoutingResult() {
        if scoutingResult != nil {
            context.delete(scoutingResult!)
            dismiss()
        }
    }
}

// sorted with top 7 formats at the top, and the rest in alphabetical order
let formatNames = [
    "Please select",
    "Standard",
    "Pioneer",
    "Modern",
    "Legacy",
    "Vintage",
    "Pauper",
    "Commander/EDH",
    
    "Alchemy",
    "Arena Singleton",
    "Artisan Historic",
    "Block",
    "Brawl",
    "Canadian Highlander",
    "Cascade",
    "Commander 1v1",
    "Duel Commander",
    "Explorer",
    "Free Form",
    "Frontier",
    "Gladiator",
    "Historic",
    "Limited",
    "No Banned List Modern",
    "Oathbreaker",
    "Old School",
    "Penny Dreadful",
    "Premodern",
    "Timeless",
    "Tiny Leaders",
    "Other"
]

