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
    private let regionPublisher: AnyPublisher<MapRegion, Never>
    
    init(regionPublisher: AnyPublisher<MapRegion, Never>) {
        self.regionPublisher = regionPublisher
    }
    
    func makeUIViewController(context: Context) -> MapViewController {
        let vc = MapViewController(regionPublisher: regionPublisher,
                                   mapView: MKMapView(),
                                   routeRenderer: MapRouteLineRenderer())
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        //
    }
}

// MARK: - Map view controller

/// Abstract map view.
//fileprivate protocol MapView: UIView {
//    var frame: CGRect { get set }
//    var region: MapRegion { get set }
//    var showsUserLocation: Bool { get set }
//    func addOverlay(_ overlay: MKOverlay)
//    func removeOverlay(_ overlay: MKOverlay)
//}
//
//extension MKMapView: MapView {}

class MapViewController: UIViewController {
    private let mapView: MKMapView
    private var cancellable: Cancellable?
    private let routeRenderer: MapRouteRenderer
    private let regionPublisher: AnyPublisher<MapRegion, Never>
        
    fileprivate init(regionPublisher: AnyPublisher<MapRegion, Never>,
                     mapView: MKMapView, routeRenderer: MapRouteRenderer) {
        self.mapView = mapView
        self.routeRenderer = routeRenderer
        self.regionPublisher = regionPublisher
            .share()
            .eraseToAnyPublisher()
        super.init(nibName: nil, bundle: nil)
        
        setupMapView()
        setupMapRouteRenderer()
        subscribeToRegionUpdates(self.regionPublisher)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMapView() {
        mapView.frame = view.frame
        view.addSubview(mapView)
        mapView.showsUserLocation = true
    }
    
    private func setupMapRouteRenderer() {
        routeRenderer.setMap(mapView)
        let locationPublisher = regionPublisher
            .map { $0.center }
            .eraseToAnyPublisher()
        routeRenderer.setLocationPublisher(locationPublisher)
    }
    
    private func subscribeToRegionUpdates(_ regionPublisher: AnyPublisher<MapRegion, Never>) {
        cancellable?.cancel()
        cancellable = regionPublisher.sink { [weak self] region in
            guard let self = self else { return }
            
            self.mapView.region = region
        }
    }
}

// MARK: - Previews

struct MapViewWrapper_Previews: PreviewProvider {
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
        MapViewWrapper(regionPublisher: regionPublisher)
    }
}
