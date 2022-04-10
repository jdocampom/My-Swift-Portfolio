//
//  AssetTest.swift
//  My PortfolioTests
//
//  Created by Juan Diego Ocampo on 25/03/22.
//

@testable import My_Portfolio
import XCTest

class AssetTest: XCTestCase {
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "❌ - FAILED TO LOAD \(color) FROM ASSET CATALOG - ❌")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "❌ - FAILED TO LOAD AWARDS FROM JSON FILE - ❌")
    }
}
