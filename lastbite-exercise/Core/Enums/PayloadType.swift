//
//  PayloadType.swift
//  lastbite-exercise
//
//  Created by Ammar Alifian Fahdan on 08/11/25.
//

// This enums is supposed to be accessible from both iOS (Exa) and Watch.

enum PayloadType: String, CaseIterable, Hashable {
    case timerChange = "timer_change"
    case bpmChange = "bpm_change"
}

enum TimerStatusType: String, Codable, Hashable, CaseIterable {
    case timerPaused = "timer_paused"
    case timerStarted = "timer_started"
    case timerStopped = "timer_stopped"
    case timerOverflown = "timer_overflown"
    case timerBelowBPM = "timer_below_bpm"
}
