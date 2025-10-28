//
//  HomeView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 27/10/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    @State private var showQuestionnaire = true

    var body: some View {
        if showQuestionnaire {
            FrequencyView(showQuestionnaire: $showQuestionnaire)
        } else {
            TabView(selection: $selectedTab) {
                MyExerciseView()
                    .tabItem {
                        Label("My Exercise", systemImage: "person.circle")
                    }

                MyProgressView()
                    .tabItem {
                        Label("My Progress", systemImage: "person.circle")
                    }
            }
        }
    }
}

#Preview {
    HomeView()
}
