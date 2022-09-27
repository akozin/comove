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
    @StateObject private var viewModel = MovementViewModel(
        locationPublisher: LocationService.shared.locationPublisher
    )
    
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
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ZStack(alignment: .bottom) {
                    MapViewWrapper(showRoute: $viewModel.isWorkoutStarted,
                                   regionPublisher: mapRegionPublisher)
                    StartButtonView(
                        label: viewModel.isWorkoutStarted ? "Stop" : "Start",
                        action: { viewModel.isWorkoutStarted.toggle() }
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
                WorkoutIndicatorsBarView(
                    speed: viewModel.speed,
                    distance: viewModel.distance,
                    pace: viewModel.pace,
                    duration: viewModel.duration
                )
            }
                
        }
    }
}

struct MovementView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MovementView()
        }
    }
}
