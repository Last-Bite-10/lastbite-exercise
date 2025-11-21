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

    private let haptic = HapticManager.shared

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

                    MyProgressView()
                        .tag(1)
                        .tabItem {
                            Label("My Progress", systemImage: "graph.2d")
                        }
                }
                .sensoryFeedback(.impact(weight: .light), trigger: selectedTab)
            }
        }
    }
}

#Preview {
    ContentView()
}
