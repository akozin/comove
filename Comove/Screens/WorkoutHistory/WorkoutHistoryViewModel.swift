//
//  WorkoutHistoryViewModel.swift
//  Comove
//
//  Created by akozin on 06.10.2022.
//

import Foundation
import CoreLocation
import CoreData

struct WorkoutHistoryViewModel {
    static var fetchRequest: NSFetchRequest<WorkoutEntity> {
        let request = WorkoutEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \WorkoutEntity.timestamp, ascending: false)
        ]
        return request
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let formattedDate = formatter.string(from: date)
        let format = NSLocalizedString("workout_date_label", comment: "")
        return NSString(format: format as NSString, formattedDate) as String
    }
    
    func formatDuration(_ duration: Int32) -> String {
        let formatter = DurationFormatter()
        let convertedDuration = TimeInterval(duration)
        let formattedDuration = formatter.formatDuration(durationValue: convertedDuration)
        let format = NSLocalizedString("workout_duration_label", comment: "")
        return NSString(format: format as NSString, formattedDuration) as String
    }
    
    func formatDistance(_ distance: Int32) -> String {
        let formatter = DistanceFormatter()
        let formattedDistance = formatter.formatDistance(CLLocationDistance(distance))
        let format = NSLocalizedString("workout_distance_label", comment: "")
        return NSString(format: format as NSString, formattedDistance) as String
    }
}
