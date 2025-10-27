//
//  User.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 24/10/25.
//

import Foundation
import SwiftData

@Model
final class User {
    var id: UUID
    var tools: [ToolType]
    var location: LocationType
    var records: [Record]
    var weeklys: [Weekly]

    init(tools: [ToolType], location: LocationType) {
        self.id = UUID()
        self.tools = tools
        self.location = location
        self.records = []
        self.weeklys = []
    }
}

enum ToolType: String, Codable, Hashable, CaseIterable {
    case matress = "Matress"
    case dumbbell = "Dumbbell"
    case bike = "Bike"
    case yogaMat = "Yoga Mat"
    case jumpRope = "Jump Rope"
    case stairs = "Stairs"
}

enum LocationType: String, Codable, Hashable, CaseIterable {
    case indoor = "Indoor"
    case outdoor = "Outdoor"
    case both = "Both"
}
