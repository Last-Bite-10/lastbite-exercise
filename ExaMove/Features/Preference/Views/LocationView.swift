//
//  LocationView.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftData
import SwiftUI

struct LocationView: View {
    @Environment(PreferenceViewModel.self) private var viewModel
    @Query private var preferences: [Preference]

    var preference: Preference? { preferences.first }

    var body: some View {
        VStack(spacing: 10) {
            Text("3/3")
                .font(.headline)

            Text("Help us determined what exercise plan is perfect for you!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)

            Image("LocationQuestion")
                .resizable()
                .scaledToFit()

            Text("Where do you prefer to do your exercise?")
                .font(.body)

            Spacer()

            ForEach(LocationType.allCases, id: \.self) { type in
                QuestionnaireSelectionButton(
                    title: type.rawValue,
                    isSelected: viewModel.selectedLocation == type,
                    action: { viewModel.selectedLocation = type }
                )
            }
            .padding(.horizontal, 64)

            Spacer()

            ButtonWSound(
                action: viewModel.savePreference,
                label: { CoreButtonLabel(title: "Done") }
            )
            .padding(.horizontal, 48)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cancel", systemImage: "xmark") {
                    viewModel.onCancelAction?()
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LocationView()
            .environment(PreferenceViewModel())
    }
}
