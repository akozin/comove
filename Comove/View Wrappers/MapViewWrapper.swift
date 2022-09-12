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

// Separate interface from implementation
typealias MapRegion = MKCoordinateRegion

struct MapViewWrapper: UIViewControllerRepresentable {
    private let regionPublisher: AnyPublisher<MapRegion, Never>
    
    init(regionPublisher: AnyPublisher<MapRegion, Never>) {
        self.regionPublisher = regionPublisher
    }
    
    func makeUIViewController(context: Context) -> MapViewController {
        let vc = MapViewController(regionPublisher: regionPublisher)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        //
    }
}

class MapViewController: UIViewController {
    private var mapView: MKMapView?
    private var cancellable: Cancellable?
    
    init(regionPublisher: AnyPublisher<MapRegion, Never>) {
        super.init(nibName: nil, bundle: nil)
        self.mapView = MKMapView(frame: view.frame)
        if let mapView = mapView {
            view.addSubview(mapView)
            mapView.showsUserLocation = true
            subscribeToRegionUpdates(regionPublisher)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func subscribeToRegionUpdates(_ regionPublisher: AnyPublisher<MapRegion, Never>) {
        cancellable?.cancel()
        cancellable = regionPublisher
            .sink { _ in } receiveValue: { [weak self] region in
            self?.mapView?.region = region
        }
    }
}


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
