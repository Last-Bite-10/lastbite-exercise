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
<<<<<<< HEAD
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self
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

=======
>>>>>>> SMS-62-Navigasi-Aplikasi
    var body: some Scene {
        WindowGroup {
            FrequencyView()
        }
    }
}
