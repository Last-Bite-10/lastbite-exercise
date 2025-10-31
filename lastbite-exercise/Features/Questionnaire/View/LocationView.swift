//
//  LocationView.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 23/10/25.
//

import SwiftData
import SwiftUI

struct LocationView: View {
    @Environment(QuestionnaireViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 10) {
            Text("Help us determined what exercise plan is perfect for you!")
                .font(Font.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)

            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 210)
                .foregroundStyle(Color.accentColor)

            Text("Where do you prefer to do your exercise?")
                .font(.body)
                .padding(.bottom, 48)

            ForEach(LocationType.allCases, id: \.self) { type in
                QuestionnaireSelectionButton(
                    title: type.rawValue,
                    isSelected: viewModel.selectedLocation == type,
                    widthReduction: 160,
                    action: { viewModel.selectedLocation = type }
                )
            }

            // Tombol "Done" ini sudah benar (menyimpan semua data)
            Button(
                action: {
                    let preference = Preference(
                        isUsingPlan: true,
                        frequency: viewModel.selectedFrequency,
                        equipmentAvailable: Array(viewModel.selectedEquipment),
                        location: viewModel.selectedLocation
                    )
                    modelContext.insert(preference)
                },
                label: { QuestionnaireNavButtonLabel(title: "Done") }
            ).padding(.top, 64)

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        // DIUBAH: Logika "Skip" disamakan
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

#Preview {
    LocationView()
        .environment(QuestionnaireViewModel())
}
