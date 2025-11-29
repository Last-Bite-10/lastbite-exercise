//
//  HomeView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 21/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showTutorialOverlay: Bool = false

    var body: some View {
        ZStack {
            ExerciseView(showTutorialOverlay: $showTutorialOverlay)
            TutorialOverlay(isVisible: $showTutorialOverlay)
        }
    }
}

#Preview {
    HomeView()
}
