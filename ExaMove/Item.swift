//
//  Item.swift
//  ExaMove
//
//  Created by Ali Ahmad Fahrezy on 28/11/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
