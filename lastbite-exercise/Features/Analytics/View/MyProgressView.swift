//
//  Analytics.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct MyProgressView: View {
    @State private var currentWeeklyMinutes = 15
    @State private var totalWeeklyMinutes = 30
    @State private var trophies = [
        Trophy(milestone: 3, isAchieved: true),
        Trophy(milestone: 5, isAchieved: true),
        Trophy(milestone: 10, isAchieved: false),
        Trophy(milestone: 15, isAchieved: false),
        Trophy(milestone: 20, isAchieved: false),
        Trophy(milestone: 25, isAchieved: false),
    ]
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color("BlueTwo"))
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color("BlueTwo"))
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Weekly Progress Section
                    WeeklyProgressView(
                        currentMinutes: currentWeeklyMinutes,
                        totalMinutes: totalWeeklyMinutes
                    )
                    
                    // Trophies Section
                    TrophiesView(trophies: trophies)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle(Text("My Progress"))
        }
    }
}

#Preview {
    MyProgressView()
}
