//
//  PerformanceTests.swift
//  My PortfolioTests
//
//  Created by Juan Diego Ocampo on 25/03/22.
//

import CoreData
import XCTest
@testable import My_Portfolio

class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformance() throws {
        for _ in 1...100 { try dataController.createSampleData() }
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        let errorMessage = "This checks that the number of awards is constant. Change it if you add more awards."
        XCTAssertEqual(awards.count, 500, errorMessage)
        measure {
            _ = awards.filter(dataController.hasEarnedAward(_:))
        }
        
    }
    
}
