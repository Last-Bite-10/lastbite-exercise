//
//  HomeView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 27/10/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    @Query private var preferences: [Preference]

    var body: some View {
        Group {
            if preferences.isEmpty {
                GetStartedView()
            } else {
                TabView(selection: $selectedTab) {
                    MyExerciseView()
                        .tabItem {
                            Label(
                                "My Exercise",
                                systemImage: "person.circle"
                            )
                        }

                    MyProgressView()
                        .tabItem {
                            Label(
                                "My Progress",
                                systemImage: "person.circle"
                            )
                        }
                }

            }
        }
    }
}

#Preview {
    ContentView()
}
