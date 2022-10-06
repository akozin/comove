//
//  WorkoutEntity+CoreDataProperties.swift
//  Comove
//
//  Created by akozin on 03.10.2022.
//
//

import Foundation
import CoreData

extension WorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var distance: Int32
    @NSManaged public var duration: Int32
    @NSManaged public var timestamp: Date
    public var speed: Int32 {
        return 0
    }
    public var pace: Int32 {
        return 0
    }

}

extension WorkoutEntity : Identifiable {

}
