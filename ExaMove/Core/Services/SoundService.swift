//
//  SoundPlayer.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

import AVFoundation

final class SoundService {
    static let shared = SoundService()
    private var player: AVAudioPlayer?

    private init() {}

    func playSound(named soundName: String) {
        guard
            let url = Bundle.main.url(
                forResource: soundName,
                withExtension: nil
            )
        else {
            Debugging.debug("Sound file \(soundName) not found.")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            Debugging.debug("Error playing sound: \(error)")
        }
    }
}
