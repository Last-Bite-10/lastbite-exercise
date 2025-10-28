//
//  lastbite_exerciseApp.swift
//  Exa
//
//  Created by Niken Larasati on 20/10/25.
//

import SwiftData
import SwiftUI

@main
struct LastbiteExerciseApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Preference.self,
            Weekly.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
