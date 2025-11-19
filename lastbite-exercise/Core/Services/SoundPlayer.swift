//
//  SoundPlayer.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 17/11/25.
//

import AVFoundation

final class SoundPlayer {
    static let shared = SoundPlayer()
    private var player: AVAudioPlayer?

    private init() {}

    func playSound(named soundName: String) {
        guard
            let url = Bundle.main.url(
                forResource: soundName,
                withExtension: nil
            )
        else {
            print("Sound file \(soundName) not found.")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}
