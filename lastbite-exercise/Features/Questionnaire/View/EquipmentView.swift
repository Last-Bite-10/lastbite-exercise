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
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ],
                spacing: 12,
                content: {
                    ForEach(EquipmentType.allCases, id: \.self) { type in
                        QuestionnaireSelectionButton(
                            title: type.rawValue,
                            isSelected: viewModel.selectedEquipment.contains(
                                type
                            ),
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
            )
            .padding(.top, 24)
            .padding(.horizontal)

            NavigationLink(
                destination: LocationView(onDone: onDone),
                label: {
                    CoreButtonLabel(
                        title: "Next"
                    )
                }
            )
            .padding(.horizontal, 48)
            .padding(.top, 40)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        dismissFlow()
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
        EquipmentView(onDone: {})
            .environment(QuestionnaireViewModel())
    }
}
