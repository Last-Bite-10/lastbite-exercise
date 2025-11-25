//
//  HomeView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 21/11/25.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    

    var body: some View {
        ZStack {
            MyExerciseView().environment(viewModel)
            TutorialOverlay(isVisible: $viewModel.showTutorial)
        }
    }
}
