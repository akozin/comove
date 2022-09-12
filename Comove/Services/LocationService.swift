//
//  LocationService.swift
//  Comove
//
//  Created by akozin on 10.09.2022.
//

import Foundation
import Combine
import CoreLocation

class LocationService: NSObject {
    static let shared = LocationService()

    var locationPublisher: AnyPublisher<CLLocation, Never> {
        return locationSubject.eraseToAnyPublisher()
    }
    
    private let locationSubject = PassthroughSubject<CLLocation, Never>()
    
    private let locationManager = CLLocationManager()
    private var authorizationStatusContinuation: CheckedContinuation<Bool, Never>?
    
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    /// Requests an access to location service data.
    /// - Returns: Whether an access is granted.
    func requestAccess() async -> Bool {
        return await withCheckedContinuation { continuation in
            guard !isAuthorized() else {
                continuation.resume(returning: true)
                return
            }
            locationManager.requestAlwaysAuthorization()
            authorizationStatusContinuation = continuation
        }
    }
    
    /// Starts obtaining location updates.
    func startUpdatingLocation() {
        if isAuthorized() {
            locationManager.startUpdatingLocation()
        }
    }
    
    /// Stops obtaining location updates.
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Private
    
    /// Whether location obtaining is allowed by user.
    private func isAuthorized() -> Bool {
        let status = locationManager.authorizationStatus
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatusContinuation?.resume(returning: isAuthorized())
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        locationSubject.send(location)
    }
}
