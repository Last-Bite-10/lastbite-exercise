//
//  WeatherManager.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 21/11/25.
//

import Foundation
import WeatherKit
import CoreLocation

@Observable
@MainActor
class WeatherManager {
    static let shared = WeatherManager()
    
    var currentWeatherType: WeatherType = .notAffected
    
    private let service = WeatherService.shared
    
    func fetchWeather(for location: CLLocationCoordinate2D) async {
        do {
            let weather = try await service.weather(for: CLLocation(latitude: location.latitude, longitude: location.longitude)) // swiftlint:disable:this line_length
            
            let condition = weather.currentWeather.condition
            let windSpeed = weather.currentWeather.wind.speed.value // in km/h or mph
            
           // Mapping in weather type
            self.currentWeatherType = self.mapToInternalType(condition: condition, windSpeed: windSpeed)
            
            print("--------------------------------------------------")
            print("✅ WEATHER SUCCESS")
            print("📍 Raw Condition (Apple): \(condition)")
            print("💨 Wind Speed: \(windSpeed)")
            print("🎯 Mapped to (My App): \(self.currentWeatherType.rawValue)") // atau \(self.currentWeatherType)
            print("--------------------------------------------------")
            
        } catch {
            print("Gagal mengambil cuaca: \(error)")
            // Fallback if fail
            self.currentWeatherType = .notAffected
        }
    }

    private func mapToInternalType(condition: WeatherCondition, windSpeed: Double) -> WeatherType {
        
        // Consider it is strong wind
        if windSpeed > 20.0 {
            return .strongWind
        }
        
        switch condition {
            
        // Rain
        case .rain, .drizzle, .heavyRain, .isolatedThunderstorms,
             .thunderstorms, .tropicalStorm, .freezingRain, .hail:
            return .rainy
            
        // Hot
        case .hot:
            return .extremeHeat
            
       // Clear
        case .cloudy, .mostlyCloudy, .partlyCloudy, .clear, .mostlyClear, .foggy, .haze:
            return .clear
            
        // Default
        default:
            return .rainy
        }
    }
}
