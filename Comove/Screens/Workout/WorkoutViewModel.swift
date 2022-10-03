//
//  WorkoutViewModel.swift
//  Comove
//
//  Created by akozin on 15.09.2022.
//

import Foundation
import CoreLocation
import Combine

class WorkoutViewModel: ObservableObject {
    let locationPublisher: AnyPublisher<CLLocation, Never>
    @Published var speed: String = ""
    @Published var pace: String = ""
    @Published var duration: String = ""
    @Published var distance: String = ""
    
    private var workoutStartDate: Date?
    @Published var isWorkoutStarted: Bool = false {
        didSet {
            workoutStartDate = Date()
            updateDuration()
            if isWorkoutStarted {
                startDurationUpdateTimer()
            } else {
                resetDistance()                
                stopDurationUpdateTimer()
            }
        }
    }
    /// Total travelled distance.
    private var distanceValue: CLLocationDistance = 0
    private var lastObtainedLocation: CLLocation?
    private var locationCancellable: AnyCancellable?
    private var timerCancellable: AnyCancellable?
    private let timerPublisher = Timer.publish(every: 1.0, on: .main, in: .default).autoconnect()
    
    init(locationPublisher: AnyPublisher<CLLocation, Never>) {
        self.locationPublisher = locationPublisher
        self.updateSpeedAndPace(speed: 0)
        self.resetDistance()
        self.subscribeToLocationPublisher()
    }
    
    private func subscribeToLocationPublisher() {
        locationCancellable = self.locationPublisher.sink { [weak self] location in
            guard let self = self else { return }
  
            self.updateDistance(location: location)
            self.updateSpeedAndPace(speed: location.speed)
            
            self.lastObtainedLocation = location
        }
    }
    
    private func startDurationUpdateTimer() {
        timerCancellable = timerPublisher.sink { [weak self] _ in
            self?.updateDuration()
        }
    }
    
    private func resetDistance() {
        distanceValue = 0
        updateDistance(location: nil)
    }
    
    private func updateDistance(location currentLocation: CLLocation?) {
        if let previousLocation = self.lastObtainedLocation,
            let currentLocation = currentLocation {
            let travelledDistance = currentLocation.distance(from: previousLocation)
            self.distanceValue += travelledDistance
        }
        let formatter = DistanceFormatter()
        self.distance = formatter.formatDistance(distanceValue)
    }
    
    private func updateSpeedAndPace(speed speedValue: CLLocationSpeed) {
        guard speedValue >= 0 else { return }
        
        let speedFormatter = SpeedFormatter()
        self.speed = speedFormatter.formatSpeed(speedValue)
        let paceFormatter = PaceFormatter()
        self.pace = paceFormatter.formatPace(speed: speedValue)
    }
    
    private func updateDuration() {
        let formatter = DurationFormatter()
        if let startDate = workoutStartDate {
            self.duration = formatter.formatDuration(movementStartDate: startDate)
        } else {
            self.duration = ""
        }
    }
    
    private func stopDurationUpdateTimer() {
        timerCancellable?.cancel()
    }
}

fileprivate extension NumberFormatter {
    /// Formatter, which add leading zero to one-digit number.
    /// For example, "3" will be formatted as "03" and "12" will be formatted as "12".
    static var twoDigitsNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    /// Formatter, which produces number with one digit after decimal point.
    static var oneFractionDigitFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }
    
    /// Formatter, which produces number with two digits after decimal point.
    static var twoFractionDigitsFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
}

fileprivate class PaceFormatter {
    private var kDefaultFormattedPace = "0"
    
    func formatPace(speed: CLLocationSpeed) -> String {
        guard speed > 0 else {
            let unit = paceMeasurementUnit()
            return "\(kDefaultFormattedPace) \(unit)"
        }
        
        let pace = pace(speed: speed)
        let paceNumber = NSNumber(floatLiteral: pace)
        let formattedPace = NumberFormatter.oneFractionDigitFormatter
            .string(from: paceNumber) ?? kDefaultFormattedPace
        let unit = paceMeasurementUnit()
        return "\(formattedPace) \(unit)"
    }
    
    private func pace(speed: CLLocationSpeed) -> Double {
        let metersPerMile: Double = 1609.34
        let metersPerKm: Double = 1000
        let distance = Locale.isEnUSLocale ? metersPerMile : metersPerKm
        return distance / (speed * 60)
    }
    
    private func paceMeasurementUnit() -> String {
        if Locale.isEnUSLocale {
            return NSLocalizedString("pace_min_mile_unit", comment: "")
        }
        return NSLocalizedString("pace_min_km_unit", comment: "")
    }
}

fileprivate class SpeedFormatter {
    /// Converts speed from mps to kph or mph depending on Locale and
    /// returns its textual representation.
    /// - Parameter speed: Speed in meters per second.
    /// - Returns: Formatted speed in kph or mph depending on locale.
    func formatSpeed(_ speed: CLLocationSpeed) -> String {
        var measurement = Measurement(value: speed, unit: UnitSpeed.metersPerSecond)
        if Locale.isEnUSLocale {
            measurement.convert(to: UnitSpeed.milesPerHour)
        } else {
            measurement.convert(to: UnitSpeed.kilometersPerHour)
        }
        let formatter = MeasurementFormatter()
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter = numberFormatter
        return formatter.string(from: measurement)
    }
}

fileprivate class DurationFormatter {
    /// Formats duration in "hh:mm:ss" format.
    func formatDuration(movementStartDate: Date) -> String {
        let durationValue = getDurationValue(startDate: movementStartDate)
        let hour = Int(durationValue / 3600)
        let minute = (Int(durationValue) - hour * 3600) / 60
        let second = Int(durationValue) - hour * 3600 - minute * 60
        let formatter = NumberFormatter.twoDigitsNumberFormatter
        if let hour = formatter.string(from: NSNumber(value: hour)),
           let minute = formatter.string(from: NSNumber(value: minute)),
           let second = formatter.string(from: NSNumber(value: second)) {
            return "\(hour):\(minute):\(second)"
        }
        return ""
    }
    
    /// Returns movement duration since the start of the movement.
    private func getDurationValue(startDate: Date) -> TimeInterval {
        return Date().timeIntervalSince(startDate)
    }
}

fileprivate class DistanceFormatter {
    /// Formats distance using two digits after decimal point.
    func formatDistance(_ distance: CLLocationDistance) -> String {
        let lenght = Measurement(value: distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter = .twoFractionDigitsFormatter
        return formatter.string(from: lenght)
    }
}


fileprivate extension Locale {
    /// Whether current locale is "en_US".
    static var isEnUSLocale: Bool {
        current.identifier == "en_US"
    }
}
