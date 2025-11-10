//
//  HomeView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 27/10/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Query private var preferences: [Preference]

    var body: some View {
        Group {
            if preferences.isEmpty {
                EmptyView()
            } else {
                TodayPlanView()
            }
        }
    }
}

#Preview {
    ContentView()
}
