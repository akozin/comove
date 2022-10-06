//
//  WorkoutView.swift
//  Comove
//
//  Created by akozin on 20.08.2022.
//

import SwiftUI
import MapKit
import Combine

struct WorkoutView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject private var viewModel = WorkoutViewModel(
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
                        label: viewModel.isWorkoutStarted ? "stop_button_label" : "start_button_label",
                        action: {
                            if viewModel.isWorkoutStarted {
                                viewModel.saveWorkout(context: viewContext)
                                viewModel.isWorkoutStarted.toggle()
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                viewModel.isWorkoutStarted.toggle()
                            }
                        }
                    )
                    .padding(.bottom)
                }
                .toolbar {
                    ToolbarItem {
                        Button("cancel_button_label") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .navigationTitle("workout_title")
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
                
                if viewModel.isWorkoutStarted {
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
}

struct MovementView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WorkoutView()
        }
    }
}
