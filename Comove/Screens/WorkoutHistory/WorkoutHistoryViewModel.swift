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
        return formatter.string(from: date)
    }
    
    func formatDuration(_ duration: Int32) -> String {
        let formatter = DurationFormatter()
        let convertedDuration = TimeInterval(duration)
        return formatter.formatDuration(durationValue: convertedDuration)
    }
    
    func formatDistance(_ distance: Int32) -> String {
        let formatter = DistanceFormatter()
        return formatter.formatDistance(CLLocationDistance(distance))
    }
}
