//
//  StartStrong.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 18/11/25.
//

import SwiftData
import SwiftUI

struct StartStrongView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = PreferenceViewModel()

    var onDoneAction: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            Text("Start Strong!")
                .font(.title2.bold())
                .foregroundColor(.title)

            Image("StartSmall")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 150)

            VStack(spacing: 24) {
                Text(
                    "Build a consistent exercise routine by directly meeting the WHO recommended **150 minutes of exercise per week**."
                )
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 16) {
                    Text("1 day / Week: 150 minutes per day")
                    Text("2 day / Week: 75 minutes per day")
                    Text("3 day / Week: 50 minutes per day")
                    Text("4 day / Week: 38 minutes per day")
                    Text("5 day / Week: 30 minutes per day")
                }
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(20)
                .background(.white)
                .cornerRadius(16)

                Text(
                    "This plan is ideal if you're ready to begin at the recommended optimal level for health."
                )
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(30)
            .background(.card)
            .cornerRadius(30)

            NavLinkWSound(
                title: "Next",
                destination: FrequencyView().environment(viewModel),
            )
            .padding(.horizontal, 48)
        }
        .onAppear {
            viewModel.setup(
                modelContext: modelContext,
                onDoneAction: onDoneAction
            )
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cancel", systemImage: "xmark", action: onDoneAction)
                    .buttonStyle(.borderless)
            }
        }
    }
}

#Preview {
    NavigationStack {
        StartStrongView {}
    }
}
