//
//  HapticManager.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

//
//  HapticManager.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 18/11/25.
//

import UIKit

struct HapticService {
    static let shared = HapticService()

    private init() {}

    func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }

    func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }

    func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }

    func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }

    func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
    }
}
