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
    @Environment(\.modelContext) private var modelContext
    @Query private var preferences: [Preference]
    @Binding var showQuestionnaire: Bool

    var body: some View {
        VStack(spacing: 10) {
            Text("Help us determined what exercise plan is perfect for you!")
                .font(Font.headline)

            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 210)
                .foregroundStyle(Color.accentColor)

            Text("Where do you prefer to do your exercise?")
                .font(.body)
                .padding(.bottom, 48)

            ForEach(LocationType.allCases, id: \.self) { type in
                QuestionnaireSelectionButton(
                    title: type.rawValue,
                    isSelected: viewModel.selectedLocation == type,
                    widthReduction: 160,
                    action: { viewModel.selectedLocation = type }
                )
            }

            Button(
                action: {
                    if let existingPreference = preferences.first {
                        modelContext.delete(existingPreference)
                    }

                    let preference = Preference(
                        isUsingPlan: true,
                        equipments: viewModel.selectedEquipment,
                        location: viewModel.selectedLocation,
                        frequency: viewModel.selectedFrequency
                    )
                    modelContext.insert(preference)
                    showQuestionnaire = false
                },
                label: { QuestionnaireNavButtonLabel(title: "Done") }
            ).padding(.top, 64)

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        showQuestionnaire = false
                    },
                    label: {
                        Text("Skip")
                            .foregroundColor(.red)
                    }
                ).buttonStyle(.borderless)
            }
        }
    }
}

#Preview {
    LocationView(showQuestionnaire: .constant(true))
        .environment(QuestionnaireViewModel())
}
