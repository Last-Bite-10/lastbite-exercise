//
//  LocationType.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

enum LocationType: String, Codable, Hashable, CaseIterable {
    case indoor = "Indoor"
    case outdoor = "Outdoor"
    case both = "Both"
}
