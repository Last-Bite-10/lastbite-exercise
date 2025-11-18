//
//  TodaysPlanHeader.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 31/10/25.
//

import SwiftUI

struct TodaysPlanHeader: View {
    var title: String = "Today's Plan"
    var actionTitle: String = "Modify"
    var onModifyTapped: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.blueTwo)

            Spacer()

            ButtonWSound(action: onModifyTapped) {
                HStack(spacing: 4) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .semibold))
                    Text(actionTitle)
                        .font(.headline)
                }
                .foregroundColor(Color.blueTwo)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview
#Preview {
    TodaysPlanHeader {
        print("Modify tapped")
    }
}
