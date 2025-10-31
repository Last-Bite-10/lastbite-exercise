//
//  EquipmentView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftUI

struct EquipmentView: View {
    @Environment(QuestionnaireViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 10) {
            Text(
                "Help us determined what exercise plan is perfect for you!"
            )
            .font(Font.headline)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 300)

            Image(systemName: "dumbbell.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 210)
                .foregroundStyle(Color.accentColor)

            Text("What tools do you have in your home?")
                .font(.body)
                .fontWeight(.semibold)

            Text("(You can choose more than one)")
                .font(.body)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: -24),
                    GridItem(.flexible())
                ],
                spacing: 5,
                content: {
                    ForEach(EquipmentType.allCases, id: \.self) { type in
                        QuestionnaireSelectionButton(
                            title: type.rawValue,
                            isSelected: viewModel.selectedEquipment.contains(
                                type
                            ),
                            widthReduction: 240,
                            action: {
                                if viewModel.selectedEquipment.contains(type) {
                                    viewModel.selectedEquipment.remove(type)
                                } else {
                                    viewModel.selectedEquipment.insert(type)
                                }
                            }
                        )
                    }
                }
            ).padding(.top, 48)

            NavigationLink(
                destination: LocationView()
                    .environment(viewModel),
                label: {
                    QuestionnaireNavButtonLabel(
                        title: "Next"
                    )
                }
            ).padding(.top, 64)

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        let preference = Preference(
                            frequency: viewModel.selectedFrequency
                        )
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

#Preview {
    EquipmentView()
        .environment(QuestionnaireViewModel())
}
