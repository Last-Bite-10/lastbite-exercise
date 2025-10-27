//
//  Record.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 24/10/25.
//

import Foundation
import FoundationModels

struct Record: Codable, Hashable {
    var id: UUID
    var date: Date
    var activetime: TimeInterval
    var totalTime: TimeInterval
    var targetTime: TimeInterval
    var sportType: SportType
}

@Generable(description: "Type of sport activity")
enum SportType: String, Codable, Hashable, CaseIterable {
    case running
}
