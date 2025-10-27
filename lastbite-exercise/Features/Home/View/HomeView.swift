//
//  HomeView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 27/10/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var selectedTab = 0

    var body: some View {
        if viewModel.firstLaunch || viewModel.currentView == .questionnaire {
            FrequencyView()
                .environment(viewModel)
        } else if viewModel.currentView == .home {
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
