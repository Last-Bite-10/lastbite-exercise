//
//  ToolsView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftData
import SwiftUI

struct EquipmentView: View {
    @Environment(QuestionnaireViewModel.self) private var questionnaireVM
    @Environment(HomeViewModel.self) private var homeVM
    @Query private var preferences: [Preference]

    var preference: Preference? { preferences.first }

    private func disableButtonCondition(currentEquipment: EquipmentType) -> Bool
    {
        if currentEquipment == .none {
            return !questionnaireVM.selectedEquipment.isEmpty
                && !questionnaireVM.selectedEquipment.contains(.none)
        } else {
            return questionnaireVM.selectedEquipment.contains(.none)
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
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ],
                spacing: 12,
                content: {
                    ForEach(EquipmentType.allCases, id: \.self) { type in
                        QuestionnaireSelectionButton(
                            title: type.rawValue,
                            isSelected: questionnaireVM.selectedEquipment
                                .contains(
                                    type
                                ),
                            action: {
                                if questionnaireVM.selectedEquipment.contains(
                                    type
                                ) {
                                    questionnaireVM.selectedEquipment.remove(
                                        type
                                    )
                                } else {
                                    questionnaireVM.selectedEquipment.insert(
                                        type
                                    )
                                }
                            }
                        )
                        .disabled(
                            disableButtonCondition(currentEquipment: type)
                        )
                    }
                }
            )
            .padding(.top, 24)
            .padding(.horizontal)

            NavLinkWSound(
                title: "Next",
                destination: LocationView(),
            )
            .padding(.horizontal, 48)
            .padding(.top, 40)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cancel", systemImage: "xmark") {
                    if let preference = preference {
                        homeVM.onCancelAction(preference: preference)
                    }
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EquipmentView()
            .environment(QuestionnaireViewModel())
            .environment(HomeViewModel())
    }
}
