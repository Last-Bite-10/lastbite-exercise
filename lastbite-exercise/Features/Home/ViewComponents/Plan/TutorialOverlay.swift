//
//  TutorialOverlay.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 21/11/25.
//

import SwiftUI

struct TutorialOverlay: View {
    @Binding var isVisible: Bool

    var body: some View {
        if isVisible {
            ZStack {
                // Dimmed background
                Color.black.opacity(0.45)
                    .ignoresSafeArea()

                ZStack {
                    Image("TutorialCloud")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                        .padding(.top, 15)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Your weekly plan is ready!")
                                .font(.headline)

                            Text("Start your workout or modify your plan.")
                                .font(.subheadline)
                        }
                        .padding(.bottom)

                        Button("Understood", systemImage: "checkmark") {
                            isVisible.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.button)
                        .labelStyle(.iconOnly)
                        .controlSize(.large)
                        .clipShape(Circle())
                    }
                }
                .padding(.bottom, 150)
            }
            .transition(.opacity)
            .animation(.easeInOut, value: isVisible)
        }
    }
}

#Preview {
    ZStack {
        MyExerciseView()
        TutorialOverlay(isVisible: .constant(true))
    }
}
