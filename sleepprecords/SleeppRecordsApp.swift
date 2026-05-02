//
//  SleeppRecordsApp.swift
//  sleepprecords
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI
import SwiftData

@main
struct SleeppRecordsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Record.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @AppStorage("hasSeenCreatorNote") private var hasSeenCreatorNote = false

    var body: some Scene {
        WindowGroup {
            if hasSeenCreatorNote {
                FeedView()
            } else {
                CreatorNoteView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
