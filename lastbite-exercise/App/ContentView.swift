//
//  ContentView.swift
//  Exa
//
//  Created by Niken Larasati on 20/10/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MyExercise()
            .tabItem {
                Label("My Exercise", systemImage: "person.circle")
            }
            
            MyProgress()
            .tabItem {
                Label("My Progress", systemImage: "person.circle")
            }
        }
    }
}

#Preview {
    ContentView()
}
