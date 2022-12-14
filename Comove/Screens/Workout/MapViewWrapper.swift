//
//  MapViewWrapper.swift
//  Comove
//
//  Created by akozin on 09.09.2022.
//

import UIKit
import SwiftUI
import MapKit
import Combine

/// Abstract map region.
typealias MapRegion = MKCoordinateRegion

struct MapViewWrapper: UIViewControllerRepresentable {
    @Binding var showRoute: Bool
    let regionPublisher: AnyPublisher<MapRegion, Never>
    
    func makeUIViewController(context: Context) -> MapViewController {
        let vc = MapViewController(regionPublisher: regionPublisher,
                                   mapView: MKMapView())
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        if showRoute && uiViewController.routeRenderer == nil {
            uiViewController.setRouteRenderer(MapRouteLineRenderer())
        } else if !showRoute && uiViewController.routeRenderer != nil {
            uiViewController.setRouteRenderer(nil)
        }
    }
}

// MARK: - Map view controller

class MapViewController: UIViewController {
    private let mapView: MKMapView
    private var cancellable: Cancellable?
    private(set) var routeRenderer: MapRouteRenderer?
    private let regionPublisher: AnyPublisher<MapRegion, Never>
        
    fileprivate init(regionPublisher: AnyPublisher<MapRegion, Never>, mapView: MKMapView) {
        self.mapView = mapView
        self.regionPublisher = regionPublisher
            .share()
            .eraseToAnyPublisher()
        super.init(nibName: nil, bundle: nil)
        
        setupMapView()
        subscribeToRegionUpdates(self.regionPublisher)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRouteRenderer(_ routeRenderer: MapRouteRenderer?) {
        self.routeRenderer = routeRenderer
        if routeRenderer != nil {
            setupMapRouteRenderer()
        }
    }
    
    private func setupMapView() {
        mapView.frame = view.frame
        view.addSubview(mapView)
        mapView.showsUserLocation = true
    }
    
    private func setupMapRouteRenderer() {
        guard let renderer = routeRenderer else { return }
        
        renderer.setMap(mapView)
        let locationPublisher = regionPublisher
            .map { $0.center }
            .eraseToAnyPublisher()
        renderer.setLocationPublisher(locationPublisher)
    }
    
    private func subscribeToRegionUpdates(_ regionPublisher: AnyPublisher<MapRegion, Never>) {
        cancellable?.cancel()
        cancellable = regionPublisher.sink { [weak self] region in
            guard let self = self else { return }

            self.mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - Previews

struct MapViewWrapper_Previews: PreviewProvider {
    static var showRoute = Binding<Bool>.constant(false)
    static let center = CLLocationCoordinate2D(
        latitude: 55.75583, longitude: 37.61778
    )

    static var region: MapRegion {
        MapRegion(center: center, latitudinalMeters: 1000,
                  longitudinalMeters: 1000)
    }

    static var regionPublisher: AnyPublisher<MapRegion, Never> {
        return CurrentValueSubject(region)
            .eraseToAnyPublisher()
    }

    static var previews: some View {
        MapViewWrapper(showRoute: showRoute, regionPublisher: regionPublisher)
    }
}
