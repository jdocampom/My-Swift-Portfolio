//
//  DevelopmentTests.swift
//  My PortfolioTests
//
//  Created by Juan Diego Ocampo on 25/03/22.
//

import CoreData
@testable import My_Portfolio
import XCTest

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "There should be 50 sample items.")
    }

    func testClearAllWorks() throws {
        try dataController.createSampleData()
        dataController.clearAll()
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "There should be no sample projects.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0, "There should be no sample items.")
    }

    func testExampleProjectIsClosed() {
        let project = Project.example
        XCTAssertTrue(project.completed, "The example project should be completed by default.")
    }

    func testExampleItemIsHighPriority() {
        let item = Item.example
        XCTAssertEqual(item.priority, 3, "The example item should be of high priority by default (priority = 3).")
    }
}
