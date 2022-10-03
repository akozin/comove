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
            self?.route.append(location)
        })
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
