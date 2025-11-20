//
//  ExaWatchApp.swift
//  ExaWatch Watch App
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//

import SwiftData
import SwiftUI

@main
struct ExaWatchApp: App {
    @StateObject private var healthManager = WatchHealthManager()
    

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Preference.self,
            Weekly.self,
            ExerciseRecord.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
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
            ContentView().modelContainer(sharedModelContainer)
        }
    }
}
