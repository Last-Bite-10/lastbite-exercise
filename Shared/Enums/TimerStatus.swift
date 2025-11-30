//
//  TimerStatusType.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 29/11/25.
//

enum TimerStatus: String, Codable, Hashable, CaseIterable {
    case timerPaused
    case timerStarted
    case timerStopped
    case timerOverflown
    case timerBelowBPM
}
