//
//  StartSmallView.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import SwiftData
import SwiftUI

struct StartSmallView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = PreferenceViewModel()

    var onDoneAction: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            Text("Start Small!")
                .font(.title2.bold())
                .foregroundStyle(.title)

            Image("StartSmall")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 150)

            VStack(spacing: 24) {
                Text(
                    "Build up your exercising habit by **starting small and gradually increasing** the duration of your exercise weekly."
                )
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Week 1: 30 minutes total")
                    Text("Week 2: 36 minutes total")
                    Text("Week 3: 45 minutes total")
                    Text("Week 4: 60 minutes total")
                    Text("Week 5: 100 minutes total")
                    Text("Week 6: 120 minutes total")
                }
                .font(.subheadline)
                .foregroundStyle(.primary)
                .padding(20)
                .background(.white)
                .cornerRadius(16)

                Text(
                    "By the end of Week 6, you’ll just be 1–2 more short sessions away from reaching the 150-minute minimum weekly goal recommended for optimal health."
                )
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
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
        StartSmallView {}
    }
}
