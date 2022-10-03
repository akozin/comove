//
//  MovementViewModelTest.swift
//  ComoveTests
//
//  Created by akozin on 15.09.2022.
//

import XCTest
import Combine
import CoreLocation
@testable import Comove

class MovementViewModelTest: XCTestCase {

    func testSpeed_withPositiveValue_shouldBeProperlyConverted() {
        // given
        let metersPerSecondSpeed: CLLocationSpeed = 10
        let milesPerHourSpeed: CLLocationSpeed = 22.4
        let location = makeLocation(speed: metersPerSecondSpeed)
        // when
        let viewModel = WorkoutViewModel(locationPublisher: Just(location).eraseToAnyPublisher())
        // then
        XCTAssertEqual(viewModel.speed, "\(milesPerHourSpeed) mph")
    }
    
    func testSpeed_withNegativeValue_shouldEqualsZero() {
        // given
        let invalidSpeed: CLLocationSpeed = -25
        let location = makeLocation(speed: invalidSpeed)
        // when
        let viewModel = WorkoutViewModel(locationPublisher: Just(location).eraseToAnyPublisher())
        // then
        XCTAssertEqual(viewModel.speed, "0 mph")
    }
    
    func testPace_withPosiviteSpeed_shouldBeCalculatedProperly() {
        // given
        let metersPerSecondSpeed: CLLocationSpeed = 2.7
        let minPerMilePace: CLLocationSpeed = 9.9
        let location = makeLocation(speed: metersPerSecondSpeed)
        // when
        let viewModel = WorkoutViewModel(locationPublisher: Just(location).eraseToAnyPublisher())
        // then
        XCTAssertEqual(viewModel.pace, "\(minPerMilePace) min/mile")
    }

    func testPace_withInvalidSpeed_shouldEqualsZero() {
        // given
        let invalidSpeed: CLLocationSpeed = -1
        let location = makeLocation(speed: invalidSpeed)
        // when
        let viewModel = WorkoutViewModel(locationPublisher: Just(location).eraseToAnyPublisher())
        // then
        XCTAssertEqual(viewModel.pace, "0 min/mile")
    }
    
