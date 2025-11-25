//
//  Exa
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//

import SwiftUI

struct RecordPlayButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        ButtonWSound(action: action) {
            Text(title)
                .font(.body)
                .padding(.vertical, 12)
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(
                    Capsule()
                        .fill(.button)
                )
                .accessibilityLabel(title)
        }
        .padding(.horizontal, 48)
    }
}

#Preview {
    RecordPlayButton(title: "Record", action: {})
}
