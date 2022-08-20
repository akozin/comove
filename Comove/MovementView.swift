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

    private let region: Binding = Binding.constant( MKCoordinateRegion(center: .init(latitude: 55.75583, longitude: 37.61778), latitudinalMeters: 1000, longitudinalMeters: 1000))
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: region)
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
