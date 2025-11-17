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
    @Query private var preferences: [Preference]
    
    @Environment(\.dismissFlow) private var dismissFlow
    
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text("3/3")
                .font(.headline)

            Text("Help us determined what exercise plan is perfect for you!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)

            Image("LocationQuestion")
                .resizable()
                .scaledToFit()

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

            Button(
                action: {
                    preferences.first?.frequency = viewModel.selectedFrequency
                    preferences.first?.equipmentAvailable =
                        Array(viewModel.selectedEquipment)
                    preferences.first?.location = viewModel.selectedLocation
                    
                    onDone()
                },
                label: { CoreButtonLabel(title: "Done") }
            )
            .padding(.top, 40)
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        dismissFlow()
                    },
                    label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                    }
                ).buttonStyle(.borderless)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LocationView(onDone: {})
            .environment(QuestionnaireViewModel())
    }
}
