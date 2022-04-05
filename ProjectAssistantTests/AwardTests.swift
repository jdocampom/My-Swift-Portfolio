//
//  AwardTests.swift
//  My PortfolioTests
//
//  Created by Juan Diego Ocampo on 25/03/22.
//

import CoreData
import XCTest
@testable import My_Portfolio

class AwardTests: BaseTestCase {
    let awards = Award.allAwards
    
    func awardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award id should always match its name.")
        }
    }
    
    func testThatNewUserHasNoAwards() {
        for award in awards {
            XCTAssertFalse(dataController.hasEarnedAward(award), "New users should not have unlocked awards.")
        }
    }
    
    func testAddedItemsAward() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
        for (count, value) in values.enumerated() {
            for _ in 0..<value {
                _ = Item(context: managedObjectContext)
            }
            let matches = awards.filter { award in
                award.criterion == "items" && dataController.hasEarnedAward(award)
            }
            XCTAssertEqual(matches.count, count + 1, "Adding \(value) items should unlock \(count + 1) awards.")
            dataController.clearAll()
        }
    }
    
    func testCompletedItemsAward() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
        for (count, value) in values.enumerated() {
            for _ in 0..<value {
                let item = Item(context: managedObjectContext)
                item.completed = true
            }
            let matches = awards.filter { award in
                award.criterion == "complete" && dataController.hasEarnedAward(award)
            }
            XCTAssertEqual(matches.count, count + 1, "Completing \(value) items should unlock \(count + 1) awards.")
            dataController.clearAll()
        }
    }
    
}
