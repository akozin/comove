//
//  MapRouteRenderer.swift
//  Comove
//
//  Created by akozin on 12.09.2022.
//

import UIKit
import MapKit
import Combine

/// Renderer, which draws the route on the map.
protocol MapRouteRenderer {
    /// Set map on which to draw the route.
    func setMap(_ map: MKMapView)
    /// Set publisher with locations, from which the route is created.
    func setLocationPublisher(_ publisher: AnyPublisher<CLLocationCoordinate2D, Never>)
}

/// Renderer, which draws the route on the map with a plain line.
class MapRouteLineRenderer: NSObject, MapRouteRenderer {
    /// Minimum required distance between obtained locations.
    private let kMinDistanceInMeters: CLLocationDistance = 10
    
    private var map: MKMapView?
    private var locationPublisher: AnyPublisher<CLLocationCoordinate2D, Never>?
    private var cancellable: AnyCancellable?
    
    private var route: [CLLocationCoordinate2D] = [] {
        didSet { render() }
    }
        
    func setLocationPublisher(_ publisher: AnyPublisher<CLLocationCoordinate2D, Never>) {
        locationPublisher = publisher
        subscribeToLocationUpdates()
    }
    
    func setMap(_ map: MKMapView) {
        self.map = map
        self.map?.delegate = self
    }
    
    /// Renders the route with a plain line.
    private func render() {
        guard let map = map else { return }
        
        let overlay = MKPolyline(coordinates: route, count: route.count)
        map.removeOverlays(map.overlays)
        map.addOverlay(overlay)
    }
    
    private func subscribeToLocationUpdates() {
        cancellable?.cancel()
        cancellable = self.locationPublisher?.sink(receiveValue: { [weak self] location in
            guard let self = self else { return }
            
            if self.route.isEmpty || self.minDistanceHasTravelled(to: location) {
                self.route.append(location)
            }
        })
    }
    
    /// Whether the distance between the last saved and just obtained locations is greater, than minimum required distance.
    /// - Parameter to: Last obtained location.
    private func minDistanceHasTravelled(to: CLLocationCoordinate2D) -> Bool {
        if route.isEmpty {
            return true
        } else if let lastSavedLocation = route.last,
           distance(from: lastSavedLocation, to: to) > kMinDistanceInMeters {
            return true
        }
        return false
    }
    
    private func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return to.distance(from: from)
    }
}

extension MapRouteLineRenderer: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5.0
        renderer.strokeColor = UIColor(named: "MapRouteColor")
        return renderer
    }
}
