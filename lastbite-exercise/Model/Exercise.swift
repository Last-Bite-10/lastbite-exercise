//
//  Exercise.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 28/10/25.
//

struct Exercise: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let location: LocationType
    let equipment: EquipmentType
    let weather: String
}
