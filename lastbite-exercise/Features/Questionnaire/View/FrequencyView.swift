//
//  FrequencyView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftData
import SwiftUI

struct FrequencyView: View {
    @State private var viewModel = QuestionnaireViewModel()
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

            NavigationLink(
                destination:
                    EquipmentView(onDone: onDone)
                    .environment(viewModel),
                label: { CoreButtonLabel(title: "Next") }
            ).padding(.top, 64)

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        onDone()
                    },
                    label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                    }
                )
                .buttonStyle(.glass)
            }
        }
    }
}

#Preview {
    FrequencyView(onDone: {})
}
