//
//  Formatters.swift
//  Comove
//
//  Created by akozin on 06.10.2022.
//

import Foundation
import CoreLocation

struct DurationFormatter {
    /// Formats duration in "hh:mm:ss" format.
    func formatDuration(durationValue: TimeInterval) -> String {
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
}

struct DistanceFormatter {
    /// Formats distance using two digits after decimal point.
    func formatDistance(_ distance: CLLocationDistance) -> String {
        let lenght = Measurement(value: distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.numberFormatter = .twoFractionDigitsFormatter
        return formatter.string(from: lenght)
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
    
    /// Formatter, which produces number with two digits after decimal point.
    static var twoFractionDigitsFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
}
