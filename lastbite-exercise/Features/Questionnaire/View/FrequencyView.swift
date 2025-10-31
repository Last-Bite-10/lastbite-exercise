//
//  FrequencyView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftUI

struct FrequencyView: View {
    @State private var viewModel = QuestionnaireViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Text("Choose your preferred frequency")
                    .font(Font.headline)

                Image(systemName: "clock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 210)
                    .foregroundStyle(Color.accentColor)

                ForEach(FrequencyType.allCases, id: \.self) { type in
                    QuestionnaireSelectionButton(
                        title: type.rawValue,
                        isSelected: viewModel.selectedFrequency == type,
                        action: { viewModel.selectedFrequency = type }
                    )
                }

                NavigationLink(
                    destination:
                        EquipmentView()
                        .environment(viewModel),
                    label: { QuestionnaireNavButtonLabel(title: "Next") }
                ).padding(.top, 64)

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                            // Logika "Skip" yang Benar
                            let preference = Preference()
                            modelContext.insert(preference)
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
}

#Preview {
    FrequencyView()
}
