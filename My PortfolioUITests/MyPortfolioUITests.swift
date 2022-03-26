//
//  MyPortfolioUITests.swift
//  My PortfolioUITests
//
//  Created by Juan Diego Ocampo on 25/03/22.
//

import XCTest

class MyPortfolioUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs. Also, it’s important to set the
        // initial state - such as interface orientation - required for your tests before they run.
        // The setUp method is a good place to do this.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAppHasFourTabs() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app.")
    }
    
    func testOpenTabAddsProjects() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should not be any project created at the very first runtime.")
        for tapCount in 1...5 {
            app.buttons["New Project"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) projects at this point.")
        }
    }
    
    func testAddingItemsInsertsRows() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should not be any project created at the very first runtime.")
        app.buttons["New Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 project at this point.")
        for tapCount in 1...5 {
            app.buttons["Add New Item"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount + 1, "There should be \(tapCount + 1) list rows.")
        }
    }
    
    func testDeletingProjectClearsProjectsView() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should not be any project created at the very first runtime.")
        app.buttons["New Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 project at this point.")
        for tapCount in 1...3 {
            app.buttons["Add New Item"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount + 1, "There should be \(tapCount + 1) list rows.")
        }
        app.buttons["Compose"].tap()
        app.buttons["Delete this Project"].tap()
        app.buttons["Delete"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should not be any rows after deleting the first project.")
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testEditingProjectUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should not be any project created at the very first runtime.")
        app.buttons["New Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 project at this point.")
        app.buttons["Compose"].tap()
        app.textFields["Name"].tap()
        app.keys["espacio"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["intro"].tap()
        app.buttons["Back"].tap()
        XCTAssertTrue(app.textViews["NEW PROJECT 2"].exists, "The new project Name should be visible on the list.")
    }
    
    func testEditingItemsUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should not be any project created at the very first runtime.")
        app.buttons["New Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 project at this point.")
        app.buttons["Add New Item"].tap()
        app.buttons["New Item, low priority."].tap()
        app.textFields["Title"].tap()
        app.keys["espacio"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["intro"].tap()
        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.textViews["New Item 2"].exists, "The new item Title should be visible on the list.")
    }
    
    func testAllAwardsShowLockedAlert() {
        app.buttons["Awards"].tap()
        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists, "Alert shown should be \"Locked\" for all items at 1st runtime.")
            app.buttons["OK"].tap()
        }
    }
    
}
