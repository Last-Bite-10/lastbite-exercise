//
//  Item.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 20/10/25.
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
