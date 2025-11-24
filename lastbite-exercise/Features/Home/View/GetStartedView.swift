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

    private let soundPlayer = SoundPlayer.shared

    var body: some View {
        VStack(
            alignment: .center
        ) {
            HStack {
                Image("icon_display")

                Text(
                    "Welcome to ExaMove, where your small moves make a big impact."
                )
                .font(.headline)
                .multilineTextAlignment(.center)
            }

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
        }
    }
}

#Preview {
    GetStartedView()
}
