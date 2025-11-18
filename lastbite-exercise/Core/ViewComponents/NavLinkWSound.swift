//
//  NavLinkWSound.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 17/11/25.
//

import SwiftUI

struct NavLinkWSound<Destination: View>: View {
    let title: String
    let destination: Destination

    private let soundPlayer = SoundPlayer.shared

    var body: some View {
        NavigationLink(
            destination: destination,
            label: { CoreButtonLabel(title: title) }
        )
        .simultaneousGesture(
            TapGesture().onEnded {
                soundPlayer.playSound(named: "buttonTap.wav")
            }
        )
    }
}
