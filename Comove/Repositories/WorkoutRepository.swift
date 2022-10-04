//
//  WorkoutRepository.swift
//  Comove
//
//  Created by akozin on 03.10.2022.
//

import Foundation
import CoreData

/// Repository, which manages saving and fetching workouts.
protocol WorkoutRepository {
    /// Adds workout to repository.
    /// - Parameters:
    ///   - duration: Workout duration in seconds.
    ///   - distance: Workout distance in meters.
    func addWorkout(duration: Int32, distance: Int32)
}

struct LocalWorkoutRepository: WorkoutRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addWorkout(duration: Int32, distance: Int32) {
        let workout = WorkoutEntity(context: context)
        workout.distance = distance
        workout.duration = duration
        do {
            try context.save()
            print("Workout saved!")
        } catch {
            print("Workout saving error!")
            print(error.localizedDescription)
        }
    }
}
