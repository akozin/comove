//
//  MapViewWrapper.swift
//  Comove
//
//  Created by akozin on 09.09.2022.
//

import UIKit
import SwiftUI
import MapKit

// Separate interface from implementation
typealias MapRegion = MKCoordinateRegion

struct MapViewWrapper: UIViewControllerRepresentable {
    private let region: Binding<MapRegion>
    
    init(region: Binding<MapRegion>) {
        self.region = region
    }
    
    func makeUIViewController(context: Context) -> MapViewController {
        let vc = MapViewController(region: region.wrappedValue)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        //
    }
}

class MapViewController: UIViewController {
    private var mapView: MKMapView?
    
    init(region: MapRegion) {
        super.init(nibName: nil, bundle: nil)
        self.mapView = MKMapView.init(frame: view.frame)
        self.mapView?.region = region
        if let mapView = mapView {
            view.addSubview(mapView)
            mapView.showsUserLocation = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


struct MapViewWrapper_Preview: PreviewProvider {
    static let center = CLLocationCoordinate2D(
        latitude: 55.75583, longitude: 37.61778
    )
    
    static var region: Binding<MKCoordinateRegion> {
        Binding<MKCoordinateRegion>.constant(
            MKCoordinateRegion(
                center: center, latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
        )
    }
    
    static var previews: some View {
        MapViewWrapper(region: region)
    }
}
