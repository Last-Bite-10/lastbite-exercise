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

    var body: some View {
        VStack(
            alignment: .center
        ) {
            Image("icon_display")
            Text("Welcome to AppName, where blabla balabal kbgczbka ablablab!")
                .font(.headline)
                .multilineTextAlignment(.center)
            Button(
                action: {
                    if preferences.isEmpty {
                        let preference = Preference()
                        modelContext.insert(preference)
                    }
                },
                label: { CoreButtonLabel(title: "Get Started") }
            )
        }
    }
}

#Preview {
    GetStartedView()
}
