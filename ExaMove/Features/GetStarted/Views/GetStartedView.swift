//
//  GetStartedView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 04/11/25.
//

import SwiftData
import SwiftUI

struct GetStartedView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var preferences: [Preference]

    private let soundPlayer = SoundService.shared

    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var buttonOffset: CGFloat = 50
    @State private var buttonOpacity: Double = 0

    var body: some View {
        VStack(alignment: .center) {
            Spacer()

            Image("AppIconDisplay")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

            Text(
                "Welcome to ExaMove, where your small \n moves make a big impact."
            )
            .font(.headline)
            .multilineTextAlignment(.center)
            .opacity(textOpacity)

            Spacer()

            ButtonWSound(
                action: {
                    if preferences.isEmpty {
                        let preference = Preference()
                        modelContext.insert(preference)
                    }
                },
                label: { CoreButtonLabel(title: "Get Started") }
            )
            .padding(.horizontal, 48)
            .offset(y: buttonOffset)
            .opacity(buttonOpacity)

            Spacer()
        }
        .onAppear {
            startSplashAnimation()
        }
    }

    private func startSplashAnimation() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }

        withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
            textOpacity = 1.0
        }

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.6)) {
            buttonOffset = 0
            buttonOpacity = 1.0
        }
    }
}

#Preview {
    GetStartedView()
}
