//
//  WeatherEnum.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 03/11/25.
//

enum WeatherType: String, Codable, Hashable, CaseIterable {
    // ideal
    case clear
    case notAffected
    case noStrongWind
    case avoidStrongWind
    
    // blockers
    case rainy
    case extremeHeat
    case strongWind
}
