//
//  FrequencyView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftData
import SwiftUI

struct FrequencyView: View {
    @Environment(QuestionnaireViewModel.self) private var questionnaireVM
    @Environment(HomeViewModel.self) private var homeVM
    @Query private var preferences: [Preference]

    var preference: Preference? { preferences.first }

    var body: some View {
        VStack(spacing: 10) {
            Text("1/3")
                .font(.headline)
            Text("Choose your preferred frequency")
                .font(.headline)

            Image("FrequencyQuestion")
                .resizable()
                .scaledToFit()

            Spacer()

            ForEach(FrequencyType.allCases, id: \.self) { type in
                QuestionnaireSelectionButton(
                    title: type.rawValue,
                    isSelected: questionnaireVM.selectedFrequency == type,
                    action: { questionnaireVM.selectedFrequency = type }
                )
            }
            .padding(.horizontal, 48)

            NavLinkWSound(
                title: "Next",
                destination: EquipmentView(),
            )
            .padding(.horizontal, 48)
            .padding(.top, 40)
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
        FrequencyView()
            .environment(QuestionnaireViewModel())
            .environment(HomeViewModel())
    }
}
