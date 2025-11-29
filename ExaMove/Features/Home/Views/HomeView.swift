//
//  HomeView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 21/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showTutorial: Bool = true

    var body: some View {
        ZStack {
            ExerciseView()
            TutorialOverlay(isVisible: $showTutorial)
        }
    }
}

#Preview {
    HomeView()
}
