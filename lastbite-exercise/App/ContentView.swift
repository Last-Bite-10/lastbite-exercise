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
<<<<<<< HEAD
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text(
                            "Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))"
                        )
                    } label: {
                        Text(
                            item.timestamp,
                            format: Date.FormatStyle(
                                date: .numeric,
                                time: .standard
                            )
                        )
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
=======
        TabView(selection: $selectedTab) {
            MyExercise()
            .tabItem {
                Label("My Exercise", systemImage: "person.circle")
>>>>>>> SMS-62-Navigasi-Aplikasi
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
