//
//  ProgressBar.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double  // 0...1

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(.white).shadow(
                    color: .black.opacity(0.02),
                    radius: 1,
                    x: 0,
                    y: 1
                )
                Capsule().fill(
                    .button
                ).frame(width: max(12, geo.size.width * value))
            }
        }
        .frame(height: 12)
        .padding(.trailing, 12)
    }
}

#Preview {
    ProgressBar(value: 0.2)
}
