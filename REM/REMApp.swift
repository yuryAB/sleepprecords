//
//  REMApp.swift
//  REM
//
//  Created by yury antony on 23/05/25.
//

import SwiftUI
import SwiftData

@main
struct REMApp: App {
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

    var body: some Scene {
        WindowGroup {
            FeedView()
            //OnboardingView()
        }
        .modelContainer(sharedModelContainer)
    }
}
