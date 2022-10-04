//
//  WorkoutRepositoryTest.swift
//  ComoveTests
//
//  Created by akozin on 03.10.2022.
//

import XCTest
import CoreData
@testable import Comove

class WorkoutRepositoryTest: XCTestCase {

    func testSaveWorkout_shouldInsertNewEntityToContext() throws {
        // given
        let context = NSManagedObjectContext(.mainQueue)
        XCTAssertEqual(context.insertedObjects.count, 0)
        let repo = LocalWorkoutRepository(context: context)
        // when
        repo.addWorkout(duration: 10 * 60 * 60, distance: 1000)
        // then
        XCTAssertEqual(context.insertedObjects.count, 1)
        XCTAssertTrue(context.insertedObjects.first! is WorkoutEntity)
    }
    
}
