//
//  LocationManager.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 20/11/25.
//


import CoreLocation
import Foundation

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // 1. CLLocationManager
    private let locationManager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus?
    var currentLocation: CLLocationCoordinate2D?
    var locationError: Error?
    
    override init() {
        super.init()

        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters 
    }
    
    // MARK: - Authorization
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            requestLocationAuthorization()
        }
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted.")
        case .notDetermined:
            requestLocationAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.currentLocation = location.coordinate
        
        manager.stopUpdatingLocation() 
        
        print("Lokasi berhasil diambil: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        // DI SINI ADALAH TEMPAT UNTUK MEMANGGIL API CUACA MENGGUNAKAN KOORDINAT INI
        // (Langkah Anda selanjutnya)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationError = error
        print("Location update failed: \(error.localizedDescription)")
    }
}
