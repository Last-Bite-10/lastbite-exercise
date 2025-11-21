//
//  ButtonWSound.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 18/11/25.
//

import SwiftUI

struct ButtonWSound<Label: View>: View {
    let role: ButtonRole?
    let action: () -> Void
    let label: () -> Label

    init(
        role: ButtonRole? = nil,
        action: @escaping () -> Void,
        label: @escaping () -> Label
    ) {
        self.role = role
        self.action = action
        self.label = label
    }

    private let soundPlayer = SoundPlayer.shared

    var body: some View {
        Button(
            role: role,
            action: {
                soundPlayer.playSound(named: "buttonTap.wav")
                action()
            },
            label: label
        )
    }
}

extension ButtonWSound where Label == Text {
    // Title string initializer
    init(_ title: String, role: ButtonRole? = nil, action: @escaping () -> Void)
    {
        self.role = role
        self.action = action
        self.label = { Text(title) }
    }

    // Localized string key initializer
    init(
        _ titleKey: LocalizedStringKey,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.role = role
        self.action = action
        self.label = { Text(titleKey) }
    }

    // Title with value and formatter
    init<S>(_ title: S, role: ButtonRole? = nil, action: @escaping () -> Void)
    where S: StringProtocol {
        self.role = role
        self.action = action
        self.label = { Text(String(title)) }
    }
}

#Preview {
    ButtonWSound("Hello, World!") {}
}
