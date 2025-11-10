//
//  BeginnerPlanView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 05/11/25.
//

import SwiftUI

struct BeginnerPlanView: View {
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            // --- Title ---
            Text("Beginner Plan")
                .font(.title2.bold())
                .foregroundColor(Color.blueTwo)

            // --- Illustration ---
            Image("StartSmall")  // replace with your asset
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 150)

            // --- Blue Background Info Box ---
            VStack(spacing: 24) {

                Text(
                    "Build up your exercising habit by starting small and gradually increasing the duration of your exercise weekly."
                )
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
                .padding(.top, 12)

                // --- White Inner Box (Weeks) ---
                VStack(alignment: .leading, spacing: 16) {
                    Text("Week 1: 30 minutes total")
                    Text("Week 2: 36 minutes total")
                    Text("Week 3: 45 minutes total")
                    Text("Week 4: 60 minutes total")
                    Text("Week 5: 100 minutes total")
                    Text("Week 6: 120 minutes total")
                }
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.black)
                .padding(20)
                .background(Color.white)
                .cornerRadius(24)

                // --- Sub description ---
                Text(
                    "By the end of Week 6, you’ll just be 1–2 more short sessions away from reaching the 150-minute minimum weekly goal recommended for optimal health."
                )
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            .padding(.vertical, 10)
            .background(Color.cardGray)
            .cornerRadius(32)

            // --- Next Button ---
            NavigationLink(
                destination: FrequencyView(onDone: onDone),
                label: {
                    CoreButtonLabel(
                        title: "Next"
                    )
                }
            )
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        onDone()
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
    BeginnerPlanView {}
}
