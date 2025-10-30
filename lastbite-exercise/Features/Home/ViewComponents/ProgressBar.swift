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
                Capsule().fill(Color.white).shadow(
                    color: Color.black.opacity(0.02),
                    radius: 1,
                    x: 0,
                    y: 1
                )
                Capsule().fill(
                    Color(
                        #colorLiteral(
                            red: 0.113,
                            green: 0.356,
                            blue: 0.617,
                            alpha: 1
                        )
                    )
                ).frame(width: max(12, geo.size.width * value))
            }
        }
        .frame(height: 12)
        .padding(.trailing, 12)
        .background(
            Capsule().stroke(Color.white.opacity(0.7), lineWidth: 6)
        )
    }
}
