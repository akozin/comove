//
//  MovementView.swift
//  Comove
//
//  Created by akozin on 20.08.2022.
//

import SwiftUI
import MapKit

struct MovementView: View {
    @Environment(\.presentationMode) private var presentationMode

    private let mapCenter = CLLocationCoordinate2D(
        latitude: 55.75583, longitude: 37.61778
    )

    private var mapRegion: Binding<MapRegion> {
        Binding.constant(
            MapRegion(
                center: mapCenter,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
        )
    }
    
    var body: some View {
        NavigationView {
            MapViewWrapper(region: mapRegion)
                .toolbar {
                    ToolbarItem {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .navigationTitle("Movement")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MovementView_Previews: PreviewProvider {
    static var previews: some View {
        MovementView()
    }
}
