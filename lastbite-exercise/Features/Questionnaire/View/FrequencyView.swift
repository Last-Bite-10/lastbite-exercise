//
//  FrequencyView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftData
import SwiftUI

struct FrequencyView: View {
    @Environment(QuestionnaireViewModel.self) private var viewModel

    @Environment(\.dismissFlow) private var dismissFlow

    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text("1/3")
                .font(.headline)
            Text("Choose your preferred frequency")
                .font(.headline)

            Image("FrequencyQuestion")
                .resizable()
                .scaledToFit()

            ForEach(FrequencyType.allCases, id: \.self) { type in
                QuestionnaireSelectionButton(
                    title: type.rawValue,
                    isSelected: viewModel.selectedFrequency == type,
                    widthReduction: 200,
                    action: { viewModel.selectedFrequency = type }
                )
            }

            NavLinkWSound(
                title: "Next",
                destination: EquipmentView(onDone: onDone)
            )
            .padding(.top, 40)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cancel", systemImage: "xmark") { dismissFlow() }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FrequencyView(onDone: {})
            .environment(QuestionnaireViewModel())
    }
}
