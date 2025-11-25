//
//  ExerciseRow.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 07/11/25.
//

import SwiftUI

struct ExerciseRow: View {
    var name: String
    var duration: Int
    var action: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text("\(duration) mins")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: action) {
                Image(systemName: "play.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(.button))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.card)
        )
    }
}
