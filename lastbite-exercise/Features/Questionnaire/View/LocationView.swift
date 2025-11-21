//
//  LocationView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftData
import SwiftUI

struct LocationView: View {
    @Environment(QuestionnaireViewModel.self) private var questionnaireVM
    @Environment(HomeViewModel.self) private var homeVM
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
                    isSelected: questionnaireVM.selectedLocation == type,
                    action: { questionnaireVM.selectedLocation = type }
                )
            }
            .padding(.horizontal, 64)

            Spacer()

            ButtonWSound(
                action: {
                    if let preference = preference {
                        preference.frequency = questionnaireVM.selectedFrequency
                        preference.equipmentAvailable =
                            Array(questionnaireVM.selectedEquipment)
                        preference.location = questionnaireVM.selectedLocation

                        homeVM.onDoneAction()
                    }
                },
                label: { CoreButtonLabel(title: "Done") }
            )
            .padding(.horizontal, 48)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        if let preference = preference {
                            homeVM.onCancelAction(preference: preference)
                        }
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
        LocationView()
            .environment(QuestionnaireViewModel())
            .environment(HomeViewModel())
    }
}
