//
//  Analytics.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct MyProgressView: View {
    @State private var currentWeeklyMinutes = 30
    @State private var totalWeeklyMinutes = 60
    
    @State private var trophies = [
        Trophy(milestone: 3, isAchieved: false),
        Trophy(milestone: 5, isAchieved: false),
        Trophy(milestone: 7, isAchieved: false),
        Trophy(milestone: 10, isAchieved: false),
        Trophy(milestone: 15, isAchieved: false),
        Trophy(milestone: 25, isAchieved: false),
        Trophy(milestone: 50, isAchieved: false),
    ]
    
    init() {
        
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Weekly Progress Section
                    WeeklyProgressView(
                        currentMinutes: currentWeeklyMinutes,
                        totalMinutes: totalWeeklyMinutes
                    )
                    
                    // Trophies Section
                    TrophiesView(trophies: $trophies)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle(Text("My Progress"))
            .toolbarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    MyProgressView()
}
