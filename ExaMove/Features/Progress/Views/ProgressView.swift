//
//  MyProgressView.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

//
//  Analytics.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct ProgressView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Weekly Progress Section
                    WeeklyProgressComponent()

                    // Trophies Section
                    TrophiesComponent()

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
    ProgressView()
}
