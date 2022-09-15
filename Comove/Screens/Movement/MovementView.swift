//
//  MovementView.swift
//  Comove
//
//  Created by akozin on 20.08.2022.
//

import SwiftUI
import MapKit
import Combine

struct MovementView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    private var mapRegionPublisher: AnyPublisher<MapRegion, Never> {
        LocationService.shared.locationPublisher
            .map { location in
                let distance: CLLocationDistance = 500
                return MapRegion(
                    center: location.coordinate,
                    latitudinalMeters: distance,
                    longitudinalMeters: distance
                )
            }
            .eraseToAnyPublisher()
    }

    @State private var isWorkoutStarted: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                MapViewWrapper(showRoute: $isWorkoutStarted,
                               regionPublisher: mapRegionPublisher)
                WorkoutIndicatorsBarView(
                    speed: .constant("12 km/h"),
                    distance: .constant("1.2 km"),
                    pace: .constant("6 min/km"),
                    duration: .constant("1h 20min")
                )
                StartButtonView(
                    label: isWorkoutStarted ? "Stop" : "Start",
                    action: { isWorkoutStarted.toggle() }
                )
                .padding(.bottom)
            }
            .toolbar {
                ToolbarItem {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Workout")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    let isAccessGranted = await LocationService.shared.requestAccess()
                    if isAccessGranted {
                        LocationService.shared.startUpdatingLocation()
                    }
                }
            }
            .onDisappear {
                LocationService.shared.stopUpdatingLocation()
        }
                
        }
    }
}

struct MovementView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MovementView()
            MovementView()
                .previewDevice("iPhone 8")
        }
    }
}
