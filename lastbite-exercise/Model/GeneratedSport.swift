//
//  GeneratedSport.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 24/10/25.
//

import Foundation
import FoundationModels

@Generable(description: "Sport generated based on user preferences")
struct GeneratedSport: Codable, Hashable {

    @Guide(description: "Type of sport activity")
    var sportType: SportType

    @Guide(description: "Duration of the sport activity in seconds")
    var duration: TimeInterval
}
