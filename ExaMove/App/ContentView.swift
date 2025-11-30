//
//  ContentView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 27/10/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @Query private var preferences: [Preference]

    private let haptic = HapticService.shared

    var body: some View {
        Group {
            if preferences.isEmpty {
                GetStartedView()
            } else {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(0)
                        .tabItem {
                            Label("My Exercise", systemImage: "figure.yoga")
                        }

                    ProgressView()
                        .tag(1)
                        .tabItem {
                            Label("My Progress", systemImage: "graph.2d")
                        }
                }
                .sensoryFeedback(.impact(weight: .light), trigger: selectedTab)
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
