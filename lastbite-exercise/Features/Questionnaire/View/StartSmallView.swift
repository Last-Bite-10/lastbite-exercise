//
//  StartSmallView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 05/11/25.
// swiftlint:disable line_length

import SwiftUI

struct StartSmallView: View {
    @Environment(\.dismissFlow) private var dismissFlow
    
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 24) {

            Text("Start Small!")
                .font(.title2.bold())
                .foregroundColor(Color("BlueTwo"))

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
                .foregroundColor(.primary)
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
                .foregroundColor(.primary)
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)

                Text(
                    "By the end of Week 6, you’ll just be 1–2 more short sessions away from reaching the 150-minute minimum weekly goal recommended for optimal health."
                )
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(30)
            .background(Color.cardGray)
            .cornerRadius(30)
           
            NavLinkWSound(
                title: "Next",
                destination: FrequencyView(onDone: onDone),
            )
        }
        .padding(.horizontal)
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
        StartSmallView(onDone: {})
    }
}
