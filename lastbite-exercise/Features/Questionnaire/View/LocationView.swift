//
//  LocationView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftData
import SwiftUI

struct LocationView: View {
    @Environment(QuestionnaireViewModel.self) private var viewModel
    @Environment(\.dismissFlow) private var dismissFlow

    @Query private var preferences: [Preference]

    private var preference: Preference? { preferences.first }

    let onDone: () -> Void

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
                action: {
                    preference?.frequency = viewModel.selectedFrequency
                    preference?.equipmentAvailable =
                        Array(viewModel.selectedEquipment)
                    preference?.location = viewModel.selectedLocation

                    onDone()
                },
                label: { CoreButtonLabel(title: "Done") }
            )
            .padding(.horizontal, 48)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        dismissFlow()
                    },
                    label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                    }
                )
                .buttonStyle(.borderless)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LocationView(onDone: {})
            .environment(QuestionnaireViewModel())
    }
}
