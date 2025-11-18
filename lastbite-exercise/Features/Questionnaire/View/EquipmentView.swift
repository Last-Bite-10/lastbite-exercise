//
//  ToolsView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftData
import SwiftUI

struct EquipmentView: View {
    @Environment(QuestionnaireViewModel.self) private var viewModel

    @Environment(\.dismissFlow) private var dismissFlow

    let onDone: () -> Void

    private func disableButtonCondition(currentEquipment: EquipmentType) -> Bool
    {
        if currentEquipment == .none {
            return !viewModel.selectedEquipment.isEmpty
                && !viewModel.selectedEquipment.contains(.none)
        } else {
            return viewModel.selectedEquipment.contains(.none)
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("2/3")
                .font(.headline)

            Text(
                "Help us determined what exercise plan is perfect for you!"
            )
            .font(.headline)
            .multilineTextAlignment(.center)
            .frame(maxWidth: 300)

            Image("EquipmentQuestion")
                .resizable()
                .scaledToFit()

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
                                    viewModel.selectedEquipment.remove(type)
                                } else {
                                    viewModel.selectedEquipment.insert(type)
                                }
                            }
                        ).disabled(
                            disableButtonCondition(currentEquipment: type)
                        )
                    }
                }
            ).padding(.top, 48)

            NavLinkWSound(
                title: "Next",
                destination: LocationView(onDone: onDone),
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
        EquipmentView(onDone: {})
            .environment(QuestionnaireViewModel())
    }
}
