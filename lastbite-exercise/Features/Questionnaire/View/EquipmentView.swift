//
//  ToolsView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftUI

struct EquipmentView: View {
    @Environment(QuestionnaireViewModel.self) private var viewModel
    @Binding var showQuestionnaire: Bool

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
                    GridItem(.flexible()),
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
                                    viewModel.selectedEquipment.removeAll {
                                        $0 == type
                                    }
                                } else {
                                    viewModel.selectedEquipment.append(type)
                                }
                            }
                        )
                    }
                }
            ).padding(.top, 48)

            NavigationLink(
                destination: LocationView(showQuestionnaire: $showQuestionnaire)
                    .environment(viewModel),
                label: {
                    QuestionnaireNavButtonLabel(
                        title: "Get Recommendation"
                    )
                }
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
    EquipmentView(showQuestionnaire: .constant(true))
        .environment(QuestionnaireViewModel())
}
