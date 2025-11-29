//
//  FrequencyView.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftData
import SwiftUI

struct FrequencyView: View {
    @Environment(PreferenceViewModel.self) private var viewModel

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
                    isSelected: viewModel.selectedFrequency == type,
                    action: { viewModel.selectedFrequency = type }
                )
            }
            .padding(.horizontal, 48)

            NavLinkWSound(
                title: "Next",
                destination: EquipmentView().environment(viewModel),
            )
            .padding(.horizontal, 48)
            .padding(.top, 40)
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
        FrequencyView().environment(PreferenceViewModel())
    }
}
