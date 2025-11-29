//
//  ButtonWSound.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 18/11/25.
//

import SwiftUI

struct ButtonWSound<Label: View>: View {
    let role: ButtonRole?
    let disabled: Bool
    let action: () -> Void
    let label: () -> Label

    init(
        role: ButtonRole? = nil,
        disabled: Bool = false,
        action: @escaping () -> Void,
        label: @escaping () -> Label
    ) {
        self.role = role
        self.disabled = disabled
        self.action = action
        self.label = label
    }

    private let soundService = SoundService.shared

    var body: some View {
        Button(
            role: role,
            action: {
                soundService.playSound(named: "buttonTap.wav")
                action()
            },
            label: label
        )
        .disabled(disabled)
    }
}

extension ButtonWSound where Label == Text {
    // Title string initializer
    init(
        _ title: String,
        disabled: Bool = false,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.role = role
        self.disabled = false
        self.action = action
        self.label = { Text(title) }
    }

    // Localized string key initializer
    init(
        _ titleKey: LocalizedStringKey,
        disabled: Bool = false,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.role = role
        self.disabled = disabled
        self.action = action
        self.label = { Text(titleKey) }
    }

    // Title with value and formatter
    init<S>(
        _ title: S,
        disabled: Bool = true,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    )
    where S: StringProtocol {
        self.role = role
        self.disabled = disabled
        self.action = action
        self.label = { Text(String(title)) }
    }
}

#Preview {
    ButtonWSound("Hello, World!") {}
}
