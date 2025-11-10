//
//  WatchRecordViewModel.swift
//  ExaWatch Watch App
//
//  Created by Ammar Alifian Fahdan on 27/10/25.
//

import Combine
import SwiftUI

@MainActor
class WatchRecordViewModel: ObservableObject {
    @Published var progress: CGFloat = 1.0
    @Published var isPaused: Bool = true
    @Published var timeRemaining: Int = 0
    @Published var totalDuration: Int = 0

    private var cancellables = Set<AnyCancellable>()

    var timeRemainingFormatted: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func connectToHealthManager(_ healthManager: WatchHealthManager) {
        // Subscribe to progress updates from iPhone
        healthManager.$receivedProgress
            .sink { [weak self] progressData in
                self?.updateProgress(progressData)
            }
            .store(in: &cancellables)
    }

    private func updateProgress(_ data: ProgressData?) {
        guard let data = data else { return }

        self.progress = data.progress
        self.isPaused = data.isPaused
        self.timeRemaining = data.timeRemaining
        self.totalDuration = data.totalDuration
    }
}

struct ProgressData {
    let progress: CGFloat
    let isPaused: Bool
    let timeRemaining: Int
    let totalDuration: Int
}