    func testDuration_withOngoingWorkout_shouldReturnDurationSinceWorkoutStart() {
        // given
        let publisher = Empty<CLLocation, Never>().eraseToAnyPublisher()
        let viewModel = WorkoutViewModel(locationPublisher: publisher)
        // when
        viewModel.isWorkoutStarted = true
        let exp = expectation(description: "")
        let delayInSeconds: Double = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            exp.fulfill()
        }
        // then
        let formatter = secondsNumberFormatter()
        let delayNumber = NSNumber(floatLiteral: delayInSeconds)
        let formattedDelay = formatter.string(from: delayNumber)!
        wait(for: [exp], timeout: 5.0)
        XCTAssertEqual(viewModel.duration, "00:00:0\(formattedDelay)")
    }
    
    func testDistance_withTwoCloseLocations_shouldReturnFormattedDistance() {
        // given
        let metersPerSecondSpeed: CLLocationSpeed = 2.7
        let firstLocation = makeLocation(speed: metersPerSecondSpeed, latitude: 53.12345)
        let secondLocation = makeLocation(speed: metersPerSecondSpeed, latitude: 53.12385)
        let subject = PassthroughSubject<CLLocation, Never>()
        let viewModel = WorkoutViewModel(locationPublisher: subject.eraseToAnyPublisher())
        // when
        subject.send(firstLocation)
        subject.send(secondLocation)
        // then
        XCTAssertEqual(viewModel.distance, "0.03mi")
    }
    
    func testDistance_withTwoDistantLocations_shouldReturnFormattedDistance() {
        // given
        let metersPerSecondSpeed: CLLocationSpeed = 2.7
        let firstLocation = makeLocation(speed: metersPerSecondSpeed, latitude: 53.12345)
        let secondLocation = makeLocation(speed: metersPerSecondSpeed, latitude: 53.22345)
        // 6955
        let subject = PassthroughSubject<CLLocation, Never>()
        let viewModel = WorkoutViewModel(locationPublisher: subject.eraseToAnyPublisher())
        // when
        subject.send(firstLocation)
        subject.send(secondLocation)
        // then
        XCTAssertEqual(viewModel.distance, "6.92mi")
    }
    
    func testDuration_withStoppedWorkout_shouldEqualsZero() {
        // given
        let publisher = Empty<CLLocation, Never>().eraseToAnyPublisher()
        let viewModel = WorkoutViewModel(locationPublisher: publisher)
        // when
        viewModel.isWorkoutStarted = false
        // then
        XCTAssertEqual(viewModel.duration, "00:00:00")
    }
    
    func testDuration_withStartedWorkout_shouldEqualsZero() {
        // given
        let publisher = Empty<CLLocation, Never>().eraseToAnyPublisher()
        let viewModel = WorkoutViewModel(locationPublisher: publisher)
        // when
        viewModel.isWorkoutStarted = true
        // then
        XCTAssertEqual(viewModel.duration, "00:00:00")
    }
    
    func testSpeed_withStartedWorkout_shouldEqualsZero() {
        // given
        let publisher = Empty<CLLocation, Never>().eraseToAnyPublisher()
        let viewModel = WorkoutViewModel(locationPublisher: publisher)
        // when
        viewModel.isWorkoutStarted = true
        // then
        XCTAssertEqual(viewModel.speed, "0 mph")
    }
    
    func testSpeed_withStoppedWorkout_shouldEqualsZero() {
        // given
        let publisher = Empty<CLLocation, Never>().eraseToAnyPublisher()
        let viewModel = WorkoutViewModel(locationPublisher: publisher)
        // when
        viewModel.isWorkoutStarted = false
        // then
        XCTAssertEqual(viewModel.speed, "0 mph")
    }
    
    func testPace_withStartedWorkout_shouldEqualsZero() {
        // given
        let publisher = Empty<CLLocation, Never>().eraseToAnyPublisher()
        let viewModel = WorkoutViewModel(locationPublisher: publisher)
        // when
        viewModel.isWorkoutStarted = true
        // then
        XCTAssertEqual(viewModel.pace, "0 min/mile")
    }
    
    func testPace_withStoppedWorkout_shouldEqualsZero() {
        // given
        let publisher = Empty<CLLocation, Never>().eraseToAnyPublisher()
        let viewModel = WorkoutViewModel(locationPublisher: publisher)
        // when
        viewModel.isWorkoutStarted = false
        // then
        XCTAssertEqual(viewModel.pace, "0 min/mile")
    }
    
    func testDistance_withStartedWorkout_shouldEqualsZero() {
        // given
        let publisher = Empty<CLLocation, Never>().eraseToAnyPublisher()
        let viewModel = WorkoutViewModel(locationPublisher: publisher)
        // when
        viewModel.isWorkoutStarted = true
        // then
        XCTAssertEqual(viewModel.distance, "0.00mi")
    }
    
    func testDistance_withStoppedWorkout_shouldEqualsZero() {
        // given
        let publisher = Empty<CLLocation, Never>().eraseToAnyPublisher()
        let viewModel = WorkoutViewModel(locationPublisher: publisher)
        // when
        viewModel.isWorkoutStarted = false
        // then
        XCTAssertEqual(viewModel.distance, "0.00mi")
    }
    
    func testDistance_withStoppedOngoingWorkout_shouldEqualsZero() {
        // given
        let metersPerSecondSpeed: CLLocationSpeed = 2.7
        let firstLocation = makeLocation(speed: metersPerSecondSpeed, latitude: 53.12345)
        let secondLocation = makeLocation(speed: metersPerSecondSpeed, latitude: 53.12385)
        let subject = PassthroughSubject<CLLocation, Never>()
        let viewModel = WorkoutViewModel(locationPublisher: subject.eraseToAnyPublisher())
        subject.send(firstLocation)
        subject.send(secondLocation)
        // when
        viewModel.isWorkoutStarted = false
        // then
        XCTAssertEqual(viewModel.distance, "0.00mi")
    }
    
    // MARK: - Private
    
    private func makeLocation(speed: CLLocationSpeed = 2.7,
                              latitude: CLLocationDegrees = 53.12345) -> CLLocation {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: 57.12345)
        return CLLocation(coordinate: coordinate,
                          altitude: 100, horizontalAccuracy: 10,
                          verticalAccuracy: 10,
                          course: 10,
                          courseAccuracy: 10, speed: speed,
                          speedAccuracy: 1,
                          timestamp: .now
        )
    }
    
    private func secondsNumberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter
    }

}


